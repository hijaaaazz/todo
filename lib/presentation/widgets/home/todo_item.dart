import 'package:flutter/material.dart';
import 'package:tudu/domain/enities/todo_entity.dart';

class TodoItem extends StatefulWidget {
  final TodoEntity todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TodoItem> createState() => _TodoEntityWidgetState();
}

class _TodoEntityWidgetState extends State<TodoItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
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
            splashColor: Colors.transparent,
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => TodoDetailedPage(todo: widget.todo),
              //   ),
              // );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Checkbox
                    GestureDetector(
                      onTap: widget.onToggle,
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
                    ),
                    const SizedBox(width: 16),
                  
                    // Task Content
                    Expanded(
                      child: Column(
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
                          if (widget.todo.description?.isNotEmpty == true) ...[
                            const SizedBox(height: 6),
                            Text(
                              widget.todo.description!,
                              style: TextStyle(
                                color: widget.todo.isCompleted
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                decoration: widget.todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: Colors.white.withOpacity(0.3),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
                      ),
                    ),
                  
                    // Action Buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(
                          icon: Icons.edit_outlined,
                          onPressed: widget.onEdit,
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.delete_outline_rounded,
                          onPressed: widget.onDelete,
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return 'Due ${dueDate.day} ${months[dueDate.month - 1]}';
    }
  }
}