import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';

class SearchBarWithButton extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const SearchBarWithButton({
    super.key,
    required this.controller,
    required this.onAdd,
  });

  @override
  State<SearchBarWithButton> createState() => _SearchBarWithButtonState();
}

class _SearchBarWithButtonState extends State<SearchBarWithButton> {
  bool _isFocused = false;
  DateTime? _selectedSearchDate;

  Future<void> _selectSearchDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedSearchDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1E6F9F),
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A1A1A),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedSearchDate = picked;
      });
      context.read<TodoBloc>().add(SearchByDate(picked));
    }
  }

  void _clearDateFilter() {
    setState(() {
      _selectedSearchDate = null;
    });
    context.read<TodoBloc>().add(ClearDateFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (focused) {
            setState(() {
              _isFocused = focused;
            });
          },
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: const Color(0xFF1E6F9F),
                  decoration: InputDecoration(
                    hintText: 'Search your tasks...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white.withOpacity(0.6),
                      size: 20,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none
                  ),
                ),
              ),
             
            ],
          ),
        ),
        if (_selectedSearchDate != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.filter_list_rounded,
                  color: Color(0xFF1E6F9F), size: 16),
              const SizedBox(width: 6),
              Text(
                'Due: ${_formatDate(_selectedSearchDate!)}',
                style: const TextStyle(
                  color: Color(0xFF1E6F9F),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _clearDateFilter,
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF1E6F9F),
                  size: 16,
                ),
              ),
            ],
          ),
        ]
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}
