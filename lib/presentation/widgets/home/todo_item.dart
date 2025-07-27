import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/pages/todo.dart';
import 'package:tudu/presentation/widgets/home/delete_confirmation.dart';


class TodoItem extends StatefulWidget {
  final TodoEntity todo;

  const TodoItem({
    super.key,
    required this.todo,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem>{
 
  void _handleToggleTodo() {
    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : "";
    
    context.read<TodoBloc>().add(
      ToggleTodo(
        id: widget.todo.id,
        userId: userId,
        status: !widget.todo.isCompleted,
      ),
    );
  }

  void _handleDeleteTodo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => BlocProvider.value(
        value: context.read<TodoBloc>(),
        child: DeleteTodoBottomSheet(todo: widget.todo),
      ),
    );
  }

  void _navigateToDetail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TodoDetailedPage(todo: widget.todo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
    
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(widget.todo.isCompleted ? 0.06 : 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.todo.isCompleted 
                ? const Color(0xFF1E6F9F).withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          splashColor: const Color.fromARGB(0, 0, 0, 0),
          onTap: _navigateToDetail,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Checkbox
                  _buildCheckbox(),
                  const SizedBox(width: 16),
                
                  // Task Content
                  Expanded(
                    child: _buildTaskContent(),
                  ),
                
                  // Action Buttons
                  _buildActionButtons(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: _handleToggleTodo,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.todo.isCompleted
              ? const Color(0xFF1E6F9F)
              : Colors.transparent,
          border: Border.all(
            color: widget.todo.isCompleted
                ? const Color(0xFF1E6F9F)
                : Colors.white.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: widget.todo.isCompleted
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E6F9F).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: widget.todo.isCompleted
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 18,
              )
            : null,
      ),
    );
  }

  Widget _buildTaskContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.todo.text,
          style: TextStyle(
            color: widget.todo.isCompleted
                ? Colors.white.withOpacity(0.5)
                : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: widget.todo.isCompleted
                ? TextDecoration.lineThrough
                : null,
            decorationColor: Colors.white.withOpacity(0.5),
            decorationThickness: 2,
          ),
        ),
      
        if (widget.todo.dueDate != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 14,
                color: _getDueDateColor(),
              ),
              const SizedBox(width: 4),
              Text(
                _formatDueDate(widget.todo.dueDate!),
                style: TextStyle(
                  color: _getDueDateColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.delete_outline_rounded,
          onPressed: _handleDeleteTodo,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isDestructive 
              ? Colors.red.withOpacity(0.8)
              : Colors.white.withOpacity(0.7),
          size: 18,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Color _getDueDateColor() {
    if (widget.todo.isCompleted) {
      return Colors.white.withOpacity(0.4);
    }
    
    final now = DateTime.now();
    final dueDate = widget.todo.dueDate!;
    final difference = dueDate.difference(now).inDays;
    
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

  String _formatDueDate(DateTime dueDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(dueDate.year, dueDate.month, dueDate.day);
  final difference = target.difference(today).inDays;

  if (difference < 0) {
    return 'Overdue';
  } else if (difference == 0) {
    return 'Due today';
  } else if (difference == 1) {
    return 'Due tomorrow';
  } else if (difference <= 7) {
    return 'Due in $difference days';
  } else {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return 'Due ${dueDate.day} ${months[dueDate.month - 1]}';
  }
}

}