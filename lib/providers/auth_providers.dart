// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/home/dashboard.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({this.sharedPreferences});
  SharedPreferences? sharedPreferences;

  String? errorMessage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final _auth = FirebaseAuth.instance;
  Future<void> signUp(BuildContext context, fullName, email, password, mobile) async {
    _isLoading = true;
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        createNewUser(context, fullName, email, password, mobile, value.user!.uid);
      });
    } catch (error) {
      if (error is FirebaseAuthException) {
        _isLoading = false;
        notifyListeners();
        handleAuthError(error);
      } else {
        debugPrint(error.toString());
      }
    }
  }

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((userCredential) async {
        final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
        final userDoc = await userCollection.doc(userCredential.user!.uid).get();
        final uid0 = userDoc.get("uid");
        final userName = userDoc.get("full_name");

        final mobile0 = userDoc.get("mobile");
        final email0 = userDoc.get("email");
        final password0 = userDoc.get("password");
        setPrefDeta(uid0, userName, mobile0, email0, password0);
        Fluttertoast.showToast(msg: "Login Successful as $userName");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashBoard()), (route) => false);
        notifyListeners();
        _isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      handleAuthError(error);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNewUser(BuildContext context, fullName, email, password, mobile, uid) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
    return await userCollection.doc(uid).set({
      "uid": uid,
      "full_name": fullName,
      "mobile": mobile,
      "email": email,
      "password": password,
    }).then((value) {
      signIn(context, email, password);
    });
  }

  Future<void> setPrefDeta(String uid, String fullName, String mobile, String email, String password) async {
    await sharedPreferences!.setString(AppConstans.uid, uid);
    await sharedPreferences!.setString(AppConstans.fullName, fullName);
    await sharedPreferences!.setString(AppConstans.mobile, mobile);
    await sharedPreferences!.setString(AppConstans.email, email);
    await sharedPreferences!.setString(AppConstans.password, password);
    notifyListeners();
  }

  Future<void> logOut() async {
    _auth.signOut();
    await sharedPreferences!.clear();
    notifyListeners();
  }

  String? get uid => sharedPreferences!.getString(AppConstans.uid);
  String? get fullName => sharedPreferences!.getString(AppConstans.fullName);
  String? get mobile => sharedPreferences!.getString(AppConstans.mobile);
  String? get email => sharedPreferences!.getString(AppConstans.email);
  String? get password => sharedPreferences!.getString(AppConstans.password);

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstans.uid);
  }
}

handleAuthError(FirebaseAuthException error) {
  var errorMessage = "An undefined Error happened.";
  if (error.code == "invalid-email") {
    errorMessage = "Your email address appears to be malformed.";
  } else if (error.code == "wrong-password") {
    errorMessage = "Your password is wrong.";
  } else if (error.code == "user-not-found") {
    errorMessage = "User with this email doesn't exist.";
  } else if (error.code == "user-disabled") {
    errorMessage = "User with this email has been disabled.";
  } else if (error.code == "too-many-requests") {
    errorMessage = "Too many requests";
  } else if (error.code == "operation-not-allowed") {
    errorMessage = "Signing in with Email and Password is not enabled.";
  }
  Fluttertoast.showToast(msg: errorMessage);
  debugPrint(error.code);
}
