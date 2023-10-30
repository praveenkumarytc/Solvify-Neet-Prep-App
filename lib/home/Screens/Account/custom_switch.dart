import 'package:flutter/material.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'dart:math' as math;

import 'package:shield_neet/Utils/images.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onToggle;
  final Widget activeIcon;
  final Widget inactiveIcon;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onToggle,
    required this.activeIcon,
    required this.inactiveIcon,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.value;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
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
    return GestureDetector(
      onTap: () {
        if (widget.onToggle != null) {
          widget.onToggle!(!widget.value);
          isSwitched = !isSwitched;
          if (isSwitched) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Container(
            width: 60,
            height: 35.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(.35)),
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(image: AssetImage(widget.value ? Images.sun_switch_body : Images.moon_switch_body)),
              // color: widget.value ? ColorResources.primaryBlue(context) : ColorResources.PRIMARY_MATERIAL.withOpacity(.55),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: isSwitched ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Transform.rotate(
                    angle: _animation.value * math.pi,
                    child: widget.value ? widget.activeIcon : widget.inactiveIcon,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
