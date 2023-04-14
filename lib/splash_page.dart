import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/home/dashboard.dart';
import 'package:shield_neet/on%20boarding/on_boarding.dart';
import 'package:shield_neet/providers/auth_providers.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    routes();
  }

  routes() {
    Timer(const Duration(seconds: 3), () {
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashBoard()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const OnBoarding()), (route) => false);
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
                const Text(
                  'Solvify Neet Prep App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
