import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/edit_todo/edit_todo_cubit.dart';

class TaskTitleSection extends StatelessWidget {
  final String text;

  const TaskTitleSection({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onChanged: (value) => context.read<EditTodoCubit>().updateText(value),
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
            controller: TextEditingController(text: text)
              ..selection = TextSelection.fromPosition(
                  TextPosition(offset: text.length)),
          ),
        ],
      ),
    );
  }
}