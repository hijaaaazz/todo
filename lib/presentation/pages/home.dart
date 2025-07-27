import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/bloc/bloc/todo_state.dart';
import 'package:tudu/presentation/pages/splash.dart';
import 'package:tudu/presentation/widgets/home/action_button.dart';
import 'package:tudu/presentation/widgets/add_todo/add_todo_bottom_sheet.dart';
import 'package:tudu/presentation/widgets/home/error.dart';
import 'package:tudu/presentation/widgets/home/header.dart';
import 'package:tudu/presentation/widgets/home/loading.dart';
import 'package:tudu/presentation/widgets/home/todo_section.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<TodoBloc>().add(SearchTodos(_searchController.text));
  }

  void _showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => BlocProvider.value(
        value: context.read<TodoBloc>(),
        child: const AddTodoBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: Column(
            children: [
              HeaderArea(
                controller: _searchController,
                onAdd: _showAddBottomSheet,
              ),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is TodoLoading) {
                      return const TodoLoadingWidget();
                    }
                    if (state is TodoError) {
                      return TodoErrorWidget(message: state.message);
                    }
                    if (state is TodoLoaded) {
                      return TodoSection();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButtonWidget(
          onPressed: _showAddBottomSheet,
        ),
      ),
    );
  }
}