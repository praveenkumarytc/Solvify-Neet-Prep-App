import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Admin%20App/Subjects-NCERT/add_topic_screen_ncert.dart';
import 'package:shield_neet/Admin%20App/add_chapters_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/components/add_unit_dialog.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/providers/pdf_viewer.dart';

import '../../helper/log_out_dialog.dart';
import '../../providers/admin_provider.dart';

class AddUnitChapterScreenAdmin extends StatelessWidget {
  AddUnitChapterScreenAdmin({
    super.key,
    required this.subjectName,
    required this.unitId,
    required this.unitName,
    this.fromNote = false,
  });
  final String subjectName;
  final String unitName;
  final String unitId;
  final bool fromNote;

  final TextEditingController chapterNameController = TextEditingController();
  final TextEditingController chapterNumberController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController pdfLinkController = TextEditingController();

  clearControllers() {
    chapterNameController.clear();
    chapterNumberController.clear();
    imageController.clear();
    pdfLinkController.clear();
  }

  void _showAddChapterDialog(BuildContext context) {
    clearControllers();
    showDialog(
      context: context,
      builder: (_) => AddUnitDialog(
        imageController: imageController,
        chapterNameController: chapterNameController,
        chapterNumberController: chapterNumberController,
        pdfLinkController: fromNote ? pdfLinkController : null,
        isYear: true,
        onTap: () async {
          if (chapterNumberController.text.isEmpty || chapterNameController.text.isEmpty) {
            showToast(message: 'Please enter a valid data', isError: true);
          } else {
            try {
              await Provider.of<AdminProvider>(context, listen: false)
                  .addChapterNCERT(
                subjectName,
                chapterNameController.text.trim(),
                chapterNumberController.text.trim(),
                imageController.text.trim(),
                unitId,
                fromNote: fromNote,
                pdfLink: 'https://drive.google.com/file/d/1s7ohA1irGQsN8QqqXAf_5shZ17zZIKPD/view?usp=sharing',
              )
                  .then((value) {
                Navigator.of(context).pop();
                clearControllers();
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
        child: SolvifyAppbar(title: unitName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            AddChapterCard(
              onTap: () => _showAddChapterDialog(context),
              title: subjectName == FirestoreCollections.yearWise ? "Add a year" : 'Add a chapter',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(fromNote ? FirestoreCollections.revisionNotes : FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).orderBy(FirestoreCollections.chapterName).snapshots(),
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
                      children: documents.map((data) {
                    return ChapterListCard(
                      chapterNumber: data[FirestoreCollections.chapterNumber].toString(),
                      chapterName: data[FirestoreCollections.chapterName],
                      onTap: () {
                        if (fromNote) {
                          pushTo(
                              context,
                              PdfViewerPage(
                                title: data[FirestoreCollections.chapterName],
                                url: data[FirestoreCollections.pdfUrl],
                              ));
                        } else {
                          pushTo(
                            context,
                            AddTopicScreenNCERT(
                              subjectName: subjectName,
                              unitId: unitId,
                              unitName: unitName,
                              chapterId: data.id,
                              chapterName: data[FirestoreCollections.chapterName],
                            ),
                          );
                        }
                      },
                      onDelete: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder: (context, animation, secondaryAnimation) => AppInfoDialog(onLogOut: () async {
                            await Provider.of<AdminProvider>(context, listen: false).deleteChapterNCERT(subjectName, unitId, data.id, fromNote: fromNote).then((value) {
                              Navigator.pop(context);
                              showToast(message: 'deleted Successfully');
                            });
                          }),
                        );
                      },
                      onEdit: () {
                        chapterNameController.text = data[FirestoreCollections.chapterName];
                        chapterNumberController.text = data[FirestoreCollections.chapterNumber];
                        imageController.text = data[FirestoreCollections.chapterImageUrl];
                        pdfLinkController.text = data[FirestoreCollections.pdfUrl];
                        showDialog(
                          context: context,
                          builder: (_) => AddUnitDialog(
                            isTopicScreen: true,
                            chapterNameController: chapterNameController,
                            chapterNumberController: chapterNumberController,
                            pdfLinkController: pdfLinkController,
                            isYear: subjectName == FirestoreCollections.yearWise,
                            onTap: () async {
                              if (chapterNameController.text.isEmpty || chapterNumberController.text.isEmpty) {
                                showToast(message: 'Please enter a chapter number and name', isError: true);
                              } else {
                                try {
                                  await Provider.of<AdminProvider>(context, listen: false)
                                      .updateChapterNCERT(
                                    subjectName,
                                    chapterNameController.text.trim(),
                                    chapterNumberController.text.trim(),
                                    imageController.text.trim(),
                                    unitId,
                                    data.id,
                                    fromNote: fromNote,
                                    pdfLink: pdfLinkController.text.trim(),
                                  )
                                      .then((value) {
                                    Navigator.of(context).pop();
                                    clearControllers();
                                  });
                                } catch (e) {
                                  showToast(message: e.toString(), isError: true);
                                }
                              }
                            },
                            imageController: imageController,
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

int numSortFunctionTopic(a, b) {
  final int? aChapterNumber = int.tryParse(a[FirestoreCollections.chapterNumber]);
  final int? bChapterNumber = int.tryParse(b[FirestoreCollections.chapterNumber]);

  if (aChapterNumber != null && bChapterNumber != null) {
    return aChapterNumber.compareTo(bChapterNumber);
  } else {
    // Handle the case when the chapter number is not a valid integer
    // You can adjust the logic based on your requirements
    return 0;
  }
}
