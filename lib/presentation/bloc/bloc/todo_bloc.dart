import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/service_locator.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<SearchTodos>(_onSearchTodos);
    on<SearchByDate>(_onSearchByDate);
    on<ClearDateFilter>(_onClearDateFilter);
    on<SelectTab>(_onSelectTab);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(event.userId);
      final todoCollection = userDoc.collection('todos');
      final collectionSnapshot = await todoCollection.limit(1).get();
      if (collectionSnapshot.docs.isEmpty) {
        await todoCollection.doc('initial').set({'initialized': true});
        await todoCollection.doc('initial').delete();
      }

      final result = await sl<GetTodosUsecase>().call(params: event.userId);
      result.fold(
        (l) => emit(TodoError(l)),
        (r) => emit(TodoLoaded(todos: r)),
      );
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final result = await sl<AddTodoUsecase>().call(
      params: AddTodoParams(
        id: id,
        title: event.text,
        description: event.description ?? "",
        duedate: event.dueDate,
        userId: event.userId ?? "",
      ),
    );

    result.fold(
      (failure) => emit(TodoError(failure)),
      (newTodo) {
        if (state is TodoLoaded) {
          final currentState = state as TodoLoaded;
          final updatedTodos = List<TodoEntity>.from(currentState.todos)..add(newTodo);
          emit(currentState.copyWith(todos: updatedTodos));
        } else {
          emit(TodoLoaded(todos: [newTodo]));
        }
      },
    );
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      final updatedTodos = currentState.todos.map((todo) {
        if (todo.id == event.id) {
          return TodoEntity(
            id: event.id,
            text: event.text,
            description: event.description ?? "",
            dueDate: event.dueDate,
            isCompleted: todo.isCompleted,
            createdAt: todo.createdAt,
          );
        }
        return todo;
      }).toList();
      emit(currentState.copyWith(todos: updatedTodos));
    }
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      final updatedTodos = currentState.todos.map((todo) {
        if (todo.id == event.id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList();
      emit(currentState.copyWith(todos: updatedTodos));
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      final updatedTodos = currentState.todos.where((todo) => todo.id != event.id).toList();
      emit(currentState.copyWith(todos: updatedTodos));
    }
  }

  void _onSearchTodos(SearchTodos event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  void _onSearchByDate(SearchByDate event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      emit(currentState.copyWith(searchDate: event.date));
    }
  }

  void _onClearDateFilter(ClearDateFilter event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      emit(currentState.copyWith(clearSearchDate: true));
    }
  }

  void _onSelectTab(SelectTab event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      emit(currentState.copyWith(selectedTab: event.tab));
    }
  }
}