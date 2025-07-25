import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/cubit/auth_cubit.dart';
import 'package:tudu/presentation/bloc/cubit/auth_state.dart';
import 'package:tudu/presentation/pages/home.dart';
import 'package:tudu/presentation/widgets/splash/logo.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Load todos

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
    ],
  );
}

      ),
    );
  }
}
