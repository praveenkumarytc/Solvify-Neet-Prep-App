import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shield_neet/home/Screens/homeScreen.dart';
import 'package:shield_neet/home/Screens/Account/profile.dart';

import '../helper/network_info.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _screens = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    NetworkInfo.checkConnectivity(context);
  }

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 8,
          currentIndex: pageIndex,
          showSelectedLabels: true,
          iconSize: 30.0,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.person,
                ),
                label: 'Account')
          ]),
    );
  }
}
