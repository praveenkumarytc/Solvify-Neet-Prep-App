import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/share_prefs.dart';
import 'package:shield_neet/providers/admin_provider.dart';
import 'package:shield_neet/providers/auth_providers.dart';
import 'package:shield_neet/providers/user_provider.dart';
import 'package:shield_neet/splash_page.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_update/in_app_update.dart';

import 'helper/flutter_toast.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SharedPreference.preferences = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider(sharedPreferences: SharedPreference.preferences)),
        ChangeNotifierProvider<AdminProvider>(create: (context) => AdminProvider(sharedPreferences: SharedPreference.preferences)),
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider(sharedPreferences: SharedPreference.preferences)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  AppUpdateInfo? updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) async {
      if (info.updateAvailability == 2) {
        final updateResponse = await InAppUpdate.performImmediateUpdate();
        if (updateResponse.name.contains('denied')) {
          await InAppUpdate.performImmediateUpdate();
        }
      }
    }).catchError((error) {
      showToast(message: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    checkForUpdate();
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
