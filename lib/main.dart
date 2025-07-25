import 'package:flutter/material.dart';
import 'package:tudu/presentation/pages/splash.dart';
import 'package:tudu/service_locator.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
 
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'TuDu',
          theme: ThemeData(
    
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
      
    );
  }
}
