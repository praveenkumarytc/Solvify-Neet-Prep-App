import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Admin%20App/add_chapters_screen.dart';
import 'package:shield_neet/Admin%20App/add_mcq_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/components/add_chapter_diaglog.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/helper/log_out_dialog.dart';
import 'package:shield_neet/providers/admin_provider.dart';

class AddChapterTopic extends StatelessWidget {
  AddChapterTopic({super.key, required this.chapterId, required this.chapterName, required this.subjectName});
  final String chapterName;
  final String subjectName;
  final String chapterId;

  final TextEditingController topicNameController = TextEditingController();
  final TextEditingController topicNumberController = TextEditingController();
  void _showAddChapterDialog(BuildContext context) {
    topicNameController.clear();
    topicNumberController.clear();
    showDialog(
      context: context,
      builder: (_) => AddChapterDialog(
        chapterNameController: topicNameController,
        chapterNumberController: topicNumberController,
        isYear: subjectName == FirestoreCollections.yearWise,
        isTopicScreen: true,
        onTap: () async {
          if (topicNumberController.text.isEmpty || topicNameController.text.isEmpty) {
            showToast(message: 'Please enter a valid data', isError: true);
          } else {
            try {
              await Provider.of<AdminProvider>(context, listen: false).addChapterTopic(subjectName, topicNameController.text.trim(), topicNumberController.text.trim(), chapterId).then((value) {
                Navigator.of(context).pop();
                topicNameController.clear();
                topicNumberController.clear();
              });
            } catch (e) {
              showToast(message: e.toString(), isError: true);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SolvifyAppbar(title: chapterName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            AddChapterCard(
              onTap: () => _showAddChapterDialog(context),
              title: subjectName == FirestoreCollections.yearWise ? "Add Subject" : 'Add a topic ',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).orderBy(FirestoreCollections.topicNumber).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error occured');
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final documents = snapshot.data!.docs;
                  documents.sort(numSortFunctionTopic);
                  return ListView(
                      children: snapshot.data!.docs.map((data) {
                    return ChapterListCard(
                      chapterNumber: data[FirestoreCollections.topicNumber].toString(),
                      chapterName: data[FirestoreCollections.topicName],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMcqScreen(
                            chapterName: chapterName,
                            subjectName: subjectName,
                            chapterId: chapterId,
                            topicId: data.id,
                            topicName: data[FirestoreCollections.topicName],
                          ),
                        ),
                      ),
                      onDelete: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder: (context, animation, secondaryAnimation) => AppInfoDialog(onLogOut: () async {
                            await Provider.of<AdminProvider>(context, listen: false).deleteChapterTopic(subjectName, chapterId, data.id).then((value) {
                              Navigator.pop(context);
                              showToast(message: 'deleted Successfully');
                            });
                          }),
                        );
                      },
                      onEdit: () {
                        topicNameController.text = data[FirestoreCollections.topicName];
                        topicNumberController.text = data[FirestoreCollections.topicNumber];
                        showDialog(
                          context: context,
                          builder: (_) => AddChapterDialog(
                            isTopicScreen: true,
                            chapterNameController: topicNameController,
                            chapterNumberController: topicNumberController,
                            isYear: subjectName == FirestoreCollections.yearWise,
                            onTap: () async {
                              if (topicNumberController.text.isEmpty || topicNameController.text.isEmpty) {
                                showToast(message: 'Please enter a chapter number and name', isError: true);
                              } else {
                                try {
                                  await Provider.of<AdminProvider>(context, listen: false)
                                      .updateChapterTopic(
                                    subjectName,
                                    topicNameController.text.trim(),
                                    topicNumberController.text.trim(),
                                    chapterId,
                                    data.id,
                                  )
                                      .then((value) {
                                    Navigator.of(context).pop();
                                    topicNameController.clear();
                                    topicNumberController.clear();
                                  });
                                } catch (e) {
                                  showToast(message: e.toString(), isError: true);
                                }
                              }
                            },
                          ),
                        );
                      },
                    );
                  }).toList());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
