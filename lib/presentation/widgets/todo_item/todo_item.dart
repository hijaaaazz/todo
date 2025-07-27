import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/core/theme/app_theme.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/pages/todo.dart';
import 'package:tudu/presentation/widgets/home/delete_confirmation.dart';
import 'package:tudu/presentation/widgets/todo_item/action_button.dart';
import 'package:tudu/presentation/widgets/todo_item/check_boc.dart';
import 'package:tudu/presentation/widgets/todo_item/item-container.dart';
import 'package:tudu/presentation/widgets/todo_item/task_content.dart';

class TodoItem extends StatefulWidget {
  final TodoEntity todo;

  const TodoItem({
    super.key,
    required this.todo,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  void _handleToggleTodo() {
    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : "";

    context.read<TodoBloc>().add(
          ToggleTodo(
            id: widget.todo.id,
            userId: userId,
            status: !widget.todo.isCompleted,
          ),
        );
  }

  void _handleDeleteTodo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.transparent,
      elevation: 0,
      builder: (context) => BlocProvider.value(
        value: context.read<TodoBloc>(),
        child: DeleteTodoBottomSheet(todo: widget.todo),
      ),
    );
  }

  void _navigateToDetail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TodoDetailedPage(todo: widget.todo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TodoItemContainer(
      isCompleted: widget.todo.isCompleted,
      onTap: _navigateToDetail,
      child: Row(
        children: [
          TodoCheckbox(
            isCompleted: widget.todo.isCompleted,
            onTap: _handleToggleTodo,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TodoTaskContent(
              text: widget.todo.text,
              dueDate: widget.todo.dueDate,
              isCompleted: widget.todo.isCompleted,
            ),
          ),
          TodoActionButtons(
            onDelete: _handleDeleteTodo,
          ),
        ],
      ),
    );
  }
}