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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTodoCubit(todo),
      child: Builder(
        builder: (providerContext) => Scaffold(
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
                    colors: [
                      const Color(0xFF1E6F9F),
                      const Color(0xFF1E6F9F).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E6F9F).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.check, color: Colors.white),
                  onPressed: () {
                    try {
                      final state = providerContext.read<EditTodoCubit>().state;
                      if (state.text.isEmpty) {
                        ScaffoldMessenger.of(providerContext).showSnackBar(
                          const SnackBar(content: Text('Title cannot be empty')),
                        );
                        return;
                      }

                      final authState = providerContext.read<AuthCubit>().state;
                      final userId = authState is Authenticated ? authState.user.id : "";
                      log('Saving todo for userId: $userId');

                      DateTime? finalDueDate;
                      if (state.dueDate != null) {
                        finalDueDate = DateTime(
                          state.dueDate!.year,
                          state.dueDate!.month,
                          state.dueDate!.day,
                          state.time?.hour ?? 23,
                          state.time?.minute ?? 59,
                        );
                        log('Saving dueDate: $finalDueDate');
                      }

                      providerContext.read<TodoBloc>().add(
                            UpdateTodo(
                              id: todo.id!,
                              userId: userId,
                              text: state.text,
                              description: state.description.isEmpty ? null : state.description,
                              dueDate: finalDueDate,
                            ),
                          );

                      Navigator.of(providerContext).pop();
                    } catch (e) {
                      log('Error saving todo: $e');
                      ScaffoldMessenger.of(providerContext).showSnackBar(
                        SnackBar(content: Text('Error saving todo: $e')),
                      );
                    }
                  },
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
                BlocBuilder<EditTodoCubit, EditTodoState>(
                  builder: (context, state) => Container(
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
                ),

                const SizedBox(height: 20),

                // Description Section
                BlocBuilder<EditTodoCubit, EditTodoState>(
                  builder: (context, state) => Container(
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
                ),

                const SizedBox(height: 20),

                // Due Date Section
                BlocBuilder<EditTodoCubit, EditTodoState>(
                  builder: (context, state) => Container(
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
                      onDateChanged: (date) => context
                          .read<EditTodoCubit>()
                          .updateDueDateAndTime(
                              date,
                              date != null
                                  ? state.time ?? const TimeOfDay(hour: 23, minute: 59)
                                  : null),
                      onTimeChanged: (time) => context
                          .read<EditTodoCubit>()
                          .updateDueDateAndTime(state.dueDate, time),
                    ),
                  ),
                ),

                // Detailed Date Display
                BlocBuilder<EditTodoCubit, EditTodoState>(
                  builder: (context, state) {
                    if (state.dueDate == null) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, left: 20),
                      child: Text(
                        DateFormat('EEEE, MMMM d, y').format(state.dueDate!),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}