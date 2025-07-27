import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/edit_todo/edit_todo_cubit.dart';

class DescriptionSection extends StatelessWidget {
  final String description;

  const DescriptionSection({super.key, required this.description});

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
            'Description',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) =>
                context.read<EditTodoCubit>().updateDescription(value),
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
            controller: TextEditingController(text: description)
              ..selection = TextSelection.fromPosition(
                  TextPosition(offset: description.length)),
          ),
        ],
      ),
    );
  }
}