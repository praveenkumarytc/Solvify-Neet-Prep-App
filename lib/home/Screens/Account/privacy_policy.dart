import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shield_neet/components/solvify_appbar.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  String text = '';
  Future<void> loadTextFile() async {
    String fileText = await rootBundle.loadString('assets/privacy_policy.txt');
    setState(() {
      text = fileText;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTextFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SolvifyAppbar(title: 'Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text)
            ],
          ),
        ),
      ),
    );
  }
}
