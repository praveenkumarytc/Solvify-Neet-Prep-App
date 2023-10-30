import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Utils/dimensions.dart';

void showToast({required bool isError, required String message}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: isError ? Colors.red : Colors.white,
    textColor: isError ? Colors.white : Colors.black,
    fontSize: 16.0,
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
  );
}

void showErrorSnackBar(BuildContext context, message, {bool isError = true}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(key: UniqueKey(), content: Text("$message"), margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), behavior: SnackBarBehavior.floating, dismissDirection: DismissDirection.down, backgroundColor: isError ? Colors.red : Colors.green),
    );
}

void showErrorSnackBarNew(BuildContext context, message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showMorphisSnacBar(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    content: Toaster(message: message),
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.transparent,
    closeIconColor: Colors.red,
    showCloseIcon: true,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class Toaster extends StatelessWidget {
  final String message;

  const Toaster({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
