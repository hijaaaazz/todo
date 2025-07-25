import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/bloc/bloc/todo_state.dart';

class StatsOverview extends StatefulWidget {
  const StatsOverview({super.key});

  @override
  State<StatsOverview> createState() => _StatsOverviewState();
}

class _StatsOverviewState extends State<StatsOverview> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is! TodoLoaded) return const SizedBox();

        final dueDateGroups = state.todosByDueDate;
        final items = [
          {'label': 'Active', 'value': state.pendingCount.toString(), 'icon': Icons.radio_button_unchecked_rounded},
          {'label': 'Completed', 'value': state.completedCount.toString(), 'icon': Icons.check_circle_outline_rounded},
          {'label': 'Total', 'value': state.totalCount.toString(), 'icon': Icons.task_alt_rounded},
        ];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: items.map((item) {
              final isSelected = state.selectedTab == item['label'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildTabItem(
                  label: item['label'] as String,
                  value: item['value'] as String,
                  icon: item['icon'] as IconData,
                  isSelected: isSelected,
                  onTap: () {
                    context.read<TodoBloc>().add(SelectTab(item['label'] as String));
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTabItem({
    required String label,
    required String value,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E6F9F),
                    const Color(0xFF1E6F9F).withOpacity(0.8),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E6F9F).withOpacity(0.15),
                    const Color(0xFF1E6F9F).withOpacity(0.05),
                  ],
                ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF1E6F9F).withOpacity(isSelected ? 1.0 : 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              "$value $label",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}