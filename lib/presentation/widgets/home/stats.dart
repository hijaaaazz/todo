import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/data/models/tab_item.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/bloc/bloc/todo_state.dart';

class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is! TodoLoaded) return const SizedBox();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: TabItem.values.map((tabItem) {
              final isSelected = state.selectedTab == tabItem;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildTabItem(
                  context: context,
                  tabItem: tabItem,
                  value: tabItem.getValue(state),
                  isSelected: isSelected,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required TabItem tabItem,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<TodoBloc>().add(SelectTab(tabItem));
      },
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
            Icon(tabItem.icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              "$value ${tabItem.label}",
              style: const TextStyle(
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