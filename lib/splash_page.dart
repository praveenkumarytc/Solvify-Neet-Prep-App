// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/home/dashboard.dart';
import 'package:shield_neet/on%20boarding/on_boarding.dart';
import 'package:shield_neet/providers/auth_providers.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    final updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      debugPrint('Update is available');
      final playStoreUrl = 'https://play.google.com/store/apps/details?id=com.praveen.shield.shield_neet';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text('Update Available'),
                Image.asset(
                  Images.APP_LOGO_WHITE_BG,
                  scale: 10,
                )
              ],
            ),
            content: Text('An update is available for the app. Would you like to update now?'),
            actions: [
              TextButton(
                child: Text('Update'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await launch(playStoreUrl);
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  routes();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // // Prompt the user for an immediate update
      // InAppUpdate.performImmediateUpdate().then((_) {
      //   // The immediate update flow has started successfully
      //   setState(() {
      //     // Update the state variable if necessary
      //     this.updateInfo = updateInfo;
      //   });
      // }).catchError((e) {
      //   // Handle any errors that occur during the immediate update flow
      //   debugPrint('Error performing immediate update: $e');
      // });
    } else if (updateInfo.updateAvailability == UpdateAvailability.updateNotAvailable) {
      routes();
      debugPrint('Update is not available');
    } else if (updateInfo.updateAvailability == UpdateAvailability.unknown) {
      routes();
      debugPrint('Unable to determine update availability');
    }
  }

  routes() {
    Timer(const Duration(seconds: 3), () {
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashBoard()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OnBoarding()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  Images.APP_LOGO_TRANS_BG,
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 30),
                // const Text(
                //   'Solvify Neet Prep App',
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
