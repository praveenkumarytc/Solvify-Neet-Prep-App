import 'package:flutter/material.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/dimensions.dart';
import 'package:shield_neet/main.dart';

void showToast({required String message, bool isError = false}) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
  ScaffoldMessenger.of(navigatorKey.currentContext!)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(key: UniqueKey(), content: Text("$message"), margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), behavior: SnackBarBehavior.floating, dismissDirection: DismissDirection.down, backgroundColor: isError ? Colors.red : Colors.green),
    );
}

// showToast({required String message, bool isError = false}) {
//   Fluttertoast.showToast(msg: message, backgroundColor: isError ? Colors.red : Colors.white, textColor: isError ? Colors.grey.shade200 : Colors.black);
// }

// to show snackbar
showSnackBar(BuildContext context, {required String message, bool isError = true}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: isError ? Colors.red : ColorResources.primaryBlue(context),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
