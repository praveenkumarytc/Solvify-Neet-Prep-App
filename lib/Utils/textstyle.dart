import 'package:flutter/material.dart';
import 'package:shield_neet/Utils/color_resources.dart';

const blackButtonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
const whiteButtonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white);

loginTextFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500, fontSize: 14),
    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY_blue, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY_blue), borderRadius: BorderRadius.all(Radius.circular(10))),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}
