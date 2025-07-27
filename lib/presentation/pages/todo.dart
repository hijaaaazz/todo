import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/core/theme/app_theme.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/bloc/edit_todo/edit_todo_cubit.dart';
import 'package:tudu/presentation/widgets/todo_detailed_page/description.dart';
import 'package:tudu/presentation/widgets/todo_detailed_page/due_date.dart';
import 'package:tudu/presentation/widgets/todo_detailed_page/save.dart';
import 'package:tudu/presentation/widgets/todo_detailed_page/task_title.dart';

class TodoDetailedPage extends StatelessWidget {
  final TodoEntity todo;

  const TodoDetailedPage({super.key, required this.todo});

  void _saveTodo(BuildContext context, EditTodoState state) {
    final text = state.text.trim();
    final date = state.dueDate;
    if (text.isEmpty || date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title and due date are required')),
      );
      return;
    }

    DateTime? finalDueDate;
    if (state.dueDate != null && state.time != null) {
      finalDueDate = DateTime(
        state.dueDate!.year,
        state.dueDate!.month,
        state.dueDate!.day,
        state.time!.hour,
        state.time!.minute,
      );
    }

    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : null;
   

    context.read<TodoBloc>().add(
          UpdateTodo(
            id: todo.id,
            userId: userId!,
            text: text,
            description: state.description.trim().isEmpty
                ? null
                : state.description.trim(),
            dueDate: finalDueDate,
          ),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    log('TodoDetailedPage: initial todo.dueDate=${todo.dueDate}');
    return BlocProvider(
      create: (context) => EditTodoCubit(todo),
      child: BlocBuilder<EditTodoCubit, EditTodoState>(
        buildWhen: (previous, current) =>
            previous.isValid != current.isValid ||
            previous.text != current.text ||
            previous.description != current.description ||
            previous.dueDate != current.dueDate ||
            previous.time != current.time,
        builder: (context, state) {
          return Scaffold(
            backgroundColor:AppTheme.background,
            appBar: AppBar(
              backgroundColor: AppTheme.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppTheme.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                SaveButton(
                  isValid: state.isValid,
                  onPressed: () => _saveTodo(context, state),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskTitleSection(text: state.text),
                  const SizedBox(height: 20),
                  DescriptionSection(description: state.description),
                  const SizedBox(height: 20),
                  DueDateSection(
                    dueDate: state.dueDate,
                    time: state.time,
                    isCompleted: todo.isCompleted,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}