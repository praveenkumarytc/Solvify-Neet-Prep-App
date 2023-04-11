import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/mcq_model.dart';

class UserProvider extends ChangeNotifier {
  UserProvider({this.sharedPreferences});

  SharedPreferences? sharedPreferences;
  List<McqModel> bookmarkedQuestions = [];

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

  void addBookMark(McqModel question) {
    if (!bookmarkedQuestions.contains(question)) {
      bookmarkedQuestions.add(question);
      sharedPreferences!.setStringList(FirestoreCollections.bookMarkedMcq, bookmarkedQuestions.map((q) => json.encode(q.toJson())).toList());
      notifyListeners();
    }
  }

  void removeBookMark(String question) {
    McqModel? bookmarkedQuestion = bookmarkedQuestions.firstWhere((mcq) => mcq.question == question);
    if (bookmarkedQuestion != null) {
      bookmarkedQuestions.remove(bookmarkedQuestion);
      sharedPreferences!.setStringList(FirestoreCollections.bookMarkedMcq, bookmarkedQuestions.map((q) => json.encode(q.toJson())).toList());
      notifyListeners();
    }
  }

  Future<void> fetchBookmarkedQuestions() async {
    List<String>? bookmarkedQuestionStrings = sharedPreferences!.getStringList(FirestoreCollections.bookMarkedMcq);
    if (bookmarkedQuestionStrings != null) {
      bookmarkedQuestions = bookmarkedQuestionStrings.map((q) => McqModel.fromJson(json.decode(q))).toList();
    }
  }

  bool isBookmarked(String question) {
    return bookmarkedQuestions.any((mcq) => mcq.question == question);
  }
}
