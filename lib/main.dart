import 'package:flutter/material.dart';
import 'screens/setup_screen.dart';

void main() {
  runApp(const DailyHelperApp());
}

// entry point — setup screen muna bago splash tapos home
class DailyHelperApp extends StatelessWidget {
  const DailyHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Daily Helper Toolkit',
      debugShowCheckedModeBanner: false,
      home: SetupScreen(),
    );
  }
}