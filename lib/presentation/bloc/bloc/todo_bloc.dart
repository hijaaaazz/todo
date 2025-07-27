import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/data/models/add_todo_params.dart';
import 'package:tudu/data/models/delete_todo_params.dart';
import 'package:tudu/data/models/toggle_todo_params.dart';
import 'package:tudu/data/models/update_todo_params.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/domain/usecases/todo/add_todo.dart';
import 'package:tudu/domain/usecases/todo/delete_todo.dart';
import 'package:tudu/domain/usecases/todo/get_todo.dart';
import 'package:tudu/domain/usecases/todo/toggle_todo.dart';
import 'package:tudu/domain/usecases/todo/update_todo.dart';
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
    on<SelectTab>(_onSelectTab);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    final previousState = state;
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
        (failure) => emit(previousState is TodoLoaded 
            ? previousState 
            : TodoError(failure.toString())),
        (todos) => emit(TodoLoaded.initial(todos)),
      );
    } catch (e) {
      emit(previousState is TodoLoaded 
          ? previousState 
          : TodoError(e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) return;
    
    final currentState = state as TodoLoaded;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    final optimisticTodo = TodoEntity(
      id: id,
      text: event.text,
      description: event.description ?? "",
      dueDate: event.dueDate,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    // Optimistic update
    final updatedTodos = List<TodoEntity>.from(currentState.allTodos)..add(optimisticTodo);
    emit(currentState.copyWith(allTodos: updatedTodos));

    // Perform service call
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
      (failure) {
        // Revert to previous state on failure
        emit(currentState);
      },
      (newTodo) {
        // Update with actual todo from service
        final finalTodos = currentState.allTodos
            .map((todo) => todo.id == newTodo.id ? newTodo : todo)
            .toList();
        if (!finalTodos.any((todo) => todo.id == newTodo.id)) {
          finalTodos.add(newTodo);
        }
        emit(currentState.copyWith(allTodos: finalTodos));
      },
    );
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) return;
    
    final currentState = state as TodoLoaded;
    
    // Optimistic update
    final optimisticTodos = currentState.allTodos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(
          text: event.text,
          description: event.description ?? "",
          dueDate: event.dueDate,
        );
      }
      return todo;
    }).toList();
    
    emit(currentState.copyWith(allTodos: optimisticTodos));

    // Perform service call
    final result = await sl<UpdateTodoUsecase>().call(
      params: UpdateTodoParams(
        id: event.id,
        title: event.text,
        description: event.description ?? "",
        duedate: event.dueDate,
        userId: event.userId,
      ),
    );

    result.fold(
      (failure) {
        // Revert to previous state on failure
        emit(currentState);
      },
      (updatedTodo) {
        // Update with actual todo from service
        final updatedTodos = currentState.allTodos
            .map((todo) => todo.id == updatedTodo.id ? updatedTodo : todo)
            .toList();
        emit(currentState.copyWith(allTodos: updatedTodos));
      },
    );
  }

  Future<void> _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) return;
    
    final currentState = state as TodoLoaded;
    
    // Optimistic update
    final optimisticTodos = currentState.allTodos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(isCompleted: event.status);
      }
      return todo;
    }).toList();
    
    emit(currentState.copyWith(allTodos: optimisticTodos));

    // Perform service call
    final result = await sl<ToggleTodoUsecase>().call(
      params: ToggleTodoParams(
        todoId: event.id,
        userId: event.userId,
        status: event.status,
      ),
    );

    result.fold(
      (failure) {
        // Revert to previous state on failure
        emit(currentState);
      },
      (_) {
        // Optimistic update already applied, no need to change state again
      },
    );
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) return;
    
    final currentState = state as TodoLoaded;
    
    // Optimistic update
    final optimisticTodos = currentState.allTodos
        .where((todo) => todo.id != event.id)
        .toList();
    
    emit(currentState.copyWith(allTodos: optimisticTodos));

    // Perform service call
    final result = await sl<DeleteTodoUsecase>().call(
      params: DeleteTodoParams(id: event.id, userId: event.userId),
    );

    result.fold(
      (failure) {
        // Revert to previous state on failure
        emit(currentState);
      },
      (_) {
        // Optimistic update already applied, no need to change state again
      },
    );
  }

  void _onSearchTodos(SearchTodos event, Emitter<TodoState> emit) {
    if (state is! TodoLoaded) return;
    
    final currentState = state as TodoLoaded;
    emit(currentState.copyWith(searchQuery: event.query));
  }

  void _onSelectTab(SelectTab event, Emitter<TodoState> emit) {
    if (state is! TodoLoaded) return;
    
    final currentState = state as TodoLoaded;
    emit(currentState.copyWith(selectedTab: event.tab));
  }
}