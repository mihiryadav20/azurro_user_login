import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_auth/pages/auth_page.dart';
import 'package:user_auth/pages/login_page.dart';
import 'package:user_auth/pages/splash_screen.dart';
 
Future<void> main() async {
  await Supabase.initialize(
    url: 'https://gdgevypddzczlfnvzbbc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdkZ2V2eXBkZHpjemxmbnZ6YmJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTgwMDU1MjAsImV4cCI6MjAzMzU4MTUyMH0.ocMb_rG996QmtwOsYKdRB7juraLh4bZpEJdD_0zPIM0',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Flutter',
      theme: ThemeData.dark().copyWith(
         primaryColor: const Color(0xFFFF4F00),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFFFF4F00),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFFFF4F00),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFF4F00)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFF4F00)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFF4F00)),
    ),
    labelStyle: TextStyle(color: Color(0xFFFF4F00)),
  ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
      },
    );
  }
}