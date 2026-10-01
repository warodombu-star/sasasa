import 'package:flutter/material.dart';
import 'pages/home.dart';
 
void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ValoMarket',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1923),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF4655),
          onPrimary: Colors.white,
          surface: Color(0xFF1B2733),
        ),
      ),
      home: const HomePage(),
    );
  }
}