import 'package:flutter/material.dart';
import 'package:shield_neet/Utils/color_resources.dart';

class QuestionTextField extends StatelessWidget {
  const QuestionTextField({
    super.key,
    this.focusNode,
    required this.controller,
    required this.hintLabelText,
  });

  final FocusNode? focusNode;
  final TextEditingController controller;
  final String hintLabelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      maxLines: null,
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hintLabelText,
          labelText: hintLabelText,
          contentPadding: const EdgeInsets.all(10),
          hintStyle: TextStyle(color: Colors.grey.shade400),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorResources.PRIMARY_MATERIAL),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )),
    );
  }
}
