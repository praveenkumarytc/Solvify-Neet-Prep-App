import 'package:flutter/material.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/on%20boarding/on_boarding.dart';

bool isDark = false;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solvify - Neet prep app',
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: ColorResources.PRIMARY_MATERIAL,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: ColorResources.PRIMARY_MATERIAL,
        ),
      ),
      home: const OnBoarding(),
    );
  }
}
