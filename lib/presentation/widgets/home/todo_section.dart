import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/domain/enities/todo_entity.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/bloc/bloc/todo_state.dart';
import 'package:tudu/presentation/widgets/home/stats.dart';
import 'package:tudu/presentation/widgets/home/todo_item.dart';
class TodoSection extends StatelessWidget {
  final Function(TodoEntity) onEdit;
  final Function(TodoEntity) onDelete;

  const TodoSection({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is! TodoLoaded) return const SizedBox.shrink();

        final todosToShow = state.selectedTab == 'Active'
            ? state.pendingTodos
            : state.selectedTab == 'Completed'
                ? state.completedTodos
                : state.filteredTodos;

        final todosByDueDate = state.selectedTab == 'Total' ? state.todosByDueDate : null;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatsOverview(),
              const SizedBox(height: 32),

              if (state.todos.isEmpty) _buildEmptyState(),

              if (state.selectedTab == 'Total' && todosByDueDate != null) ...[
                ...todosByDueDate.entries.where((entry) => entry.value.isNotEmpty).map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        entry.key,
                        entry.value.length,
                        entry.key == 'Today'
                            ? Icons.today_rounded
                            : entry.key == 'Tomorrow'
                                ? Icons.event_rounded
                                : entry.key == 'This Week'
                                    ? Icons.calendar_today_rounded
                                    : Icons.calendar_month_rounded,
                      ),
                      const SizedBox(height: 20),
                      ...entry.value.map((todo) => TodoItem(
                            todo: todo,
                          onToggle: () {
  final authState = context.read<AuthCubit>().state;
  final userId = authState is Authenticated ? authState.user.id : "";

  context.read<TodoBloc>().add(
    ToggleTodo(
      id: todo.id,
      userId: userId,
      status: !todo.isCompleted,
    ),
  );
},

                            onEdit: () => onEdit(todo),
                            onDelete: () => onDelete(todo),
                          )),
                      const SizedBox(height: 32),
                    ],
                  );
                }),
              ] else ...[
                _buildSectionHeader(
                  state.selectedTab,
                  todosToShow.length,
                  state.selectedTab == 'Active'
                      ? Icons.pending_actions_rounded
                      : state.selectedTab == 'Completed'
                          ? Icons.task_alt_rounded
                          : Icons.task_alt_rounded,
                ),
                const SizedBox(height: 20),
                ...todosToShow.map((todo) => TodoItem(
                      todo: todo,
onToggle: () {
  final authState = context.read<AuthCubit>().state;
  final userId = authState is Authenticated ? authState.user.id : "";

  context.read<TodoBloc>().add(
    ToggleTodo(
      id: todo.id,
      userId: userId,
      status: !todo.isCompleted,
    ),
  );
},
 onEdit: () => onEdit(todo),
                      onDelete: () => onDelete(todo),
                    )),
              ],

              const SizedBox(height: 120), // Bottom padding for FAB
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int count, IconData icon) {
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
                const Color(0xFF1E6F9F),
                const Color(0xFF1E6F9F).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
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
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
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