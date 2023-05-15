import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shield_neet/Admin%20App/add_chapters_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/chapters_topic_screen.dart';

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
          stream: FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(widget.subjectName).collection(FirestoreCollections.chapters).orderBy(FirestoreCollections.chapterNumber).snapshots(),
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
            final documents = snapshot.data!.docs;
            documents.sort(numSortFunction);

            return ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                children: documents.map((data) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        pushTo(
                          context,
                          ChapterTopicsPage(
                            subjectname: widget.subjectName,
                            chapterId: data.id,
                            chapterName: data[FirestoreCollections.chapterName],
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: Container(
                        width: 40,
                        height: double.infinity,
                        decoration: const BoxDecoration(color: ColorResources.PRIMARY_MATERIAL, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            data[FirestoreCollections.chapterNumber].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
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
