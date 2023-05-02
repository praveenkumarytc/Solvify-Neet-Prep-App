import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/models/uploadProductGallaryModel.dart';
import 'package:http/http.dart' as http;

class AdminProvider extends ChangeNotifier {
  AdminProvider({this.sharedPreferences});
  SharedPreferences? sharedPreferences;

  Future<void> addChapters(subjectName, chapterName, chapterNumber) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters);
    return await medicineCollection.doc().set({
      FirestoreCollections.chapterName: chapterName,
      FirestoreCollections.chapterNumber: chapterNumber,
    });
  }

  Future<void> updateChapter(subjectName, chapterName, chapterNumber, chapterId) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters);
    return await medicineCollection.doc(chapterId).set({
      FirestoreCollections.chapterName: chapterName,
      FirestoreCollections.chapterNumber: chapterNumber,
    });
  }

  Future<void> deleteChapter(subjectName, chapterId) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters);
    return await medicineCollection.doc(chapterId).delete();
  }

  Future<void> deleteMcq(subjectName, chapterId, mcqId) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.mcq);
    return await medicineCollection.doc(mcqId).delete();
  }

  Future<void> addMcq(subjectName, chapterId, question, List<Map<String, dynamic>> options, image) async {
    final CollectionReference mcqCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.mcq);
    return await mcqCollection.doc().set({
      FirestoreCollections.options: options,
      FirestoreCollections.question: question,
      FirestoreCollections.image: image
    });
  }

  Future<void> updateAddMcq(mcqId, subjectName, chapterId, question, List<Map<String, dynamic>> options, image) async {
    final CollectionReference mcqCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.mcq);
    return await mcqCollection.doc(mcqId).set({
      FirestoreCollections.options: options,
      FirestoreCollections.question: question,
      FirestoreCollections.image: image
    });
  }

  Future<void> addBookMark(uid, question, List<Map<String, dynamic>> options, image) async {
    final CollectionReference bookMarkCollection = FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(uid).collection(FirestoreCollections.bookMarkedMcq);
    return await bookMarkCollection.doc().set({
      FirestoreCollections.options: options,
      FirestoreCollections.question: question,
      FirestoreCollections.image: image
    });
  }

  UploadImage? _uploadImgae;
  UploadImage? get uploadImgae => _uploadImgae;

  Future<UploadImage?> uploadQuestionImage(BuildContext context, String image) async {
    String uploadUrl = 'http://ivf.ekaltech.com/api/upload_product_image';

    Uri parsedUri = Uri.parse(uploadUrl);

    var body = {
      "connection_id": "OVQH19P\$2C",
      "auth_code": 'M#LEB6T5ZH',
      "image": image
    };

    debugPrint(body.toString());

    final response = await http.post(parsedUri, body: body);

    debugPrint(response.body);

    _uploadImgae = UploadImage.fromJson(json.decode(response.body));

    notifyListeners();

    return _uploadImgae;
  }
}
