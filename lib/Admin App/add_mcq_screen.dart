// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Admin%20App/add_mcq_form.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/helper/log_out_dialog.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/providers/admin_provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'add_chapters_screen.dart';

class AddMcqScreen extends StatelessWidget {
  const AddMcqScreen({super.key, required this.chapterName, required this.subjectName, required this.chapterId});
  final String chapterName;
  final String subjectName;
  final String chapterId;

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
              onTap: () => pushTo(
                context,
                AddMcqPage(
                  chapterName: chapterName,
                  chapterId: chapterId,
                  subjectname: subjectName,
                ),
              ),
              title: 'Add a MCQ',
            ),
            20.heightBox,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.mcq).snapshots(),
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
                    List<OptionModel> options = [];
                    for (var i = 0; i < data[FirestoreCollections.options].length; i++) {
                      Map<String, dynamic> mapOption = data[FirestoreCollections.options][i];
                      options.add(OptionModel.fromJson(mapOption));
                    }
                    debugPrint(options.toString());
                    return QuestionCard(
                      question: data[FirestoreCollections.question],
                      options: options,
                      popupMenuButton: PopupMenuButton(
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
                        onSelected: (value) async {
                          if (value == 'edit') {
                            // var querySnapshot = await FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.mcq).get();

                            // var documents = querySnapshot.docs;

                            // List<Map<String, dynamic>> dataList = [];

                            // for (var document in documents) {
                            //   var data = document.data();
                            //   var base64String = data[FirestoreCollections.image] as String;
                            //   var decodedBytes = base64.decode(base64String);
                            //   var decodedString = utf8.decode(decodedBytes);

                            //   data[FirestoreCollections.image] = decodedString;

                            //   dataList.add(data);
                            // }

                            pushTo(
                              context,
                              AddMcqPage(
                                mcqId: data.id,
                                chapterName: chapterName,
                                chapterId: chapterId,
                                subjectname: subjectName,
                                isUpdate: true,
                                question: data[FirestoreCollections.question],
                                options: options,
                                explanation: data[FirestoreCollections.image],
                              ),
                            );
                          } else if (value == 'delete') {
                            showGeneralDialog(
                              context: context,
                              pageBuilder: (context, animation, secondaryAnimation) => AppInfoDialog(
                                onLogOut: () async {
                                  await Provider.of<AdminProvider>(context, listen: false).deleteMcq(subjectName, chapterId, data.id).then(
                                    (value) {
                                      Navigator.pop(context);
                                      showToast(message: 'deleted Successfully');
                                    },
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
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

class QuestionCard extends StatefulWidget {
  final String question;
  final List<OptionModel> options;
  final PopupMenuButton popupMenuButton;
  const QuestionCard({super.key, required this.question, required this.options, required this.popupMenuButton});

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: ColorResources.PRIMARY_MATERIAL,
            width: .4,
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.question,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: widget.popupMenuButton,
            ),
            if (_isExpanded) ...widget.options.map((option) => ListTile(title: Text(option.option_detail))).toList(),
          ],
        ),
      ),
    );
  }
}

class OptionModel {
  OptionModel({required this.opt_no, required this.option_detail, required this.is_correct});
  dynamic opt_no;
  String option_detail;
  bool is_correct;

  factory OptionModel.fromJson(Map<String, dynamic> json) => OptionModel(
        opt_no: json['opt_no'],
        option_detail: json["option_detail"],
        is_correct: json["is_correct"],
      );

  Map<String, dynamic> toJson() => {
        'opt_no': opt_no,
        'option_detail': option_detail,
        'is_correct': is_correct,
      };
}
