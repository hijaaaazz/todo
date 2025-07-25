import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:intl/intl.dart';


class TodoDetailedPage extends StatefulWidget {
  final TodoEntity todo;

  const TodoDetailedPage({super.key, required this.todo});

  @override
  State<TodoDetailedPage> createState() => _TodoDetailedPageState();
}

class _TodoDetailedPageState extends State<TodoDetailedPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDueDate;
  late bool _isCompleted;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.text);
    _descriptionController = TextEditingController(text: widget.todo.description);
    _selectedDueDate = widget.todo.dueDate;
    _isCompleted = widget.todo.isCompleted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF1E6F9F),
              onPrimary: Colors.white,
              surface: Colors.white.withOpacity(0.08),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.white.withOpacity(0.08),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _saveTodo() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    context.read<TodoBloc>().add(UpdateTodo(
      widget.todo.id,
      _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDueDate,
    ));

    if (_isCompleted != widget.todo.isCompleted) {
      context.read<TodoBloc>().add(ToggleTodo(widget.todo.id));
    }

    Navigator.of(context).pop();
  }

  void _deleteTodo() {
    context.read<TodoBloc>().add(DeleteTodo(widget.todo.id));
    Navigator.of(context).pop();
  }

  Color _getDueDateColor() {
    if (_isCompleted) {
      return Colors.white.withOpacity(0.4);
    }
    if (_selectedDueDate == null) {
      return Colors.white.withOpacity(0.6);
    }
    final now = DateTime.now();
    final difference = _selectedDueDate!.difference(now).inDays;
    if (difference < 0) {
      return Colors.red.withOpacity(0.8); // Overdue
    } else if (difference == 0) {
      return Colors.orange.withOpacity(0.8); // Due today
    } else if (difference <= 3) {
      return Colors.yellow.withOpacity(0.8); // Due soon
    } else {
      return Colors.white.withOpacity(0.6); // Normal
    }
  }

  String _formatDueDate(DateTime? dueDate) {
    if (dueDate == null) return 'No due date';
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    if (difference < 0) {
      return 'Overdue';
    } else if (difference == 0) {
      return 'Due today';
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else if (difference <= 7) {
      return 'Due in $difference days';
    } else {
      return 'Due ${DateFormat('d MMM').format(dueDate)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Match TodoModelWidget background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: Colors.red.withOpacity(0.8)),
            onPressed: _deleteTodo,
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveTodo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              style: TextStyle(
                color: _isCompleted ? Colors.white.withOpacity(0.5) : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                decoration: _isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: Colors.white.withOpacity(0.5),
                decorationThickness: 2,
              ),
              decoration: InputDecoration(
                hintText: 'Task title',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              style: TextStyle(
                color: _isCompleted ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                decoration: _isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: Colors.white.withOpacity(0.3),
              ),
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),

            // Due Date
            GestureDetector(
              onTap: () => _selectDueDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 18,
                      color: _getDueDateColor(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDueDate(_selectedDueDate),
                      style: TextStyle(
                        color: _getDueDateColor(),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Completed Toggle
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCompleted = !_isCompleted;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isCompleted ? const Color(0xFF1E6F9F) : Colors.transparent,
                        border: Border.all(
                          color: _isCompleted
                              ? const Color(0xFF1E6F9F)
                              : Colors.white.withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: _isCompleted
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF1E6F9F).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: _isCompleted
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}