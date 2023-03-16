import 'package:flutter/material.dart';
import 'package:shield_neet/Admin%20App/add_chapters.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/push_to.dart';

class AdminPage extends StatelessWidget {
  AdminPage({super.key});

  final _subjectNames = [
    'Physics',
    'Chemistry',
    'Biology',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue[50],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SolvifyAppbar(title: 'Hey, Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[200]!,
                Colors.blue[400]!
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Choose a subject to manage:',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _subjectNames.length,
                  itemBuilder: (context, index) {
                    final subject = _subjectNames[index];
                    IconData iconData = Icons.abc;
                    switch (index) {
                      case 0:
                        iconData = Icons.track_changes;
                        break;
                      case 1:
                        iconData = Icons.science_outlined;
                        break;
                      case 2:
                        iconData = Icons.biotech_outlined;
                        break;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(
                            iconData,
                            color: Colors.blue[400],
                          ),
                          title: Text(
                            subject,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          onTap: () => pushTo(
                            context,
                            AddChapterScreen(
                              subjectName: _subjectNames[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
