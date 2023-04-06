// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/mcq_test.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key, required this.subjectName, required this.chapterId});
  final String chapterId;
  final String subjectName;
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.repeat(reverse: true);
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => McqTestScreen(
          chapterId: widget.chapterId,
          subjectName: widget.subjectName,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 2 * 3.1416,
                  child: child,
                );
              },
              child: const Icon(
                Icons.timelapse,
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Getting ready for the test...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
