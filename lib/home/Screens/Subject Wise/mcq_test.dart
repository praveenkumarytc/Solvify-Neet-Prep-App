import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shield_neet/Admin%20App/add_mcq_screen.dart';
import 'package:shield_neet/Utils/app_constants.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/mcq_model.dart';
import 'package:velocity_x/velocity_x.dart';

class McqTestScreen extends StatefulWidget {
  const McqTestScreen({super.key, required this.chapterId, required this.subjectName});
  final String chapterId;
  final String subjectName;
  @override
  State<McqTestScreen> createState() => _McqTestScreenState();
}

class _McqTestScreenState extends State<McqTestScreen> {
  String question = 'What is the captital of of India an Us and also tell the captoital of autraliys';
  String? selectedOption;
  dynamic data;
  List<McqModel> mcqList = [];

  Future<dynamic> getData() async {
    final QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance.collection(FirestoreCollections.subjects).doc(widget.subjectName).collection(FirestoreCollections.chapters).doc(widget.chapterId).collection(FirestoreCollections.mcq).get();

    setState(() {
      mcqList.clear(); // clear the list before adding new data
      for (var i = 0; i < snapshot.docs.length; i++) {
        var data = snapshot.docs[i].data() as Map<String, dynamic>?;
        if (data != null) {
          mcqList.add(McqModel.fromJson(data));
        }
      }
    });
  }

  final PageController controller = PageController(initialPage: 0);
  int currentPage = 0;

  void nextPage() {
    if (currentPage < mcqList.length - 1) {
      setState(() {
        currentPage++;
      });
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
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
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
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
            TextButton(
              onPressed: nextPage,
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Skip'),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: currentPage < mcqList.length - 1 ? ColorResources.PRIMARY_MATERIAL : Colors.grey,
              ),
              onPressed: nextPage,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
            ),
            TopBgContainer(
              onBookMarkTap: () {},
            ),
            Positioned(
              top: 110,
              left: MediaQuery.of(context).size.width * 0.05,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height - 150,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    )),
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
                  itemBuilder: (context, index) => Column(
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
                            Text(
                              question,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            (question.length < 120 ? 80 : 20).heightBox,
                            ...List.generate(
                              mcqList[index].options.length,
                              (i) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    setState(() {
                                      selectedOption = mcqList[index].options[i].optionDetail;
                                    });
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 15),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 3, color: Colors.blueGrey.shade100),
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
                                      SizedBox(
                                        height: 30,
                                        child: Radio(
                                          value: mcqList[index].options[i].optionDetail,
                                          groupValue: selectedOption,
                                          onChanged: (value) {
                                            setState(() {
                                              setState(() {
                                                selectedOption = mcqList[index].options[i].optionDetail;
                                              });
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TopBgContainer extends StatelessWidget {
  const TopBgContainer({super.key, required this.onBookMarkTap});
  final Function() onBookMarkTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorResources.RECHARGE_blue,
        borderRadius: BorderRadius.only(
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
              icon: const Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
