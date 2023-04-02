// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/placeholder_container.dart';
import 'package:shield_neet/components/question_form_field.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/components/submit_button.dart';
import 'package:shield_neet/helper/app_helper.dart';
import 'package:shield_neet/helper/app_text_style.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/providers/admin_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddMcqPage extends StatefulWidget {
  const AddMcqPage({super.key, required this.chapterName, required this.chapterId, required this.subjectname});
  final String chapterName;
  final String subjectname;
  final String chapterId;
  @override
  State<AddMcqPage> createState() => _AddMcqPageState();
}

class _AddMcqPageState extends State<AddMcqPage> {
  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();
  final _picker = ImagePicker();
  File? fileImage;
  String? base64;
  bool isoption1Correct = false, isoption2Correct = false, isoption3Correct = false, isoption4Correct = false;
  _getImageFrom({required ImageSource source}) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      var image = File(pickedImage.path.toString());
      final sizeInKbBefore = image.lengthSync() / 1024;
      print('Before Compress $sizeInKbBefore kb');
      var compressedImage = await AppHelper.compress(image: image);
      final sizeInKbAfter = compressedImage.lengthSync() / 1024;
      print('After Compress $sizeInKbAfter kb');
      var croppedImage = await AppHelper.cropImage(compressedImage);
      if (croppedImage == null) {
        return;
      }
      setState(() {
        fileImage = croppedImage;
        base64 = base64Encode(fileImage!.readAsBytesSync());
        print(base64);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SolvifyAppbar(title: widget.chapterName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add a Question',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  20.heightBox,
                  QuestionTextField(
                    controller: questionController,
                    hintLabelText: 'Question',
                  ),
                  20.heightBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Option 1',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Checkbox(
                            activeColor: ColorResources.PRIMARY_MATERIAL,
                            value: isoption1Correct,
                            onChanged: (value) {
                              setState(() {
                                isoption1Correct = value!;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      QuestionTextField(
                        controller: option1Controller,
                        hintLabelText: '',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Option 2',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Checkbox(
                            activeColor: ColorResources.PRIMARY_MATERIAL,
                            value: isoption2Correct,
                            onChanged: (value) {
                              setState(() {
                                isoption2Correct = value!;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      QuestionTextField(
                        controller: option2Controller,
                        hintLabelText: '',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Option 3',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Checkbox(
                            activeColor: ColorResources.PRIMARY_MATERIAL,
                            value: isoption3Correct,
                            onChanged: (value) {
                              setState(() {
                                isoption3Correct = value!;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      QuestionTextField(
                        controller: option3Controller,
                        hintLabelText: '',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Option 4',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Checkbox(
                            activeColor: ColorResources.PRIMARY_MATERIAL,
                            value: isoption4Correct,
                            onChanged: (value) {
                              setState(() {
                                isoption4Correct = value!;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      QuestionTextField(
                        controller: option4Controller,
                        hintLabelText: '',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _openChangeImageBottomSheet();
                      // Handle tapping the container to select an image from the gallery
                    },
                    child: fileImage != null
                        ? Container(
                            height: 350,
                            width: 300,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12, width: 1),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: FileImage(fileImage!),
                                  fit: BoxFit.cover,
                                )),
                          )
                        : const PlaceholderContainer(),
                  ),
                  30.heightBox,
                  SubmitButton(
                    onTap: () async {
                      List<Map<String, dynamic>> _options = [
                        {
                          "is_correct": isoption1Correct,
                          "opt_no": 1,
                          "option_detail": option1Controller.text.trim()
                        },
                        {
                          "is_correct": true,
                          "opt_no": 2,
                          "option_detail": option2Controller.text.trim()
                        },
                        {
                          "is_correct": true,
                          "opt_no": 3,
                          "option_detail": option3Controller.text.trim()
                        },
                        {
                          "is_correct": true,
                          "opt_no": 4,
                          "option_detail": option4Controller.text.trim()
                        }
                      ];
                      try {
                        print(_options);
                        await Provider.of<AdminProvider>(context, listen: false).addMcq(widget.subjectname, widget.chapterId, questionController.text.trim(), _options, base64).then((value) {
                          showToast(message: 'mcq added successfully');
                          Navigator.pop(context);
                        });
                      } catch (e) {
                        showToast(message: e.toString(), isError: true);
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openChangeImageBottomSheet() {
    return showCupertinoModalPopup(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SafeArea(
            child: CupertinoActionSheet(
              title: Text(
                'Change Image',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(fontSize: 19),
              ),
              actions: <Widget>[
                _buildCupertinoActionSheetAction(
                  icon: Icons.camera_alt,
                  title: 'Take Photo',
                  voidCallback: () {
                    Navigator.pop(context);
                    _getImageFrom(source: ImageSource.camera);
                  },
                ),
                _buildCupertinoActionSheetAction(
                  icon: Icons.image,
                  title: 'Gallery',
                  voidCallback: () {
                    Navigator.pop(context);
                    _getImageFrom(source: ImageSource.gallery);
                  },
                ),
                _buildCupertinoActionSheetAction(
                  title: 'Cancel',
                  color: Colors.red,
                  voidCallback: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  _buildCupertinoActionSheetAction({
    IconData? icon,
    required String title,
    required VoidCallback voidCallback,
    Color? color,
  }) {
    return CupertinoActionSheetAction(
      onPressed: voidCallback,
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: color ?? const Color(0xFF2564AF),
            ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular(
                fontSize: 17,
                color: color ?? const Color(0xFF2564AF),
              ),
            ),
          ),
          if (icon != null)
            const SizedBox(
              width: 25,
            ),
        ],
      ),
    );
  }
}
