import 'package:flutter/material.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/chapters_screen.dart';

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
        child: SingleChildScrollView(
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
                    )),
          ),
        ),
      ),
    );
  }
}
