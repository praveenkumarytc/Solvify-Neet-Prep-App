// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/custom%20%20widget/zoomable_image.dart';
import 'package:shield_neet/helper/check_text_is_url.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:shield_neet/helper/show_toast.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/chapters_screen.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/mcq_model.dart';
import 'package:shield_neet/home/Screens/result/result_screen.dart';
import 'package:shield_neet/providers/user_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vibration/vibration.dart';

// import 'package:audioplayers/audioplayers.dart';
class McqTestScreen extends StatefulWidget {
  const McqTestScreen({
    super.key,
    required this.chapterId,
    required this.subjectName,
    required this.topicId,
    this.fromNCERT = false,
    this.unitId,
  });
  final String chapterId;
  final String subjectName;
  final String topicId;
  final String? unitId;
  final bool fromNCERT;
  @override
  State<McqTestScreen> createState() => _McqTestScreenState();
}

class _McqTestScreenState extends State<McqTestScreen> {
  String? selectedOption;
  dynamic data;
  List<McqModel> mcqList = [];
  List<String> performanceData = [];
  String mcqIs = 'skipped';
  PerformanceModel myPerformace = PerformanceModel(question: 'initialized', isCorrect: 'skipped', explaination: 'initialized');
  List<PerformanceModel> perFormanceModelList = [];

  bool _isMcqLoading = false;
  Future<dynamic> getData() async {
    _isMcqLoading = true;

    if (widget.fromNCERT) {
      debugPrint('from ncert page came');
      final QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance.collection(FirestoreCollections.subjectNCERT).doc(widget.subjectName).collection(FirestoreCollections.units).doc(widget.unitId).collection(FirestoreCollections.chapters).doc(widget.chapterId).collection(FirestoreCollections.chapterTopic).doc(widget.topicId).collection(FirestoreCollections.mcq).get();

      setState(() {
        performanceData.clear();
        perFormanceModelList.clear();
        mcqList.clear(); // clear the list before adding new data
        for (var i = 0; i < snapshot.docs.length; i++) {
          var data = snapshot.docs[i].data() as Map<String, dynamic>?;
          if (data != null) {
            mcqList.add(McqModel.fromJson(data));
          }
        }
      });
    } else {
      final QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(widget.subjectName).collection(FirestoreCollections.chapters).doc(widget.chapterId).collection(FirestoreCollections.chapterTopic).doc(widget.topicId).collection(FirestoreCollections.mcq).get();

      setState(() {
        performanceData.clear();
        perFormanceModelList.clear();
        mcqList.clear(); // clear the list before adding new data
        for (var i = 0; i < snapshot.docs.length; i++) {
          var data = snapshot.docs[i].data() as Map<String, dynamic>?;
          if (data != null) {
            mcqList.add(McqModel.fromJson(data));
          }
        }
      });
    }

    _isMcqLoading = false;
  }

  final PageController controller = PageController(initialPage: 0);
  int currentPage = 0;
  bool isAttempt = false;
  bool solutionVisible = false;

  void nextPage() {
    if (currentPage < mcqList.length - 1) {
      currentPage++;
      performanceData.add(mcqIs);
      solutionVisible = false;
      isAttempt = false;
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void skipPage() {
    if (currentPage < mcqList.length - 1) {
      currentPage++;
      solutionVisible = false;
      isAttempt = false;
      performanceData.add(mcqIs);
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      solutionVisible = false;
      isAttempt = false;
      performanceData.removeLast();
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, details, child) {
      return Scaffold(
        appBar: mcqList.isEmpty
            ? AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: const Text('COMING SOON'),
              )
            : null,
        backgroundColor: ColorResources.getWhite(context),
        bottomNavigationBar: mcqList.isEmpty
            ? SizedBox(
                height: 65,
                child: OutlinedButton.icon(
                  onPressed: () => popPage(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                ),
              )
            : Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: currentPage > 0 ? ColorResources.PRIMARY_MATERIAL : Colors.grey,
                      ),
                      onPressed: previousPage,
                    ),
                    currentPage < mcqList.length - 1
                        ? TextButton(
                            onPressed: nextPage,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Skip'),
                          )
                        : const SizedBox.shrink(),
                    currentPage < mcqList.length - 1
                        ? IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: currentPage < mcqList.length - 1 ? ColorResources.PRIMARY_MATERIAL : Colors.grey,
                            ),
                            onPressed: nextPage,
                          )
                        : ElevatedButton(
                            onPressed: () {
                              //to add option response
                              performanceData.add(mcqIs);
                              perFormanceModelList.add(myPerformace);
                              // log(myPerformace.toJson().toString());
                              solutionVisible = false;
                              isAttempt = false;

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultScreen(
                                      performanceData: performanceData,
                                      myPerformaceData: perFormanceModelList,
                                    ),
                                  ),
                                  (route) => false);
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontWeight: FontWeight.bold, color: ColorResources.WHITE),
                            ),
                          ),
                  ],
                ),
              ),
        body: _isMcqLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: ColorResources.PRIMARY_MATERIAL,
                backgroundColor: Colors.white,
              ))
            : mcqList.isEmpty
                ? const Center(
                    child: SizedBox(
                    child: Text('Questions are not availbale for this topic'),
                  ))
                : SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                        ),
                        TopBgContainer(
                          icon: details.isBookmarked(mcqList[currentPage].question) ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                          onBookMarkTap: () async {
                            if (details.isBookmarked(mcqList[currentPage].question)) {
                              details.removeBookMark(mcqList[currentPage].question);

                              // print('removed ${details.bookmarkedQuestions[0].question}');
                            } else {
                              Provider.of<UserProvider>(context, listen: false).addBookMark(mcqList[currentPage]);
                            }
                          },
                        ),
                        Positioned(
                          top: 110,
                          left: MediaQuery.of(context).size.width * 0.05,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height - 150,
                            decoration: BoxDecoration(
                              color: ColorResources.getWhite(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: PageView.builder(
                              controller: controller,
                              onPageChanged: (value) {
                                (int index) {
                                  setState(() {
                                    currentPage = index;
                                  });
                                };
                              },
                              itemCount: mcqList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => ScrollConfiguration(
                                behavior: NoGlowScroll(),
                                child: ListView(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Text(
                                              'Question ${index + 1}/${mcqList.length}',
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ColorResources.PRIMARY_MATERIAL),
                                            ),
                                          ),
                                          10.heightBox,
                                          checkForImage(mcqList[index].question)
                                              ? GestureDetector(
                                                  onTap: () => pushTo(context, ZoomableImage(image: NetworkImage(mcqList[index].question))),
                                                  child: Container(
                                                    height: 150,
                                                    padding: const EdgeInsets.all(8),
                                                    child: Image(
                                                      image: NetworkImage(mcqList[index].question),
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                        if (loadingProgress == null) {
                                                          // Image is fully loaded, return GestureDetector
                                                          return GestureDetector(
                                                            onTap: () => pushTo(context, ZoomableImage(image: NetworkImage(mcqList[index].question))),
                                                            child: child,
                                                          );
                                                        } else {
                                                          // Image is still loading, return placeholder
                                                          return const ImageError(error: 'Image not available');
                                                        }
                                                      },
                                                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                        // Handle image loading error
                                                        return const ImageError(error: 'Error loading image');
                                                      },
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  mcqList[index].question,
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                ),
                                          (mcqList[index].question.length < 120 ? 80 : 20).heightBox,
                                          ...List.generate(
                                            mcqList[index].options.length,
                                            (i) => Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      mcqIs = mcqList[index].options[i].isCorrect.toString();

                                                      if (!isAttempt) {
                                                        if (mcqIs == "false") {
                                                          Vibration.vibrate(duration: 100);
                                                        } else {
                                                          showErrorSnackBar(context, 'Correct', isError: false);
                                                        }
                                                      }
                                                      isAttempt = true;

                                                      print(mcqIs);

                                                      selectedOption = mcqList[index].options[i].optionDetail;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin: const EdgeInsets.only(top: 15),
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: isAttempt
                                                              ? mcqList[index].options[i].isCorrect
                                                                  ? Colors.green
                                                                  : Colors.red
                                                              : Colors.grey.shade100),
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          flex: 3,
                                                          child: Text(
                                                            mcqList[index].options[i].optionDetail,
                                                            style: const TextStyle(fontWeight: FontWeight.w400),
                                                          ),
                                                        ),
                                                        // Text(mcqList[index].options[i].isCorrect.toString()),
                                                        SizedBox(
                                                          height: 30,
                                                          child: Radio(
                                                            activeColor: ColorResources.COLOR_BLUE,
                                                            value: mcqList[index].options[i].optionDetail,
                                                            groupValue: selectedOption,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                isAttempt = true;
                                                                mcqIs = mcqList[index].options[i].isCorrect.toString();
                                                                print(mcqIs);
                                                                selectedOption = mcqList[index].options[i].optionDetail;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          20.heightBox,
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   children: const [
                                          //     Text(
                                          //       'Explanation:',
                                          //       style: TextStyle(color: Color.fromARGB(255, 0, 136, 247), fontSize: 16, fontWeight: FontWeight.w500),
                                          //     ),
                                          //   ],
                                          // ),
                                          Visibility(
                                            visible: isAttempt,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  solutionVisible = !solutionVisible;
                                                });
                                              },
                                              child: Chip(
                                                label: Text(solutionVisible ? 'Hide Solution' : 'View Solution'),
                                                backgroundColor: solutionVisible ? Colors.blue : Colors.grey.shade100,
                                                avatar: Icon(
                                                  solutionVisible ? Icons.visibility : Icons.visibility_off,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),

                                          Visibility(
                                            visible: solutionVisible,
                                            child: checkForImage(mcqList[index].solutionImage)
                                                ? GestureDetector(
                                                    onTap: () => pushTo(context, ZoomableImage(image: NetworkImage(mcqList[index].solutionImage))),
                                                    child: Container(
                                                      height: 150,
                                                      padding: const EdgeInsets.all(8),
                                                      child: Image(
                                                        image: NetworkImage(mcqList[index].solutionImage),
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                          if (loadingProgress == null) {
                                                            // Image is fully loaded, return GestureDetector
                                                            return GestureDetector(
                                                              onTap: () => pushTo(context, ZoomableImage(image: NetworkImage(mcqList[index].solutionImage))),
                                                              child: child,
                                                            );
                                                          } else {
                                                            // Image is still loading, return placeholder
                                                            return const ImageError(error: 'Image not available');
                                                          }
                                                        },
                                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                          // Handle image loading error
                                                          return const ImageError(error: 'Error loading image');
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : Text(
                                                    mcqList[index].solutionImage,
                                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                                    textAlign: TextAlign.start,
                                                  ),
                                          )
                                        ],
                                      ),
                                    ),
                                    30.heightBox
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
      );
    });
  }
}

class ImageError extends StatelessWidget {
  const ImageError({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: Text(
          error,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class TopBgContainer extends StatelessWidget {
  const TopBgContainer({super.key, required this.onBookMarkTap, required this.icon});
  final Function() onBookMarkTap;

  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorResources.getBlue(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: onBookMarkTap,
              icon: Icon(
                icon,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PerformanceModel {
  String question;
  String isCorrect;
  String explaination;
  PerformanceModel({
    required this.question,
    required this.isCorrect,
    required this.explaination,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'isCorrect': isCorrect,
        'explaination': explaination,
      };

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    return PerformanceModel(
      question: json['question'],
      isCorrect: json['isCorrect'],
      explaination: json['explaination'],
    );
  }
}
