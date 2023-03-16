import 'package:flutter/material.dart';
import 'package:shield_neet/Utils/color_resources.dart';

class SolvifyAppbar extends StatelessWidget {
  const SolvifyAppbar({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: ColorResources.COLOR_BLUE,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(title),
    );
  }
}
