import 'package:flutter/material.dart';
import 'package:shield_neet/Utils/color_resources.dart';

class SolvifyAppbar extends StatelessWidget {
  const SolvifyAppbar({super.key, required this.title, this.exitExist = true});
  final String title;
  final bool exitExist;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: ColorResources.COLOR_BLUE,
      leadingWidth: exitExist ? 56 : 0,
      leading: exitExist
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            )
          : const SizedBox.shrink(),
      title: Text(
        title,
        maxLines: 2,
      ),
    );
  }
}
