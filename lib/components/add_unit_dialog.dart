import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:velocity_x/velocity_x.dart';

class AddUnitDialog extends StatelessWidget {
  final TextEditingController chapterNameController;
  final TextEditingController chapterNumberController;
  final TextEditingController imageController;
  final TextEditingController? pdfLinkController;
  final VoidCallback onTap;
  final bool isYear;
  final bool isTopicScreen;

  const AddUnitDialog({
    Key? key,
    required this.chapterNameController,
    required this.chapterNumberController,
    required this.onTap,
    required this.isYear,
    required this.imageController,
    this.pdfLinkController,
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isTopicScreen
                    ? 'Add Topic'
                    : isYear
                        ? 'Add Chapter'
                        : 'Add Unit',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              5.heightBox,
              const Text(
                '*All fields are mandatory',
                style: TextStyle(color: Colors.red),
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
                      hintText: isTopicScreen
                          ? 'Topic No'
                          : isYear
                              ? 'Chapter No'
                              : 'Unit No')),
              const SizedBox(height: 10),
              TextField(
                controller: chapterNameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintText: isTopicScreen
                        ? 'Topic Name'
                        : isYear
                            ? 'Chapter Name'
                            : 'Unit Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: imageController,
                decoration: InputDecoration(hintText: isTopicScreen ? 'pdf url (optional)' : 'image URL'),
              ),
              const SizedBox(height: 10),
              pdfLinkController != null
                  ? TextField(
                      controller: pdfLinkController,
                      decoration: const InputDecoration(hintText: 'pdf url'),
                    )
                  : const SizedBox.shrink(),
              isTopicScreen || pdfLinkController != null
                  ? const Text(
                      '*Please add only downlodable links for pdf',
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.PRIMARY_MATERIAL.withOpacity(.7),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onTap,
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

//add notes dialog
class AddNoteDialog extends StatelessWidget {
  final TextEditingController chapterNameController;
  final TextEditingController chapterNumberController;
  final TextEditingController imageController;
  final TextEditingController pdfLinkController;
  final VoidCallback onTap;
  final bool isYear;
  final bool isTopicScreen;

  const AddNoteDialog({
    Key? key,
    required this.chapterNameController,
    required this.chapterNumberController,
    required this.onTap,
    required this.isYear,
    required this.imageController,
    required this.pdfLinkController,
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
              isTopicScreen
                  ? 'Add Topic'
                  : isYear
                      ? 'Add Chapter'
                      : 'Add Unit',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            5.heightBox,
            const Text(
              '*All fields are mandatory',
              style: TextStyle(color: Colors.red),
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
                    hintText: isTopicScreen
                        ? 'Topic No'
                        : isYear
                            ? 'Chapter No'
                            : 'Unit No')),
            const SizedBox(height: 10),
            TextField(
              controller: chapterNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  hintText: isTopicScreen
                      ? 'Topic Name'
                      : isYear
                          ? 'Chapter Name'
                          : 'Unit Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: imageController,
              decoration: InputDecoration(hintText: isTopicScreen ? 'pdf url (optional)' : 'image URL'),
            ),
            TextField(
              controller: pdfLinkController,
              decoration: InputDecoration(hintText: isTopicScreen ? 'pdf url' : 'image URL'),
            ),
            isTopicScreen
                ? const Text(
                    '*Please add only downlodable links for pdf',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.PRIMARY_MATERIAL.withOpacity(.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onTap,
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
