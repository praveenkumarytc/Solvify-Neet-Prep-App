import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Scaffold();
  }
}
