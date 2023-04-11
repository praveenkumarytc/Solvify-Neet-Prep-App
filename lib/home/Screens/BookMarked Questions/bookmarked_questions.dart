import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/chapters_screen.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/mcq_model.dart';
import 'package:shield_neet/providers/user_provider.dart';

class BookMarkedQuestScreen extends StatefulWidget {
  const BookMarkedQuestScreen({super.key});

  @override
  State<BookMarkedQuestScreen> createState() => _BookMarkedQuestScreenState();
}

class _BookMarkedQuestScreenState extends State<BookMarkedQuestScreen> {
  List<McqModel> mcqList = [];
  Future<dynamic> getBookMarkedData() async {
    Provider.of<UserProvider>(context, listen: false).fetchBookmarkedQuestions();
  }

  @override
  void initState() {
    super.initState();
    getBookMarkedData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, details, child) {
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
                details.bookmarkedQuestions.length,
                (index) => ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(details.bookmarkedQuestions[index].question),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: details.bookmarkedQuestions[index].options
                                .map((option) => ListTile(
                                      dense: true,
                                      visualDensity: VisualDensity.adaptivePlatformDensity,
                                      title: Text(option.optionDetail),
                                      leading: option.isCorrect
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : const Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                            ),
                                    ))
                                .toList(),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Ok'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  dense: true,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  leading: Text(
                    '${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  title: Text(
                    details.bookmarkedQuestions[index].question,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
