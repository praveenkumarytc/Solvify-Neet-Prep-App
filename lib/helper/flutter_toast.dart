import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shield_neet/Utils/color_resources.dart';

showToast({required String message, bool isError = false}) {
  Fluttertoast.showToast(msg: message, backgroundColor: isError ? Colors.red : Colors.white, textColor: isError ? Colors.grey.shade200 : Colors.black);
}

showSnackBar(BuildContext context, {required String message, bool isError = true}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: isError ? Colors.red : ColorResources.primaryBlue(context),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
