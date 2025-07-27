import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/core/theme/app_theme.dart';
import 'package:tudu/firebase_options.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/bloc/todo_bloc.dart';
import 'package:tudu/presentation/pages/splash.dart';
import 'package:tudu/service_locator.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();

  const themeMode = ThemeMode.light; // or ThemeMode.system / ThemeMode.dark
  log('App using themeMode: $themeMode');
  AppTheme.setThemeMode(ThemeMode.dark); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()..checkAuthStatus()),
        BlocProvider(create: (_) => TodoBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TuDu',
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: SplashScreen(),
      ),
    );
  }
}
