import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/bloc/edit_todo/edit_todo_cubit.dart';
import 'package:tudu/presentation/widgets/home/date_time_picker.dart';

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
      ).toLocal();
      log('TodoDetailedPage: Saving finalDueDate=$finalDueDate');
    }

    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : null;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    if (todo.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo ID is missing')),
      );
      return;
    }

    context.read<TodoBloc>().add(
          UpdateTodo(
            id: todo.id!,
            userId: userId,
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
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: state.isValid
                          ? [
                              const Color(0xFF1E6F9F),
                              const Color(0xFF1E6F9F).withOpacity(0.8),
                            ]
                          : [
                              Colors.grey.withOpacity(0.3),
                              Colors.grey.withOpacity(0.2),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: state.isValid
                            ? const Color(0xFF1E6F9F).withOpacity(0.3)
                            : Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, color: Colors.white),
                    onPressed: () => _saveTodo(context, state),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task Title',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (value) =>
                              context.read<EditTodoCubit>().updateText(value),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter task title',
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(
                              Icons.title_rounded,
                              color: Colors.white.withOpacity(0.6),
                              size: 20,
                            ),
                          ),
                          controller: TextEditingController(text: state.text)
                            ..selection = TextSelection.fromPosition(
                                TextPosition(offset: state.text.length)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (value) => context
                              .read<EditTodoCubit>()
                              .updateDescription(value),
                          maxLines: 5,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add description (optional)',
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(
                              Icons.description_outlined,
                              color: Colors.white.withOpacity(0.6),
                              size: 20,
                            ),
                          ),
                          controller:
                              TextEditingController(text: state.description)
                                ..selection = TextSelection.fromPosition(
                                    TextPosition(offset: state.description.length)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Due Date Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: DateTimePicker(
                      label: 'Due Date',
                      hintText: 'Set due date',
                      initialDate: state.dueDate,
                      initialTime: state.time,
                      onDateTimeChanged: (date, time) {
                        log('TodoDetailedPage: onDateTimeChanged called with date=$date, time=$time');
                        context.read<EditTodoCubit>().updateDueDateAndTime(date, time);
                      },
                    ),
                  ),

                  // Detailed Date Display
                  if (state.dueDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 20),
                      child: Text(
                        DateFormat('EEEE, MMMM d, y').format(state.dueDate!),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
  })
      );
  }
}