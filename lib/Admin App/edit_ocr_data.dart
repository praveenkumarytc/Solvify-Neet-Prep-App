import 'package:flutter/material.dart';
import 'package:shield_neet/components/question_form_field.dart';
import 'package:shield_neet/components/solvify_appbar.dart';

class EditOcrDataPage extends StatefulWidget {
  const EditOcrDataPage({super.key, required this.ocrText});
  final String ocrText;

  @override
  State<EditOcrDataPage> createState() => _EditOcrDataPageState();
}

class _EditOcrDataPageState extends State<EditOcrDataPage> {
  final TextEditingController _editingController = TextEditingController();
  @override
  void initState() {
    _editingController.text = widget.ocrText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(50), child: SolvifyAppbar(title: 'Edit OCR text')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: QuestionTextField(controller: _editingController, hintLabelText: 'Make correction'),
      ),
    );
  }
}
