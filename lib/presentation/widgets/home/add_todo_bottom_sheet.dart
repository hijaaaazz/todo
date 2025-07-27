import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/add_todo/add_todo.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'date_time_picker.dart';


class AddTodoBottomSheet extends StatelessWidget {
  const AddTodoBottomSheet({super.key});

  void _addTodo(BuildContext context, AddTodoFormState formState) {
    final title = formState.title.trim();
    if (title.isEmpty) return;

    DateTime? finalDueDate;
    if (formState.dueDate != null) {
      finalDueDate = DateTime(
        formState.dueDate!.year,
        formState.dueDate!.month,
        formState.dueDate!.day,
        formState.time?.hour ?? 23,
        formState.time?.minute ?? 59,
      );
    }

    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : null;

    context.read<TodoBloc>().add(AddTodoEvent(
          text: title,
          description: formState.description.trim().isEmpty
              ? null
              : formState.description.trim(),
          dueDate: finalDueDate,
          userId: userId,
        ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTodoFormCubit(),
      child: BlocBuilder<AddTodoFormCubit, AddTodoFormState>(
        builder: (context, formState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title Input
                  _buildInputField(
                    label: 'Task Title',
                    hint: 'What needs to be done?',
                    icon: Icons.title_rounded,
                    initialValue: formState.title,
                    onChanged: (value) => context.read<AddTodoFormCubit>().updateTitle(value),
                  ),
                  const SizedBox(height: 16),

                  // Description Input
                  _buildInputField(
                    label: 'Description (Optional)',
                    hint: 'Add more details...',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                    initialValue: formState.description,
                    onChanged: (value) => context.read<AddTodoFormCubit>().updateDescription(value),
                  ),
                  const SizedBox(height: 16),

                  // DateTime Picker
                  DateTimePicker(
                    initialDate: formState.dueDate,
                    initialTime: formState.time,
                    onDateChanged: (date) => context.read<AddTodoFormCubit>().updateDueDate(date),
                    onTimeChanged: (time) => context.read<AddTodoFormCubit>().updateTime(time),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: formState.isValid
                              ? () => _addTodo(context, formState)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: formState.isValid
                                ? const Color(0xFF1E6F9F)
                                : Colors.grey.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Create',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String initialValue = '',
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextFormField(
            initialValue: initialValue,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}