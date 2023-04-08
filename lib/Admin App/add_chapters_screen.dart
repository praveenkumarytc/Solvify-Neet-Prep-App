import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Admin%20App/add_mcq_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/add_chapter_diaglog.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/helper/log_out_dialog.dart';
import 'package:shield_neet/providers/admin_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddChapterScreen extends StatelessWidget {
  AddChapterScreen({super.key, required this.subjectName});
  final String subjectName;

  final TextEditingController chapterNameController = TextEditingController();
  final TextEditingController chapterNumberController = TextEditingController();

  void _showAddChapterDialog(BuildContext context) {
    chapterNameController.clear();
    chapterNumberController.clear();
    showDialog(
      context: context,
      builder: (_) => AddChapterDialog(
        chapterNameController: chapterNameController,
        chapterNumberController: chapterNumberController,
        isYear: subjectName == FirestoreCollections.yearWise,
        onTap: () async {
          if (chapterNumberController.text.isEmpty || chapterNameController.text.isEmpty) {
            showToast(message: 'Please enter a valid data', isError: true);
          } else {
            try {
              await Provider.of<AdminProvider>(context, listen: false).addChapters(subjectName, chapterNameController.text.trim(), chapterNumberController.text.trim()).then((value) {
                Navigator.of(context).pop();
                chapterNameController.clear();
                chapterNumberController.clear();
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
            AddChapterCard(
              onTap: () => _showAddChapterDialog(context),
              title: subjectName == FirestoreCollections.yearWise ? "Add a year" : 'Add a chapter',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error occured');
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                      children: snapshot.data!.docs.map((data) {
                    return ChapterListCard(
                      chapterNumber: data[FirestoreCollections.chapterNumber].toString(),
                      chapterName: data[FirestoreCollections.chapterName],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMcqScreen(
                            chapterName: data[FirestoreCollections.chapterName],
                            subjectName: subjectName,
                            chapterId: data.id,
                          ),
                        ),
                      ),
                      onDelete: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder: (context, animation, secondaryAnimation) => AppInfoDialog(onLogOut: () async {
                            await Provider.of<AdminProvider>(context, listen: false).deleteChapter(subjectName, data.id).then((value) {
                              Navigator.pop(context);
                              showToast(message: 'deleted Successfully');
                            });
                          }),
                        );
                      },
                      onEdit: () {
                        chapterNameController.text = data[FirestoreCollections.chapterName];
                        chapterNumberController.text = data[FirestoreCollections.chapterNumber];
                        showDialog(
                          context: context,
                          builder: (_) => AddChapterDialog(
                            chapterNameController: chapterNameController,
                            chapterNumberController: chapterNumberController,
                            isYear: subjectName == FirestoreCollections.yearWise,
                            onTap: () async {
                              if (chapterNumberController.text.isEmpty || chapterNameController.text.isEmpty) {
                                showToast(message: 'Please enter a chapter number and name', isError: true);
                              } else {
                                try {
                                  await Provider.of<AdminProvider>(context, listen: false).updateChapter(subjectName, chapterNameController.text.trim(), chapterNumberController.text.trim(), data.id).then((value) {
                                    Navigator.of(context).pop();
                                    chapterNameController.clear();
                                    chapterNumberController.clear();
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

class ChapterListCard extends StatelessWidget {
  const ChapterListCard({super.key, required this.chapterName, required this.chapterNumber, required this.onDelete, required this.onTap, required this.onEdit});

  final String chapterName;
  final String chapterNumber;
  final Function() onDelete;
  final Function() onTap;
  final Function() onEdit;

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
            } else if (value == 'delete') {
              onDelete.call();
            }
          },
        ),
      ),
    );
  }
}

class AddChapterCard extends StatelessWidget {
  const AddChapterCard({super.key, required this.onTap, required this.title});
  final Function() onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: ColorResources.PRIMARY_MATERIAL,
            width: .4,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              size: 34,
              color: ColorResources.COLOR_BLUE,
            ),
            10.widthBox,
            Text(
              title,
              style: const TextStyle(
                color: ColorResources.COLOR_BLUE,
                fontSize: 22,
              ),
            )
          ],
        ),
      ),
    );
  }
}
