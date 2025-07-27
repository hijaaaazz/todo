import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/core/theme/app_theme.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/bloc/bloc/todo_event.dart';
import 'package:tudu/presentation/widgets/splash/logo.dart';
import 'package:tudu/presentation/widgets/splash/signin_button.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Load todos
            context.read<TodoBloc>().add(LoadTodos(userId: state.user.id));

            // Navigate to home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TodoPage()),
            );
          }
        },
      
builder: (context, state) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
       SizedBox(height: MediaQuery.of(context).size.height *0.1),
      const AnimatedLogoWidget(),
      const GoogleSignInButton()
    ],
  );
}

      ),
    );
  }
}
