import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast({required String message, bool isError = false}) {
  Fluttertoast.showToast(msg: message, backgroundColor: isError ? Colors.red : Colors.white, textColor: isError ? Colors.red : Colors.black);
}
