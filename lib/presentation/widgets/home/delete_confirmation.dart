import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/core/theme/app_theme.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/widgets/bottom_sheet/action_button.dart';
import 'package:tudu/presentation/widgets/bottom_sheet/bottomsheet.dart';
import 'package:tudu/presentation/widgets/home/delete_conform.dart';
import 'package:tudu/utils/get_user_d.dart';

class DeleteTodoBottomSheet extends StatelessWidget {
  final TodoEntity todo;

  const DeleteTodoBottomSheet({super.key, required this.todo});

  void _deleteTodo(BuildContext context) {
    final userId = getAuthenticatedUserId(context);
    if (userId == null) return;

    context.read<TodoBloc>().add(
          DeleteTodo(id: todo.id, userId: userId),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DeleteConfirmationSection(),
          ActionButtons(
            actionText: 'Delete Task',
            actionColor: AppTheme.red,
            onAction: () => _deleteTodo(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}