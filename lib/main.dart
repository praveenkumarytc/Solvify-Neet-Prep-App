import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/share_prefs.dart';
import 'package:shield_neet/providers/admin_provider.dart';
import 'package:shield_neet/providers/auth_providers.dart';
import 'package:shield_neet/providers/user_provider.dart';
import 'package:shield_neet/splash_page.dart';

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

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  AppUpdateInfo? updateInfo;

// Method to check for updates
  Future<void> checkForUpdate() async {
    final updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      debugPrint('Update is available');

      // Prompt the user for an in-app update
      InAppUpdate.startFlexibleUpdate().then((_) {
        // The update flow has started successfully
        setState(() {
          // Update the state variable if necessary
          this.updateInfo = updateInfo;
        });
      }).catchError((e) {
        // Handle any errors that occur during the update flow
        debugPrint('Error starting flexible update: $e');
      });
    } else if (updateInfo.updateAvailability == UpdateAvailability.updateNotAvailable) {
      debugPrint('Update is not available');
    } else if (updateInfo.updateAvailability == UpdateAvailability.unknown) {
      debugPrint('Unable to determine update availability');
    }
  }
  /* Future<void> checkForUpdate() async {
    final updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      debugPrint('Update is available');

      // Prompt the user for an immediate update
      InAppUpdate.performImmediateUpdate().then((_) {
        // The immediate update flow has started successfully
        setState(() {
          // Update the state variable if necessary
          this.updateInfo = updateInfo;
        });
      }).catchError((e) {
        // Handle any errors that occur during the immediate update flow
        debugPrint('Error performing immediate update: $e');
      });
    } else if (updateInfo.updateAvailability == UpdateAvailability.updateNotAvailable) {
      debugPrint('Update is not available');
    } else if (updateInfo.updateAvailability == UpdateAvailability.unknown) {
      debugPrint('Unable to determine update availability');
    }
  }*/

// Method to display snack bar
  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    checkForUpdate();
    super.initState();
  }

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
