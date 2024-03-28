import 'package:education_app/core/res/res.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Education App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: AppColors.primaryColour,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
        ),
        fontFamily: Fonts.poppins,
      ),
    );
  }
}
