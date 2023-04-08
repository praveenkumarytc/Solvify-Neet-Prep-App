import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/chapters_screen.dart';
import 'package:shield_neet/providers/auth_providers.dart';

class BookMarkedQuestScreen extends StatelessWidget {
  const BookMarkedQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SolvifyAppbar(title: "Bookmarked Questions"),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScroll(),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(Provider.of<AuthProvider>(context, listen: false).uid).collection(FirestoreCollections.bookMarkedMcq).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error occured');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: List.generate(
                    15,
                    (index) => ListTile(
                      dense: true,
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      leading: Text(
                        '${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      title: const Text(
                        "What is the Molecular weight of Hydrogen PerOxide What is the Molecular weight of Hydrogen PerOxide",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      subtitle: const Text('Physics'),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
