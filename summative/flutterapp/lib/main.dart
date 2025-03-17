import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const CoffeeQualityApp());
}

class CoffeeQualityApp extends StatelessWidget {
  const CoffeeQualityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Quality Predictor',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
