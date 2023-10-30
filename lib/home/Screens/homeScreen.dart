// ignore_for_file: file_names
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/dimensions.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/home/Screens/BookMarked%20Questions/bookmarked_questions.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/subject_wise.dart';
import 'package:shield_neet/home/Screens/home_card_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Subject Wise/chapters_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey globalKey = GlobalKey();
  Future<Uint8List> captureWidgetAsImage(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      return Uint8List(0);
    }
  }

  @override
  void initState() {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuestionButtons(
                    onTap: () => pushTo(
                        context,
                        const SubjectWiseQuestScreen(
                          fromNCERT: true,
                        )),
                    title: 'Subject Wise Questions',
                    color1: const Color.fromRGBO(255, 205, 205, 1),
                    color2: const Color.fromRGBO(255, 81, 81, 1),
                    imageIcon: Images.book1,
                  ),
                  QuestionButtons(
                    onTap: () => pushTo(context, const SubjectWiseQuestScreen()),
                    title: 'Previous year Questions',
                    color1: const Color.fromRGBO(255, 250, 205, 1),
                    color2: const Color.fromRGBO(231, 208, 0, 1),
                    imageIcon: Images.book2,
                  ),
                ],
              ),
            ),
            // Dimensions.PADDING_SIZE_DEFAULT.heightBox,
            // Dimensions.PADDING_SIZE_DEFAULT.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuestionButtons(
                    onTap: () => pushTo(
                        context,
                        const SubjectWiseQuestScreen(
                          fromNotes: true,
                          fromNCERT: true,
                        )),
                    title: 'Quick revision Notes',
                    color1: const Color.fromRGBO(205, 243, 255, 1),
                    color2: const Color.fromRGBO(81, 213, 255, 1),
                    imageIcon: Images.book3,
                  ),
                  Dimensions.PADDING_SIZE_DEFAULT.heightBox,
                  QuestionButtons(
                    onTap: () => pushTo(context, const ChapterScreen(subjectName: FirestoreCollections.yearWise)),
                    title: 'Previous Year Papers',
                    color1: const Color.fromRGBO(205, 210, 255, 1),
                    color2: const Color.fromRGBO(81, 98, 255, 1),
                    imageIcon: Images.book4,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Dimensions.PADDING_SIZE_DEFAULT.heightBox,
                  // QuestionButtons(
                  //   onTap: () => pushTo(context, const BookMarkedQuestScreen()),
                  //   title: 'Bookmarked Questions',
                  //   color1: const Color.fromRGBO(255, 229, 205, 1),
                  //   color2: const Color.fromRGBO(255, 129, 12, 1),
                  //   imageIcon: Images.book5,
                  // ),
                ],
              ),
            )
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
        decoration: BoxDecoration(
          color: ColorResources.primaryBlue(context),
          image: const DecorationImage(
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
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            Text(
              'Future Doctor',
              style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
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
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.9, size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.7, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
