import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shield_neet/Utils/color_resources.dart';

class AddChapterDialog extends StatelessWidget {
  final TextEditingController chapterNameController;
  final TextEditingController chapterNumberController;
  final VoidCallback onTap;
  final bool isYear;
  final bool isTopicScreen;
  const AddChapterDialog({
    Key? key,
    required this.chapterNameController,
    required this.chapterNumberController,
    required this.onTap,
    required this.isYear,
    this.isTopicScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              !isTopicScreen
                  ? isYear
                      ? 'Add Year'
                      : 'Add Chapter'
                  : isYear
                      ? 'Add Subject'
                      : 'Add Topic',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
                controller: chapterNumberController,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: InputDecoration(
                    hintText: !isTopicScreen
                        ? isYear
                            ? 'S No.'
                            : 'Chapter No'
                        : isYear
                            ? 'Subject No'
                            : 'Topic No')),
            const SizedBox(height: 10),
            TextField(
              controller: chapterNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: !isTopicScreen
                    ? isYear
                        ? 'YYYY'
                        : 'Chapter Name'
                    : isYear
                        ? 'Subject Name'
                        : 'Topic Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.COLOR_BLUE,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onTap,
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: ColorResources.COLOR_BLUE,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
