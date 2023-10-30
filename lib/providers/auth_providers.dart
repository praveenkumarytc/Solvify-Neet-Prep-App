// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/helper/custom_loder.dart';
import 'package:shield_neet/helper/show_toast.dart';
import 'package:shield_neet/home/dashboard.dart';
import 'package:shield_neet/on%20boarding/registration_page.dart';
import 'package:shield_neet/splash_page.dart';

import '../main.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({this.sharedPreferences});
  SharedPreferences? sharedPreferences;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? errorMessage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final _auth = FirebaseAuth.instance;
  Future<void> signUp(BuildContext context, fullName, email, password, mobile) async {
    _isLoading = true;
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        setPrefDeta(value.user!.uid, fullName, mobile, email, password);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RegistrationPage(emailId: email, fullName: fullName, loginMethod: 'email&pass')), (route) => false);
        // createNewUser(context, fullName, email, password, mobile, value.user!.uid);
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
        await userCollection.doc(uid0).update({
          "fcm_token": await messaging.getToken(),
        });
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

  Future<bool?> createNewUser(BuildContext context, int avtarId, fullName, email, password, mobile, uid, batch, loginMethod, state) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
    return await userCollection.doc(uid).set({
      "loginMethod": loginMethod,
      "avtarId": avtarId,
      "uid": uid,
      "full_name": fullName,
      "mobile": mobile,
      "email": email,
      "password": password,
      "state": state,
      "batch": batch,
      "fcm_token": await messaging.getToken()
    }).then((value) {
      setPrefDeta(uid, fullName, mobile, email, password);
      if (loginMethod != "googleAuth") {
        signIn(context, email, password);
        return false;
      } else {
        return true;
      }
    });
  }

  //SIGN IN WITH GOOGLE ACCOUNT

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  BuildContext context = navigatorKey.currentContext!;
  Future<User?> signInWithGoogle() async {
    User? user;
    try {
      CustomLoader.show(context, text: 'Fethcing Google Accounts');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => RegistrationPage(
                  emailId: user!.email!,
                  fullName: user.displayName ?? '',
                  loginMethod: 'googleAuth',
                  uid: user.uid,
                  password: '12345678',
                ),
              ),
              (route) => false);
        } else {
          final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
          final userDoc = await userCollection.doc(userCredential.user!.uid).get();
          final uid0 = userDoc.get("uid");
          final userName = userDoc.get("full_name");

          final mobile0 = userDoc.get("mobile");
          final email0 = userDoc.get("email");
          final password0 = userDoc.get("password");
          setPrefDeta(uid0, userName, mobile0, email0, password0);
          await userCollection.doc(uid0).update({
            "fcm_token": await messaging.getToken(),
          });
          Fluttertoast.showToast(msg: "Login Successful as $userName");
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => const DashBoard(),
              ),
              (route) => false);
        }
      } else {
        return user;
      }
    } on FirebaseAuthException catch (e) {
      print("Error ->  ${e}");
      showErrorSnackBar(context, e.code.toString());
      return user;
    }
    return user;
  }

  Future<void> signOut() async {
    try {
      CustomLoader.show(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashPage(),
          ),
          (route) => false);
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {}
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
  print("Error ->  ${error}");
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
  } else if (error.code == "network-request-failed") {
    errorMessage = "Network request failed due to internet connection";
  }
  Fluttertoast.showToast(msg: errorMessage);
  debugPrint(error.code);
}
