import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/mcq_test.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/test_loading.dart';

class ChapterScreen extends StatefulWidget {
  const ChapterScreen({super.key, required this.subjectName});
  final String subjectName;

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SolvifyAppbar(title: "${widget.subjectName} Chapters"),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScroll(),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(widget.subjectName).collection(FirestoreCollections.chapters).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error occured');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                children: snapshot.data!.docs.map((data) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      onTap: () {
                        pushTo(
                            context,
                            LoadingScreen(
                              chapterId: data.id,
                              subjectName: widget.subjectName,
                            ));
                      },
                      leading: Text(
                        data[FirestoreCollections.chapterNumber].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      title: Text(
                        data[FirestoreCollections.chapterName],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: ColorResources.PRIMARY_MATERIAL,
                      ),
                    ),
                  );
                }).toList());
          },
        ),
      ),
    );
  }
}

class NoGlowScroll extends ScrollBehavior {
  Widget noGlowAtScroll(BuildContext context, Widget child, ScrollDirection scrollDirection) {
    return child;
  }
}
