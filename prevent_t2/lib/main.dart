import 'package:flutter/material.dart';
import 'package:prevent_t2/activity_logs/activity_logs_screen.dart';
import 'package:prevent_t2/lifestyle_coach_logs/lifestyle_coach_logs_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prevent_t2/auth/login_screen.dart';
import 'package:prevent_t2/home_screen.dart';
import 'package:prevent_t2/auth/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://kexpcowdrhnutbxxljca.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtleHBjb3dkcmhudXRieHhsamNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTYzMDMzMjIsImV4cCI6MjAxMTg3OTMyMn0.r3RLnI-gSzOUoRAZ4STnmonrPykACrUP-DlTjvbHDRI');
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final User? user = Supabase.instance.client.auth.currentUser;

    return MaterialApp(
      title: 'PreventT2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => user == null ? LoginScreen() : HomeScreen(),
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/activity_logs': (context) => ActivityLogsScreen(),
        '/lifestyle_coach_logs': (context) => LifestyleCoachLogsScreen(),
      },
      initialRoute: user == null ? '/' : '/home',
    );
  }
}
