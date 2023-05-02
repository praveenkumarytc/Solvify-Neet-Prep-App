import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/share_prefs.dart';
import 'package:shield_neet/providers/admin_provider.dart';
import 'package:shield_neet/providers/auth_providers.dart';
import 'package:shield_neet/providers/user_provider.dart';
import 'package:shield_neet/splash_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreference.preferences = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider(sharedPreferences: SharedPreference.preferences)),
        ChangeNotifierProvider<AdminProvider>(create: (context) => AdminProvider(sharedPreferences: SharedPreference.preferences)),
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider(sharedPreferences: SharedPreference.preferences)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, snapshot, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Solvify Neet Preparation App',
        themeMode: snapshot.isDarkMode! ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: ColorResources.PRIMARY_MATERIAL,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: ColorResources.PRIMARY_MATERIAL,
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.dark,
          primarySwatch: ColorResources.PRIMARY_MATERIAL,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: ColorResources.PRIMARY_MATERIAL,
          ),
        ),
        home: const SplashPage(),
      );
    });
  }
}
