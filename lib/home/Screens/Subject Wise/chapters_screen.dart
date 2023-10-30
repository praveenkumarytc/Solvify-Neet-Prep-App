import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shield_neet/Admin%20App/add_chapters_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/webview_screen.dart';
import 'package:shield_neet/components/note_pad.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/chapters_topic_screen.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/subject_unit_screen.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/text_viewer_page.dart';
import 'package:shield_neet/pdf%20viwer/pdf_viewer.dart';

class ChapterScreen extends StatelessWidget {
  const ChapterScreen({
    super.key,
    required this.subjectName,
    this.fromNCERT = false,
    this.unitId,
    this.fromNote = false,
  });
  final String subjectName;
  final String? unitId;
  final bool fromNCERT;
  final bool fromNote;
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Object?>> chapterSteream() {
      if (fromNCERT && !fromNote) {
        debugPrint('$fromNote $fromNCERT');
        return FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).orderBy(FirestoreCollections.chapterNumber).snapshots();
      } else if (fromNote) {
        debugPrint(subjectName);
        return FirebaseFirestore.instance.collection(FirestoreCollections.revisionNotes).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).orderBy(FirestoreCollections.chapterName).snapshots();
      } else {
        return FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).orderBy(FirestoreCollections.chapterNumber).snapshots();
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SolvifyAppbar(title: "$subjectName Chapters"),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScroll(),
        child: StreamBuilder<QuerySnapshot>(
          stream: chapterSteream(),
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              children: List.generate(documents.length, (index) {
                var data = documents[index];
                final color = index % 2 == 0 ? Colors.red : Colors.blue;
                return fromNCERT
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        child: NewChapterCard(
                          color: color,
                          chapterNumber: data[FirestoreCollections.chapterNumber].toString(),
                          chapterName: data[FirestoreCollections.chapterName],
                          onTap: () {
                            if (fromNote) {
                              print(data[FirestoreCollections.pdfUrl].toString());
                              if (data[FirestoreCollections.pdfUrl].toString().startsWith('http')) {
                                pushTo(
                                  context,
                                  WebviewScreen(
                                    appBarTitle: data[FirestoreCollections.chapterName],
                                    webviewUrl: data[FirestoreCollections.pdfUrl],
                                  ),
                                );
                              } else {
                                pushTo(
                                  context,
                                  TextViewerPage(
                                    text: data[FirestoreCollections.pdfUrl],
                                    appbarTitle: data[FirestoreCollections.chapterName],
                                  ),
                                );
                              }
                            } else {
                              pushTo(
                                context,
                                ChapterTopicsPage(
                                  subjectname: subjectName,
                                  chapterId: data.id,
                                  chapterName: data[FirestoreCollections.chapterName],
                                  fromNCERT: fromNCERT,
                                  unitId: unitId,
                                ),
                              );
                            }
                          },
                        ),
                      )
                    : NewChapterCard(
                        chapterName: data[FirestoreCollections.chapterName],
                        chapterNumber: data[FirestoreCollections.chapterNumber],
                        color: color,
                        onTap: () {
                          pushTo(
                            context,
                            ChapterTopicsPage(
                              subjectname: subjectName,
                              chapterId: data.id,
                              chapterName: data[FirestoreCollections.chapterName],
                            ),
                          );
                        },
                      );
              }),
            );
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
