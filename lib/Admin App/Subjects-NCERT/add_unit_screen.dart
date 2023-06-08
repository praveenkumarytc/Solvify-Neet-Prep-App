import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Admin%20App/Subjects-NCERT/add_chapter_unit_admin.dart';
import 'package:shield_neet/Admin%20App/add_chapters_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/helper/log_out_dialog.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/providers/admin_provider.dart';

import '../../components/add_unit_dialog.dart';

class AddUnitAdminPage extends StatelessWidget {
  AddUnitAdminPage({super.key, required this.subjectName, this.fromNote = false});
  final String subjectName;
  final bool fromNote;

  final TextEditingController unitNameController = TextEditingController();
  final TextEditingController unitNumberController = TextEditingController();
  final TextEditingController unitImageController = TextEditingController();

  void _showAddChapterDialog(BuildContext context) {
    unitNameController.clear();
    unitNumberController.clear();
    unitImageController.clear();
    showDialog(
      context: context,
      builder: (_) => AddUnitDialog(
        imageController: unitImageController,
        chapterNameController: unitNameController,
        chapterNumberController: unitNumberController,
        isYear: false,
        onTap: () async {
          if (unitNumberController.text.isEmpty || unitNameController.text.isEmpty || unitImageController.text.isEmpty) {
            showToast(message: 'All the fields are required', isError: true);
          } else {
            try {
              await Provider.of<AdminProvider>(context, listen: false).addUnit(subjectName, unitNameController.text.trim(), unitNumberController.text.trim(), unitImageController.text.trim(), fromNote: fromNote).then((value) {
                Navigator.of(context).pop();
                unitNameController.clear();
                unitNumberController.clear();
                unitImageController.clear();
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
        child: SolvifyAppbar(title: subjectName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            AddChapterCard(onTap: () => _showAddChapterDialog(context), title: 'Add a unit'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(fromNote ? FirestoreCollections.revisionNotes : FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).orderBy(FirestoreCollections.unitNumber).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error occured');
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final documents = snapshot.data!.docs;
                  documents.sort(numSortFunctionUnit);
                  return ListView(
                      children: documents.map((data) {
                    return ChapterListCard(
                      chapterNumber: data[FirestoreCollections.unitNumber].toString(),
                      chapterName: data[FirestoreCollections.unitName],
                      onTap: () {
                        pushTo(
                            context,
                            AddUnitChapterScreenAdmin(
                              subjectName: subjectName,
                              unitId: data.id,
                              unitName: data[FirestoreCollections.unitName],
                              fromNote: fromNote,
                            ));
                      },
                      onDelete: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder: (context, animation, secondaryAnimation) => AppInfoDialog(onLogOut: () async {
                            await Provider.of<AdminProvider>(context, listen: false).deleteUnitNCERT(subjectName, data.id, fromNote: fromNote).then((value) {
                              Navigator.pop(context);
                              showToast(message: 'deleted Successfully');
                            });
                          }),
                        );
                      },
                      onEdit: () {
                        unitNameController.text = data[FirestoreCollections.unitName];
                        unitNumberController.text = data[FirestoreCollections.unitNumber];
                        unitImageController.text = data[FirestoreCollections.unitImageUrl];
                        showDialog(
                          context: context,
                          builder: (_) => AddUnitDialog(
                            chapterNameController: unitNameController,
                            chapterNumberController: unitNumberController,
                            imageController: unitImageController,
                            isYear: subjectName == FirestoreCollections.yearWise,
                            onTap: () async {
                              if (unitNumberController.text.isEmpty || unitNameController.text.isEmpty) {
                                showToast(message: 'Please enter a Unit number and name', isError: true);
                              } else {
                                try {
                                  await Provider.of<AdminProvider>(context, listen: false).updateUnit(subjectName, unitNameController.text.trim(), unitNumberController.text.trim(), unitImageController.text.trim(), data.id, fromNote: fromNote).then((value) {
                                    Navigator.of(context).pop();
                                    unitNameController.clear();
                                    unitNumberController.clear();
                                    unitImageController.clear();
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

int numSortFunctionUnit(a, b) {
  final int? aChapterNumber = int.tryParse(a[FirestoreCollections.unitNumber]);
  final int? bChapterNumber = int.tryParse(b[FirestoreCollections.unitNumber]);

  if (aChapterNumber != null && bChapterNumber != null) {
    return aChapterNumber.compareTo(bChapterNumber);
  } else {
    // Handle the case when the chapter number is not a valid integer
    // You can adjust the logic based on your requirements
    return 0;
  }
}
