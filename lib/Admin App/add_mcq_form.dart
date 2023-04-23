// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Admin%20App/add_mcq_screen.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/components/placeholder_container.dart';
import 'package:shield_neet/components/question_form_field.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/components/submit_button.dart';
import 'package:shield_neet/helper/app_helper.dart';
import 'package:shield_neet/helper/app_text_style.dart';
import 'package:shield_neet/helper/base64_image_checker.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/helper/ocr_screen.dart';
import 'package:shield_neet/providers/admin_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddMcqPage extends StatefulWidget {
  const AddMcqPage({super.key, required this.chapterName, required this.chapterId, required this.subjectname, this.isUpdate = false, this.question, this.explanation, this.options, this.mcqId});
  final bool isUpdate;
  final String chapterName;
  final String subjectname;
  final String chapterId;
  final String? question;
  final String? explanation;
  final List<OptionModel>? options;
  final dynamic mcqId;

  @override
  State<AddMcqPage> createState() => _AddMcqPageState();
}

class _AddMcqPageState extends State<AddMcqPage> {
  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();
  TextEditingController explainationController = TextEditingController();
  TextEditingController ocrTextCOntroller = TextEditingController();
  bool isExplainationChoosed = true;
  final _picker = ImagePicker();
  File? fileImage;
  String? base64;
  bool isoption1Correct = false, isoption2Correct = false, isoption3Correct = false, isoption4Correct = false;
  bool isQuestionImage = false;
  _getImageFrom({required ImageSource source}) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      var image = File(pickedImage.path.toString());
      final sizeInKbBefore = image.lengthSync() / 1024;
      print('Before Compress $sizeInKbBefore kb');
      var croppedImage = await AppHelper.cropImage(image);
      if (croppedImage == null) {
        return;
      }
      final sizeInKbBeforeCompression = croppedImage.lengthSync() / 1024;
      print('Before Compressing the cropped image $sizeInKbBeforeCompression kb');
      var compressedImage = await AppHelper.compress(image: croppedImage);
      final sizeInKbAfterCompression = compressedImage.lengthSync() / 1024;
      print('After Compress $sizeInKbAfterCompression kb');

      // Encode the compressed image as base64
      final bytes = compressedImage.readAsBytesSync();
      final encoded = base64Encode(bytes);

      setState(() {
        fileImage = compressedImage;
        // Read the image file as bytes

        base64 = encoded;

        log(base64!);

        // Store the bytes in Firestore
      });
    }
  }

  _autoFillData() {
    if (widget.isUpdate) {
      option1Controller.text = widget.options![0].option_detail;
      option2Controller.text = widget.options![1].option_detail;
      option3Controller.text = widget.options![2].option_detail;
      option4Controller.text = widget.options![3].option_detail;
      isoption1Correct = widget.options![0].is_correct;
      isoption2Correct = widget.options![1].is_correct;
      isoption3Correct = widget.options![2].is_correct;
      isoption4Correct = widget.options![3].is_correct;
      print(widget.explanation);

      if (widget.question!.startsWith('http')) {
        isQuestionImage = true;
      } else {
        questionController.text = widget.question!;
      }
      // if (isBase64Image(widget.explanation!)) {
      //   isExplainationChoosed = false;

      //   base64 = widget.explanation;
      // } else {
      //   isExplainationChoosed = true;
      explainationController.text = widget.explanation!;
      // }
    }
  }

  void extractQuestionAndOptions(String ocrText) {
    log(ocrText);
    final lines = ocrText.split('\n').map((line) => line.trim()).toList();

    // Find the index of the first option
    int optionIndex = -1;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith('(1)') || line.startsWith('A)') || line.startsWith('a)') || line.startsWith('i)')) {
        optionIndex = i;
        break;
      }
    }

    if (optionIndex == -1) {
      // No options found
      return;
    }

    // The question text is the lines before the first option
    final questionLines = lines.sublist(0, optionIndex);
    final questionText = questionLines.join(' ');

    // The options are the lines after the question text
    final optionLines = lines.sublist(optionIndex);
    final options = optionLines.map((line) => line.substring(2)).toList();

    // Assign the extracted question and options to the relevant text controllers
    questionController.text = questionText;
    option1Controller.text = options[0];
    option2Controller.text = options[1];
    option3Controller.text = options[2];
    option4Controller.text = options[3];
    print(questionController.text);
    print(option1Controller.text);
    print(option2Controller.text);
    print(option3Controller.text);
    print(option4Controller.text);
  }

  String? extractQuestion(String text) {
    // Define the regular expression to match the question
    final questionRegex = RegExp(r'^\s*([^\?]+)\?');

    // Use the regular expression to extract the question
    final lines = text.split('\n');
    for (final line in lines) {
      final questionMatch = questionRegex.firstMatch(line);
      if (questionMatch != null) {
        return questionMatch.group(1)?.trim();
      }
    }
    return null;
  }

  @override
  void initState() {
    _autoFillData();
    super.initState();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isUpdate ? 'Update Question' : 'Add a Question',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      isQuestionImage
                          ? const SizedBox.shrink()
                          : IconButton(
                              onPressed: () async {
                                ocrTextCOntroller.clear();
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OcrScreen(),
                                    )).then((ocrText) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      ocrTextCOntroller.text = ocrText; // Initialize ocrText with an empty string
                                      return AlertDialog(
                                        title: const Text('OCR Text'),
                                        content: QuestionTextField(
                                          controller: ocrTextCOntroller,
                                          hintLabelText: 'Ocr text',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // Close the dialog box
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              extractQuestionAndOptions(ocrTextCOntroller.text);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              },
                              icon: Image.asset(Images.ocrImage))
                    ],
                  ),
                  20.heightBox,
                  // Text(isBase64Image(widget.explanation!).toString()),

                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isQuestionImage = false;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !isQuestionImage ? ColorResources.primaryBlue(context) : Colors.grey.shade300,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Text',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isQuestionImage = true;
                                questionController.clear();
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isQuestionImage ? ColorResources.primaryBlue(context) : Colors.grey.shade300,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Image',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  15.heightBox,
                  isQuestionImage
                      ? GestureDetector(
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
                        )
                      : QuestionTextField(
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
                  /*    SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isExplainationChoosed = true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isExplainationChoosed ? ColorResources.primaryBlue(context) : Colors.grey.shade300,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Explanation',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isExplainationChoosed = false;
                                explainationController.clear();
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !isExplainationChoosed ? ColorResources.primaryBlue(context) : Colors.grey.shade300,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Image',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),*/

                  15.heightBox,
                  // isExplainationChoosed
                  //     ?
                  QuestionTextField(
                    controller: explainationController,
                    hintLabelText: 'Explaination',
                    maxLines: 6,
                  ),
                  10.heightBox,
                  /*             : GestureDetector(
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
                    ),*/
                  30.heightBox,
                  SubmitButton(
                    onTap: () async {
                      List<Map<String, dynamic>> options = [
                        {
                          "is_correct": isoption1Correct,
                          "opt_no": 1,
                          "option_detail": option1Controller.text.trim()
                        },
                        {
                          "is_correct": isoption2Correct,
                          "opt_no": 2,
                          "option_detail": option2Controller.text.trim()
                        },
                        {
                          "is_correct": isoption3Correct,
                          "opt_no": 3,
                          "option_detail": option3Controller.text.trim()
                        },
                        {
                          "is_correct": isoption4Correct,
                          "opt_no": 4,
                          "option_detail": option4Controller.text.trim()
                        }
                      ];
                      print(options);

                      if (option1Controller.text.isEmpty) {
                        showSnackBar(context, message: 'option 1 can not be empty');
                      } else if (option2Controller.text.isEmpty) {
                        showSnackBar(context, message: 'option 2 can not be empty');
                      } else if (option3Controller.text.isEmpty) {
                        showSnackBar(context, message: 'option 3 can not be empty');
                      } else if (option4Controller.text.isEmpty) {
                        showSnackBar(context, message: 'option 4 can not be empty');
                      } else if (!isoption1Correct && !isoption2Correct && !isoption3Correct && !isoption4Correct) {
                        showSnackBar(context, message: 'at least one option must be checked be RIGHT');
                      } else if (questionController.text.isEmpty && base64 == null) {
                        if (isQuestionImage) {
                          showSnackBar(context, message: 'select question image');
                        } else {
                          showSnackBar(context, message: 'question can not be empty');
                        }
                      } else {
                        // if (isExplainationChoosed) {
                        //   base64 = explainationController.text;
                        // }

                        if (isQuestionImage) {
                          final response = await Provider.of<AdminProvider>(context, listen: false).uploadQuestionImage(context, base64!);
                          if (response!.status == 'success') {
                            // ignore: constant_identifier_names
                            const String QUESTION_IMAGE_BASE_URL = 'http://ivf.ekaltech.com/images/product/';
                            questionController.text = QUESTION_IMAGE_BASE_URL + response.productImage;
                          } else {
                            showToast(message: 'AN_ERROR_OCCURED_WHILE_UPLOADING_IMAGE', isError: true);
                          }
                        }
                        try {
                          if (widget.isUpdate) {
                            await Provider.of<AdminProvider>(context, listen: false).updateAddMcq(widget.mcqId, widget.subjectname, widget.chapterId, questionController.text.trim(), options, explainationController.text).then((value) {
                              showSnackBar(context, message: 'mcq updated successfully', isError: false);

                              Navigator.pop(context);
                            });
                          } else {
                            await Provider.of<AdminProvider>(context, listen: false).addMcq(widget.subjectname, widget.chapterId, questionController.text.trim(), options, explainationController.text).then((value) {
                              showSnackBar(context, message: 'mcq added successfully', isError: false);
                              Navigator.pop(context);
                            });
                          }
                        } catch (e) {
                          showSnackBar(context, message: e.toString());
                        }
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

  // ignore: unused_element
  _openChangeImageBottomSheet() {
    return showCupertinoModalPopup(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SafeArea(
            child: CupertinoActionSheet(
              cancelButton: 5.heightBox,
              title: Text(
                'Select Image',
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
