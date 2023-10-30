import 'package:flutter/material.dart';

class TextViewerPage extends StatelessWidget {
  final String text, appbarTitle;

  const TextViewerPage({Key? key, required this.text, required this.appbarTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(text);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(appbarTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Text(text),
      ),
    );
  }

  Widget buildTextWithFormatting(String text) {
    List<InlineSpan> children = [];
    RegExp regex = RegExp(r"\*\*(.*?)\*\*");
    List<String> parts = text.split(regex);
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        children.add(TextSpan(text: parts[i], style: TextStyle(color: Colors.black)));
      } else {
        children.add(TextSpan(text: parts[i], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)));
      }
    }
    return RichText(
      text: TextSpan(children: children),
    );
  }
}
