// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/dimensions.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/home/Screens/BookMarked%20Questions/bookmarked_questions.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/subject_wise.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String greets = 'Hello \nFuture Doctors!';
  @override
  void initState() {
    // Determine the background color
    Color backgroundColor = Colors.white; // Replace with your background color

    // Set the status bar text color to light if the background color is dark, and to dark if the background color is light
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: ThemeData.estimateBrightnessForColor(backgroundColor),
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*   floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add admin access logic here
        },
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 8.0,
        tooltip: 'Admin Access',
        heroTag: 'admin-access-button',
        child: Stack(
          children: const [
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Icon(
                Icons.lock,
                size: 28,
                color: Colors.deepPurple,
              ),
            ),
            Icon(
              Icons.admin_panel_settings,
              size: 36,
              color: Colors.white,
            ),
          ],
        ),
      ),
    */
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HelloDoctorsCard(),
            QuestionButtons(
              onTap: () => pushTo(context, const SubjectWiseQuestScreen()),
              title: 'Subject Wise Questions',
              color1: Colors.teal.withOpacity(.4),
              color2: Colors.teal,
              imageIcon: Images.bookshelf,
            ),
            Dimensions.PADDING_SIZE_DEFAULT.heightBox,
            QuestionButtons(
              onTap: () => pushTo(context, const BookMarkedQuestScreen()),
              title: 'Previous Year Papers',
              color1: const Color(0xFFE5B2CA),
              color2: const Color(0xFF7028E4),
              imageIcon: Images.contract,
            ),
            Dimensions.PADDING_SIZE_DEFAULT.heightBox,
            QuestionButtons(
              onTap: () => pushTo(context, const BookMarkedQuestScreen()),
              title: 'Bookmarked Questions',
              color1: const Color(0xFFFFB199),
              color2: const Color(0xFFFF0844),
              imageIcon: Images.bookmark,
            ),
          ],
        ),
      ),
    );
  }
}

class HelloDoctorsCard extends StatelessWidget {
  const HelloDoctorsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyHomePageClipper(),
      child: Container(
        decoration: const BoxDecoration(
          color: ColorResources.COLOR_BLUE,
          image: DecorationImage(
            image: AssetImage(Images.doctor_bg),
            scale: 2,
            alignment: Alignment.bottomRight,
          ),
        ),
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Hello!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            Text(
              'Future Doctor',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

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
        height: 80,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            gradient: LinearGradient(colors: [
              color1,
              color2
            ])),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ImageIcon(
                AssetImage(imageIcon),
                size: 35,
                color: Colors.white.withOpacity(0.60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.moveTo(0, 99);
    path.lineTo(0, size.height / 1.5);
    path.cubicTo(
      size.width / 7,
      1.2 * size.height,
      4 * size.width / 4,
      size.height * 0.6,
      size.width,
      size.height * 0.9,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
