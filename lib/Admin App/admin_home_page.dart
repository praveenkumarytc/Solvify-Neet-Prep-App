import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Admin%20App/Subjects-NCERT/ncert_subjects_screen.dart';
import 'package:shield_neet/Admin%20App/admin_page.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/providers/auth_providers.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SolvifyAppbar(title: 'Hey, ${userData.fullName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24.0),
            const Text(
              'Select a option to manage:',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            30.heightBox,
            AdminHomeCard(
              iconData: Icons.book,
              onTap: () => pushTo(context, AdminPage()),
              title: ' Previous Year Questions',
            ),
            AdminHomeCard(
              iconData: Icons.subject_outlined,
              onTap: () => pushTo(context, NCERTSubjectPageAdmin()),
              title: 'Subject WIse Questions [NCERT]',
            ),
            AdminHomeCard(
              iconData: Icons.note_add,
              onTap: () => pushTo(
                  context,
                  NCERTSubjectPageAdmin(
                    fromNotes: true,
                  )),
              title: 'Quick Revision Notes',
            )
          ],
        ),
      ),
    );
  }
}

class AdminHomeCard extends StatelessWidget {
  const AdminHomeCard({super.key, required this.iconData, required this.onTap, required this.title});
  final Function() onTap;
  final String title;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  iconData,
                  color: ColorResources.PRIMARY_MATERIAL,
                  size: 40.0,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
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
  }
}
