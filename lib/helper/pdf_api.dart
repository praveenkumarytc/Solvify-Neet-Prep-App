import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

class PDFApi {
  // static Future<File> loadAsset(String path) async {
  //   final data = await rootBundle.load(path);
  //   final bytes = data.buffer.asUint8List();

  //   return _storeFile(path, bytes);
  // }

  static String modifieURL(gDriveUrl) {
    final pdfUrl = gDriveUrl;
    RegExp regExp = RegExp(r"/d/([a-zA-Z0-9-_]+)");
    RegExpMatch? match = regExp.firstMatch(pdfUrl);
    String? id = match?.group(1);
    debugPrint('https://drive.google.com/uc?export=view&id=$id');
    return 'https://drive.google.com/uc?export=view&id=$id';
  }

  // static Future<File> loadfromGdrive(String gDriveUrl) async {
  //   final url = modifieURL(gDriveUrl);

  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     final bytes = response.bodyBytes;
  //     return _storeFile(url, bytes);
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  // static Future<File> _storeFile(String url, List<int> bytes) async {
  //   try {
  //     final filename = basename(url);
  //     final dir = await getApplicationDocumentsDirectory();

  //     final file = File('${dir.path}/$filename');
  //     await file.writeAsBytes(bytes, flush: true);
  //     return file;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  /* static Future<File> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return null;
    return File(result.paths.first);
  }*/

  /*static Future<File> loadFirebase(String url) async {
    try {
      final refPDF = FirebaseStorage.instance.ref().child(url);
      final bytes = await refPDF.getData();

      return _storeFile(url, bytes);
    } catch (e) {
      return null;
    }
  }*/
}
