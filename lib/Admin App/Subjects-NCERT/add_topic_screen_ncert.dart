import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Admin%20App/add_chapters_screen.dart';
import 'package:shield_neet/Admin%20App/add_mcq_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/add_unit_dialog.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/helper/log_out_dialog.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/providers/pdf_viewer.dart';

import '../../providers/admin_provider.dart';

class AddTopicScreenNCERT extends StatelessWidget {
  AddTopicScreenNCERT({
    super.key,
    required this.subjectName,
    required this.unitId,
    required this.unitName,
    required this.chapterId,
    required this.chapterName,
  });
  final String subjectName;
  final String unitName;
  final String unitId;
  final String chapterId;
  final String chapterName;

  final TextEditingController topicNameController = TextEditingController();
  final TextEditingController topicNumberController = TextEditingController();
  final TextEditingController pdfLinkController = TextEditingController();
  void _showAddChapterDialog(BuildContext context) {
    topicNameController.clear();
    topicNumberController.clear();
    pdfLinkController.clear();
    showDialog(
      context: context,
      builder: (_) => AddUnitDialog(
        imageController: pdfLinkController,
        chapterNameController: topicNameController,
        chapterNumberController: topicNumberController,
        isYear: subjectName == FirestoreCollections.yearWise,
        isTopicScreen: true,
        onTap: () async {
          if (topicNumberController.text.isEmpty || topicNameController.text.isEmpty) {
            showToast(message: 'Please enter a valid data', isError: true);
          } else {
            try {
              await Provider.of<AdminProvider>(context, listen: false)
                  .addTopicNCERT(
                subjectName,
                unitId,
                chapterId,
                topicNameController.text.trim(),
                pdfLinkController.text,
                topicNumberController.text.trim(),
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
                height: MediaQuery.of(context).size.height * 0.75,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).orderBy(FirestoreCollections.topicNumber).snapshots(),
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
                      return TopicCard(
                        onTap: () {
                          pushTo(
                              context,
                              AddMcqScreen(
                                chapterName: chapterName,
                                subjectName: subjectName,
                                chapterId: chapterId,
                                topicName: data[FirestoreCollections.topicName],
                                topicId: data.id,
                                unitId: unitId,
                                fromNCERT: true,
                              ));
                        },
                        pdfLink: pdfLinkController.text = data[FirestoreCollections.pdfUrl],
                        chapterNumber: data[FirestoreCollections.topicNumber].toString(),
                        chapterName: data[FirestoreCollections.topicName],
                        // onTap: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => AddMcqScreen(
                        //       chapterName: chapterName,
                        //       subjectName: subjectName,
                        //       chapterId: chapterId,
                        //       topicId: data.id,
                        //       topicName: data[FirestoreCollections.topicName],
                        //     ),
                        //   ),
                        // ),
                        onDelete: () {
                          showGeneralDialog(
                            context: context,
                            pageBuilder: (context, animation, secondaryAnimation) => AppInfoDialog(onLogOut: () async {
                              await Provider.of<AdminProvider>(context, listen: false).deleteTopicNCERT(subjectName, unitId, chapterId, data.id).then((value) {
                                Navigator.pop(context);
                                showToast(message: 'deleted Successfully');
                              });
                            }),
                          );
                        },
                        onEdit: () {
                          topicNameController.text = data[FirestoreCollections.topicName];
                          topicNumberController.text = data[FirestoreCollections.topicNumber];
                          pdfLinkController.text = data[FirestoreCollections.pdfUrl];
                          showDialog(
                            context: context,
                            builder: (_) => AddUnitDialog(
                              imageController: pdfLinkController,
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
                                        .updateTopicNCERT(
                                      subjectName,
                                      unitId,
                                      chapterId,
                                      topicNameController.text.trim(),
                                      topicNumberController.text.trim(),
                                      pdfLinkController.text,
                                      data.id,
                                    )
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      topicNameController.clear();
                                      topicNumberController.clear();
                                      pdfLinkController.clear();
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
        ));
  }
}

class TopicCard extends StatelessWidget {
  const TopicCard({
    super.key,
    required this.chapterName,
    required this.chapterNumber,
    required this.onDelete,
    required this.onTap,
    required this.onEdit,
    required this.pdfLink,
  });

  final String chapterName;
  final String chapterNumber;
  final Function() onDelete;
  final Function() onTap;
  final Function() onEdit;
  final String pdfLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: ColorResources.PRIMARY_MATERIAL,
          width: .4,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          height: 45,
          width: 40,
          decoration: BoxDecoration(
            color: ColorResources.PRIMARY_MATERIAL.withOpacity(.8),
            border: Border.all(
              color: ColorResources.BLACK.withOpacity(.4),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            chapterNumber,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        title: Text(chapterName),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'viewpdf',
              child: Text('View PDF'),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              onEdit.call();
            } else if (value == 'viewpdf') {
              pushTo(
                context,
                PdfViewerPage(
                  title: chapterName,
                  url: pdfLink,
                ),
              );
            } else if (value == 'delete') {
              onDelete.call();
            }
          },
        ),
      ),
    );
  }
}
