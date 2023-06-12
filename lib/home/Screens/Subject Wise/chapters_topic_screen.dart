import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shield_neet/Admin%20App/add_chapters_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/chapters_screen.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/test_loading.dart';
import 'package:shield_neet/pdf%20viwer/attemp_mcq_pdf.dart';

class ChapterTopicsPage extends StatelessWidget {
  const ChapterTopicsPage({
    super.key,
    required this.chapterId,
    required this.chapterName,
    required this.subjectname,
    this.fromNCERT = false,
    this.unitId,
  });
  final String chapterId;
  final String chapterName;
  final String subjectname;
  final String? unitId;
  final bool fromNCERT;
  Stream<QuerySnapshot<Object?>> topicSteream() {
    if (fromNCERT) {
      return FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(subjectname).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).snapshots();
    } else {
      return FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectname).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: SolvifyAppbar(title: 'All Topics'),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScroll(),
        child: StreamBuilder<QuerySnapshot>(
          stream: topicSteream(),
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
            documents.sort(numSortFunctionTopic);

            return ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                children: documents.map((data) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (fromNCERT) {
                            pushTo(
                              context,
                              PdfViewerPageMCQ(
                                title: data[FirestoreCollections.topicName],
                                chapterId: chapterId,
                                chapterName: chapterName,
                                subjectname: subjectname,
                                fromNCERT: fromNCERT,
                                unitId: unitId,
                                topicId: data.id,
                                url: data[FirestoreCollections.pdfUrl],
                              ),
                            );
                          } else {
                            pushTo(
                                context,
                                LoadingScreen(
                                  subjectName: subjectname,
                                  chapterId: chapterId,
                                  topicId: data.id,
                                ));
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                color: ColorResources.PRIMARY_MATERIAL,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  data[FirestoreCollections.topicNumber].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                data[FirestoreCollections.topicName],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Opacity(
                              opacity: 0.6,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: ColorResources.PRIMARY_MATERIAL,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
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
