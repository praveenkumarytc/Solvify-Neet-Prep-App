// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/chapters_screen.dart';
import '../../../Admin App/Subjects-NCERT/add_unit_screen.dart';

class SubjectUnitScreen extends StatelessWidget {
  const SubjectUnitScreen({
    super.key,
    required this.subjectName,
    this.fromNCERT = false,
    this.fromNote = false,
  });
  final String subjectName;
  final bool fromNCERT;
  final bool fromNote;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        centerTitle: true,
        title: Text(
          subjectName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScroll(),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(fromNote ? FirestoreCollections.revisionNotes : FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).orderBy(FirestoreCollections.unitNumber).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error occured');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final documents = snapshot.data!.docs;
            documents.sort(numSortFunctionUnit);

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final data = documents[index];
                final color = index % 2 == 0 ? Colors.red : Colors.blue;
                return NewChapterCard(
                  color: color,
                  chapterName: data[FirestoreCollections.unitName],
                  chapterNumber: data[FirestoreCollections.unitNumber],
                  onTap: () {
                    pushTo(
                      context,
                      ChapterScreen(
                        subjectName: subjectName,
                        fromNCERT: fromNCERT,
                        unitId: data.id,
                        fromNote: fromNote,
                      ),
                    );
                  },
                );

                //   CustomCard(
                //   unitImageUrl: data[FirestoreCollections.unitImageUrl],
                //   unitNumber: data[FirestoreCollections.unitNumber],
                //   unitName: data[FirestoreCollections.unitName],
                //   itemId: data.id,
                //   onTap: () async {
                //     pushTo(
                //       context,
                //       ChapterScreen(
                //         subjectName: subjectName,
                //         fromNCERT: fromNCERT,
                //         unitId: data.id,
                //         fromNote: fromNote,
                //       ),
                //     );
                //   },
                // );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            );
          },
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String unitImageUrl;
  final String unitNumber;
  final String unitName;
  final dynamic itemId;
  final Function() onTap;
  const CustomCard({
    Key? key,
    required this.unitImageUrl,
    required this.unitNumber,
    required this.unitName,
    required this.itemId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: unitImageUrl,
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  color: ColorResources.PRIMARY_MATERIAL,
                ),
                errorWidget: (context, url, error) => Container(
                  color: ColorResources.PRIMARY_MATERIAL,
                ),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    // borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unitNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  gradient: RadialGradient(
                    colors: [
                      Colors.black26,
                      Colors.black26,
                      Colors.black38,
                      Colors.black45,
                      Colors.black54,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        unitName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewChapterCard extends StatelessWidget {
  const NewChapterCard({
    super.key,
    required this.chapterName,
    required this.chapterNumber,
    this.onTap,
    required this.color,
  });
  final String chapterName;
  final String chapterNumber;
  final Function()? onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        minLeadingWidth: 1,
        leading: Container(
          width: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward),
        title: Text(
          chapterName,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
