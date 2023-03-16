// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shield_neet/on%20boarding/login_page.dart';
import 'package:shield_neet/helper/push_to.dart';

class OnBoarding extends StatefulWidget {
  static const style = TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );

  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoarding createState() => _OnBoarding();
}

class _OnBoarding extends State<OnBoarding> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [
    Container(
      color: Colors.indigo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(
              'assets/images/1.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: const [
              Text(
                "Hello Everyone!",
                style: OnBoarding.style,
              ),
              Text(
                "Let's ",
                style: OnBoarding.style,
              ),
              Text(
                "Explore the Space",
                style: OnBoarding.style,
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      color: const Color(0xFF232323),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            'assets/images/2.jpg',
            fit: BoxFit.cover,
          ),
          Column(
            children: const [
              Text(
                "Get to",
                style: OnBoarding.style,
              ),
              Text(
                "Know our",
                style: OnBoarding.style,
              ),
              Text(
                "Solar System",
                style: OnBoarding.style,
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      color: const Color(0xFF460BA1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            'assets/images/3.jpg',
            fit: BoxFit.cover,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Column(
            children: const [
              Text(
                "Ejoy",
                style: OnBoarding.style,
              ),
              Text(
                "the",
                style: OnBoarding.style,
              ),
              Text(
                "Journey!",
                style: OnBoarding.style,
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      color: Colors.deepOrange.shade700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 100),
            child: Image.asset(
              'assets/images/4.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: const [
              Text(
                "Be",
                style: OnBoarding.style,
              ),
              Text(
                "Like",
                style: OnBoarding.style,
              ),
              Text(
                "Astronaut",
                style: OnBoarding.style,
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 130),
            child: Image.asset(
              'assets/images/5.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: const [
              Text(
                "Feel",
                style: OnBoarding.style,
              ),
              Text(
                "the",
                style: OnBoarding.style,
              ),
              Text(
                "Moon",
                style: OnBoarding.style,
              ),
            ],
          ),
        ],
      ),
    ),
  ];

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return SizedBox(
      width: 25.0,
      child: Center(
        child: Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: SizedBox(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            LiquidSwipe(
              pages: pages,
              slideIconWidget: const Icon(Icons.arrow_back_ios),
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              enableSideReveal: true,
              ignoreUserGestureWhileAnimating: true,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  const Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(pages.length, _buildDot),
                  ),
                ],
              ),
            ),
            liquidController.currentPage == pages.length - 1
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: TextButton(
                        onPressed: () {
                          pushTo(context, const LoginPage());
                        },
                        child: const Text("Get Started", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: TextButton(
                        onPressed: () {
                          liquidController.jumpToPage(
                            page: pages.length - 1,
                          );
                          // liquidController.animateToPage(page: pages.length - 1, duration: 700);
                        },
                        child: const Text("Skip to End", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextButton(
                  onPressed: () {
                    liquidController.jumpToPage(page: liquidController.currentPage + 1 > pages.length - 1 ? 0 : liquidController.currentPage + 1);
                  },
                  child: const Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}
