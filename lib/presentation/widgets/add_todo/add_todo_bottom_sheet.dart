import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/core/theme/app_theme.dart';
import 'package:tudu/presentation/bloc/add_todo/add_todo.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/widgets/add_todo/date_display.dart';
import 'package:tudu/presentation/widgets/add_todo/date_picker_container.dart';
import 'package:tudu/presentation/widgets/bottom_sheet/action_button.dart';
import 'package:tudu/presentation/widgets/bottom_sheet/bottomsheet.dart';
import 'package:tudu/presentation/widgets/bottom_sheet/input_field.dart';
import 'package:tudu/utils/get_user_d.dart';

class AddTodoBottomSheet extends StatelessWidget {
  const AddTodoBottomSheet({super.key});

  void _addTodo(BuildContext context, AddTodoFormState formState) {
    final title = formState.title.trim();
    final date = formState.dueDate;
    if (title.isEmpty || date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title and due date are required')),
      );
      return;
    }

    DateTime? finalDueDate;
    if (formState.dueDate != null && formState.time != null) {
      finalDueDate = DateTime(
        formState.dueDate!.year,
        formState.dueDate!.month,
        formState.dueDate!.day,
        formState.time!.hour,
        formState.time!.minute,
      ).toLocal();
      log('AddTodoBottomSheet: finalDueDate=$finalDueDate');
    }

    final userId = getAuthenticatedUserId(context);
    if (userId == null) return;

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
          return BaseBottomSheet(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  label: 'Task Title',
                  hint: 'What needs to be done?',
                  icon: Icons.title_rounded,
                  initialValue: formState.title,
                  onChanged: (value) =>
                      context.read<AddTodoFormCubit>().updateTitle(value),
                ),
                const SizedBox(height: 16),
                InputField(
                  label: 'Description (Optional)',
                  hint: 'Add more details...',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                  initialValue: formState.description,
                  onChanged: (value) =>
                      context.read<AddTodoFormCubit>().updateDescription(value),
                ),
                const SizedBox(height: 16),
                DateTimePickerContainer(
                  dueDate: formState.dueDate,
                  time: formState.time,
                  isCompleted: false,
                  onDateTimeChanged: (date, time) {
                    log('AddTodoBottomSheet: onDateTimeChanged date=$date, time=$time');
                    context.read<AddTodoFormCubit>().updateDueDateAndTime(date, time);
                  },
                ),
                if (formState.dueDate != null)
                  DateDisplay(date: formState.dueDate!),
                const SizedBox(height: 20),
                ActionButtons(
                  actionText: 'Create',
                  actionColor: AppTheme.highlight,
                  isActionEnabled: formState.isValid,
                  onAction: () => _addTodo(context, formState),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}