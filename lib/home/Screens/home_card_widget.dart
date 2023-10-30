import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class QuestionButtons extends StatelessWidget {
  const QuestionButtons({super.key, required this.title, required this.color1, required this.color2, required this.imageIcon, required this.onTap});
  final String title, imageIcon;
  final Color color1, color2;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.45,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
              color1,
              color2
            ])),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.45 * 0.5,
              width: MediaQuery.of(context).size.width * 0.45 * 0.5,
              child: Image.asset(imageIcon),
            ),
            10.heightBox,
            Text(
              textAlign: TextAlign.center,
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
