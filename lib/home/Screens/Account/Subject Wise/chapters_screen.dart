import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shield_neet/components/solvify_appbar.dart';

class ChapterScreen extends StatefulWidget {
  const ChapterScreen({super.key, required this.subjectName});
  final String subjectName;

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SolvifyAppbar(title: "${widget.subjectName} Chapters"),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScroll(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: List.generate(
                15,
                (index) => const ListTile(
                      leading: CircleAvatar(child: Icon(Icons.add)),
                      title: Text(
                        'Integers',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('5 categories'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    )),
          ),
        ),
      ),
    );
  }
}

class NoGlowScroll extends ScrollBehavior {
  Widget noGlowAtScroll(BuildContext context, Widget child, ScrollDirection scrollDirection) {
    return child;
  }
}
