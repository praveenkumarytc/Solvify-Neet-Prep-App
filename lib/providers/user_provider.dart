import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_neet/Utils/app_constants.dart';

class UserProvider extends ChangeNotifier {
  UserProvider({this.sharedPreferences});
  SharedPreferences? sharedPreferences;

  storeAppTheme(bool isDark) {
    sharedPreferences!.setBool(AppConstans.appTheme, isDark);
    notifyListeners();
  }

  toggleAppTheme() {
    bool isDarkMode = sharedPreferences!.getBool(AppConstans.appTheme) ?? false;
    storeAppTheme(!isDarkMode);
    notifyListeners();
  }

  bool? get isDarkMode => sharedPreferences!.getBool(AppConstans.appTheme) ?? false;

  Future<void> addBookMark(uid, question, List<Map<String, dynamic>> options, image) async {
    final CollectionReference bookMarkCollection = FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(uid).collection(FirestoreCollections.bookMarkedMcq);
    return await bookMarkCollection.doc().set(
      {
        FirestoreCollections.options: options,
        FirestoreCollections.question: question,
        FirestoreCollections.image: image
      },
    );
  }
}
