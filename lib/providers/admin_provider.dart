import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/models/uploadProductGallaryModel.dart';

import '../models/pexel_image_model.dart';

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

  Future<void> addChapterTopic(subjectName, topicName, topicNumber, chapterId) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic);
    return await medicineCollection.doc().set({
      FirestoreCollections.topicName: topicName,
      FirestoreCollections.topicNumber: topicNumber,
    });
  }

  Future<void> updateChapterTopic(subjectName, chapterName, chapterNumber, chapterId, topicId) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic);
    return await medicineCollection.doc(topicId).set({
      FirestoreCollections.topicName: chapterName,
      FirestoreCollections.topicNumber: chapterNumber,
    });
  }

  Future<void> deleteChapterTopic(subjectName, chapterName, topicId) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterName).collection(FirestoreCollections.chapterTopic);
    return await medicineCollection.doc(topicId).delete();
  }

  Future<void> deleteMcq(subjectName, chapterId, topicId, mcqId) async {
    final CollectionReference mcqCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).doc(topicId).collection(FirestoreCollections.mcq);
    return await mcqCollection.doc(mcqId).delete();
  }

  Future<void> addMcq(subjectName, chapterId, topicId, question, List<Map<String, dynamic>> options, image) async {
    final CollectionReference mcqCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).doc(topicId).collection(FirestoreCollections.mcq);
    return await mcqCollection.doc().set({
      FirestoreCollections.options: options,
      FirestoreCollections.question: question,
      FirestoreCollections.image: image
    });
  }

  Future<void> updateAddMcq(topicId, mcqId, subjectName, chapterId, question, List<Map<String, dynamic>> options, image) async {
    final CollectionReference mcqCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(subjectName).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).doc(topicId).collection(FirestoreCollections.mcq);
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

  //NCERT BASED SUBJECTS
  Future<void> addUnit(subjectName, unitName, unitNumber, imageUrl, {bool fromNote = false}) async {
    final CollectionReference unitCollection = FirebaseFirestore.instance.collection(fromNote ? FirestoreCollections.revisionNotes : FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units);
    return await unitCollection.doc().set({
      FirestoreCollections.unitName: unitName,
      FirestoreCollections.unitNumber: unitNumber,
      FirestoreCollections.unitImageUrl: imageUrl,
    });
  }

  Future<void> updateUnit(subjectName, unitName, unitNumber, imageUrl, unitid, {bool fromNote = false}) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(fromNote ? FirestoreCollections.revisionNotes : FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units);
    return await medicineCollection.doc(unitid).set({
      FirestoreCollections.unitName: unitName,
      FirestoreCollections.unitNumber: unitNumber,
      FirestoreCollections.unitImageUrl: imageUrl,
    });
  }

  Future<void> deleteUnitNCERT(subjectName, unitId, {bool fromNote = false}) async {
    final CollectionReference unitCollection = FirebaseFirestore.instance.collection(fromNote ? FirestoreCollections.revisionNotes : FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units);
    return await unitCollection.doc(unitId).delete();
  }

  Future<void> addChapterNCERT(subjectName, chapterName, chapterNumber, imageUrl, unitId, {bool fromNote = false, String pdfLink = ''}) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(fromNote ? FirestoreCollections.revisionNotes : FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters);

    var data = fromNote
        ? {
            FirestoreCollections.chapterName: chapterName,
            FirestoreCollections.chapterNumber: chapterNumber,
            FirestoreCollections.chapterImageUrl: imageUrl,
            FirestoreCollections.pdfUrl: pdfLink
          }
        : {
            FirestoreCollections.chapterName: chapterName,
            FirestoreCollections.chapterNumber: chapterNumber,
            FirestoreCollections.chapterImageUrl: imageUrl
          };
    return await medicineCollection.doc().set(data);
  }

  Future<void> updateChapterNCERT(subjectName, chapterName, chapterNumber, imageUrl, unitId, chapterId, {bool fromNote = false, String pdfLink = ''}) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(fromNote ? FirestoreCollections.revisionNotes : FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters);

    var data = fromNote
        ? {
            FirestoreCollections.chapterName: chapterName,
            FirestoreCollections.chapterNumber: chapterNumber,
            FirestoreCollections.chapterImageUrl: imageUrl,
            FirestoreCollections.pdfUrl: pdfLink
          }
        : {
            FirestoreCollections.chapterName: chapterName,
            FirestoreCollections.chapterNumber: chapterNumber,
            FirestoreCollections.chapterImageUrl: imageUrl,
          };
    return await medicineCollection.doc(chapterId).set(data);
  }

  Future<void> deleteChapterNCERT(subjectName, unitId, chapterId, {bool fromNote = false}) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(fromNote ? FirestoreCollections.revisionNotes : FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters);
    return await medicineCollection.doc(chapterId).delete();
  }

  Future<void> addTopicNCERT(subjectName, unitId, chapterId, topicName, pdfLink, topicNumber) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic);
    return await medicineCollection.doc().set({
      FirestoreCollections.topicName: topicName,
      FirestoreCollections.topicNumber: topicNumber,
      FirestoreCollections.pdfUrl: pdfLink
    });
  }

  Future<void> updateTopicNCERT(subjectName, unitId, chapterId, topicName, topicNumber, pdfLink, topicId) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic);
    return await medicineCollection.doc(topicId).set({
      FirestoreCollections.topicName: topicName,
      FirestoreCollections.topicNumber: topicNumber,
      FirestoreCollections.pdfUrl: pdfLink
    });
  }

  Future<void> deleteTopicNCERT(subjectName, unitId, chapterId, topicId) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic);
    return await medicineCollection.doc(topicId).delete();
  }

  Future<void> deleteMcqNCERT(subjectName, unitId, chapterId, topicId, mcqId) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).doc(topicId).collection(FirestoreCollections.mcq);
    return await medicineCollection.doc(mcqId).delete();
  }

  Future<void> addMcqNCERT(subjectName, unitId, chapterId, topicId, question, List<Map<String, dynamic>> options, image) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).doc(topicId).collection(FirestoreCollections.mcq);
    return await medicineCollection.doc().set({
      FirestoreCollections.options: options,
      FirestoreCollections.question: question,
      FirestoreCollections.image: image
    });
  }

  Future<void> updateAddMcqNCERT(unitId, topicId, mcqId, subjectName, chapterId, question, List<Map<String, dynamic>> options, image) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(subjectName).collection(FirestoreCollections.units).doc(unitId).collection(FirestoreCollections.chapters).doc(chapterId).collection(FirestoreCollections.chapterTopic).doc(topicId).collection(FirestoreCollections.mcq);
    return await medicineCollection.doc(mcqId).set({
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

  PexelImageModel? _pexelImageModel;
  PexelImageModel? get pexelImageModel => _pexelImageModel;

  final List<Photo> _photos = [];
  List<Photo> get photos => _photos;
  Future<PexelImageModel?> fetchPexelImages(BuildContext context, query, page) async {
    String perPage = '20';
    String pexelUrl = 'https://api.pexels.com/v1/search?query=$query&per_page=$perPage&page=$page';

    Uri parsedUri = Uri.parse(pexelUrl);

    debugPrint(pexelUrl);
    try {
      final response = await http.get(parsedUri, headers: {
        "Authorization": "6Fd87RyZT1tzI1l3VA4v0SRzW9Ip7vIgTcALHi0iEL8VZufNufJux0Bi"
      });

      debugPrint("response ==>> ${response.body}");
      if (jsonDecode(response.body)["status"] == 400) {
        showToast(message: jsonDecode(response.body)["code"]);
      }

      _pexelImageModel = PexelImageModel.fromJson(json.decode(response.body));
    } catch (e) {
      showToast(message: e.toString());
      debugPrint(e.toString());
    }

    notifyListeners();

    return _pexelImageModel;
  }
}
