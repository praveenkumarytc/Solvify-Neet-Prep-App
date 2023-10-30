import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/check_text_is_url.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/chapters_screen.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/mcq_model.dart';
import 'package:shield_neet/providers/user_provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Subject Wise/mcq_test.dart';

class BookMarkedQuestScreen extends StatefulWidget {
  const BookMarkedQuestScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkedQuestScreen> createState() => _BookMarkedQuestScreenState();
}

class _BookMarkedQuestScreenState extends State<BookMarkedQuestScreen> {
  late List<McqModel> mcqList;

  @override
  void initState() {
    super.initState();
    mcqList = Provider.of<UserProvider>(context, listen: false).fetchBookmarkedQuestions();
  }

  Widget buildNoBookmarksWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 115),
        Center(
          child: Image.asset(
            Images.bookmark2,
            scale: 5,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Your bookmarked questions will appear here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Keep Learning',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildAlertDialog(BuildContext context, McqModel mcqModel) {
    return AlertDialog(
      title: checkForImage(mcqModel.question)
          ? SizedBox(
              height: 150,
              child: CachedNetworkImage(
                imageUrl: mcqModel.question,
                errorWidget: (context, url, error) => ImageError(error: error),
                placeholder: (context, url) => const SizedBox.shrink(),
                fit: BoxFit.fill,
              ),
            )
          : Text(mcqModel.question),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: mcqModel.options
            .map(
              (option) => ListTile(
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
              ),
            )
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, details, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorResources.primaryBlue(context),
          title: const Text("Bookmarked Questions"),
        ),
        body: ScrollConfiguration(
          behavior: NoGlowScroll(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: details.bookmarkedQuestions.isEmpty
                  ? [
                      buildNoBookmarksWidget()
                    ]
                  : List.generate(details.bookmarkedQuestions.length, (index) {
                      final color = index % 2 == 0 ? Colors.red : Colors.blue;
                      return BookmarkedListTile(
                        indexNumber: '${index + 1}.', // Pass the index number as a string
                        question: details.bookmarkedQuestions[index].question, // Pass the question string
                        isImage: details.bookmarkedQuestions[index].question.startsWith('http'), // Pass a boolean value indicating whether the question is an image
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return buildAlertDialog(context, details.bookmarkedQuestions[index]);
                            },
                          );
                        },
                        color: color,
                      );
                    }),
            ),
          ),
        ),
      );
    });
  }
}

class BookmarkedListTile extends StatelessWidget {
  final String indexNumber;
  final String question;
  final Function()? onTap;
  final bool isImage;
  final Color color;

  const BookmarkedListTile({Key? key, required this.indexNumber, required this.question, required this.onTap, required this.isImage, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 45,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
            5.widthBox,
            Expanded(
              child: ListTile(
                minLeadingWidth: 1,
                contentPadding: EdgeInsets.zero,
                title: isImage
                    ? SizedBox(
                        height: 150,
                        child: CachedNetworkImage(
                          imageUrl: question,
                          errorWidget: (context, url, error) => ImageError(error: error),
                          placeholder: (context, url) => const SizedBox.shrink(),
                          fit: BoxFit.fill,
                        ),
                      )
                    : Text(
                        question,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                // leading: Text(
                //   indexNumber,
                //   style: const TextStyle(fontWeight: FontWeight.w600),
                // ),
                trailing: const Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
