import 'package:flutter/material.dart';
import 'screens/setup_screen.dart';

void main() {
  runApp(const DailyHelperApp());
}

// dave: Default entry point ng buong app ha wag nyo galawin to.
// papasok muna sa setup screen para kunin name bago mag splash screen tas home interface
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