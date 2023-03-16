import 'package:flutter/material.dart';
import 'package:shield_neet/Utils/dimensions.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/home/Screens/Account/Subject%20Wise/chapters_screen.dart';
import 'package:shield_neet/push_to.dart';
import 'package:velocity_x/velocity_x.dart';

class SubjectWiseQuestScreen extends StatelessWidget {
  const SubjectWiseQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(50), child: SolvifyAppbar(title: 'Subject Wise Questions')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SubjecstsCard(
              imagePath: Images.pendulum,
              subjectName: 'Physics',
              iconPath: Images.prism,
              onTap: () => pushTo(context, const ChapterScreen(subjectName: 'Physics')),
            ),
            Dimensions.PADDING_SIZE_SMALL.heightBox,
            SubjecstsCard(
              imagePath: Images.laboratory,
              subjectName: 'Chemistry',
              iconPath: Images.chemistry,
              onTap: () => pushTo(context, const ChapterScreen(subjectName: 'Chemistry')),
            ),
            Dimensions.PADDING_SIZE_SMALL.heightBox,
            SubjecstsCard(
              imagePath: Images.biology,
              iconPath: Images.evolution,
              subjectName: 'Biology',
              onTap: () => pushTo(context, const ChapterScreen(subjectName: 'Biology')),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjecstsCard extends StatelessWidget {
  const SubjecstsCard({super.key, required this.imagePath, required this.iconPath, required this.subjectName, required this.onTap});
  final String imagePath, iconPath, subjectName;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 220,
        ),
        Positioned(
          top: 45,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 8,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                alignment: Alignment.centerLeft,
                height: 150,
                width: MediaQuery.of(context).size.width * 0.94,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: subjectName == 'Chemistry'
                        ? [
                            const Color.fromRGBO(88, 113, 241, 1),
                            const Color.fromRGBO(3, 186, 254, 1),
                          ]
                        : subjectName == 'Physics'
                            ? [
                                const Color.fromRGBO(249, 106, 162, 1),
                                const Color.fromRGBO(232, 142, 109, 1),
                              ]
                            : [
                                const Color.fromRGBO(166, 145, 208, 1),
                                const Color.fromRGBO(246, 190, 229, 1),
                              ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
                      child: Image.asset(iconPath),
                    ),
                    10.heightBox,
                    Text(
                      subjectName,
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          child: SizedBox(
            height: 100,
            child: Image.asset(imagePath),
          ),
        )
      ],
    );
  }
}
