import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_state.dart';
import 'package:tudu/presentation/widgets/home/stats.dart';
import 'package:tudu/presentation/widgets/todo_item/todo_item.dart';

class TodoSection extends StatelessWidget {
  const TodoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is! TodoLoaded) return const SizedBox.shrink();

        // BLoC now handles all filtering logic
        final todosByDueDate = state.displayTodosByDueDate;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatsOverview(),
              const SizedBox(height: 32),

              if (state.allTodos.isEmpty) _buildEmptyState(),

              ...todosByDueDate.entries
                  .where((entry) => entry.value.isNotEmpty)
                  .map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      entry.key,
                      entry.value.length,
                      _getSectionIcon(entry.key),
                      _getSectionColor(entry.key),
                    ),
                    const SizedBox(height: 20),
                    ...entry.value.map((todo) => TodoItem(todo: todo)),
                    const SizedBox(height: 32),
                  ],
                );
              }),

              const SizedBox(height: 120), // Bottom padding for FAB
            ],
          ),
        );
      },
    );
  }

  IconData _getSectionIcon(String sectionKey) {
    switch (sectionKey) {
      case 'Overdue':
        return Icons.warning_rounded;
      case 'Today':
        return Icons.today_rounded;
      case 'Tomorrow':
        return Icons.event_rounded;
      case 'This Week':
        return Icons.calendar_today_rounded;
      case 'Later':
      default:
        return Icons.calendar_month_rounded;
    }
  }

  Color _getSectionColor(String sectionKey) {
    switch (sectionKey) {
      case 'Overdue':
        return const Color(0xFFE74C3C); // Red for overdue
      case 'Today':
        return const Color(0xFF1E6F9F); // Blue for today
      case 'Tomorrow':
        return const Color(0xFF27AE60); // Green for tomorrow
      case 'This Week':
        return const Color(0xFFF39C12); // Orange for this week
      case 'Later':
      default:
        return const Color(0xFF9B59B6); // Purple for later
    }
  }

  Widget _buildSectionHeader(String title, int count, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            // Add a subtle shadow for overdue items to make them stand out more
            boxShadow: title == 'Overdue' ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  // Add an exclamation mark for overdue section
                  if (title == 'Overdue' && count > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE74C3C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                '$count ${count == 1 ? 'task' : 'tasks'}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 60),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E6F9F).withOpacity(0.2),
                    const Color(0xFF1E6F9F).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.task_alt_rounded,
                size: 40,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No tasks yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first task to get started\nwith organizing your day',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}