import 'package:flutter/material.dart';
import 'package:shield_neet/Admin%20App/Subjects-NCERT/add_unit_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/push_to.dart';

class NCERTSubjectPageAdmin extends StatelessWidget {
  NCERTSubjectPageAdmin({super.key, this.fromNotes = false});
  final _subjectNames = [
    FirestoreCollections.physics,
    FirestoreCollections.chemistry,
    FirestoreCollections.biology,
  ];

  final bool fromNotes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SolvifyAppbar(title: 'Hey, Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            const Text(
              'Choose a subject to manage:',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: ListView.builder(
                itemCount: _subjectNames.length,
                itemBuilder: (context, index) {
                  final subject = _subjectNames[index];
                  IconData iconData = Icons.calendar_month_outlined;
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () => pushTo(
                          context,
                          AddUnitAdminPage(
                            subjectName: _subjectNames[index],
                            fromNote: fromNotes,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                iconData,
                                color: ColorResources.PRIMARY_MATERIAL,
                                size: 40.0,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  subject,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}
