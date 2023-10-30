import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shield_neet/helper/pdf_api.dart';
import 'package:shield_neet/home/Screens/Subject%20Wise/test_loading.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../components/solvify_appbar.dart';
import '../helper/push_to.dart';

class PdfViewerPageMCQ extends StatefulWidget {
  const PdfViewerPageMCQ({
    Key? key,
    this.file,
    required this.title,
    this.url,
    required this.chapterId,
    required this.chapterName,
    required this.subjectname,
    this.fromNCERT = false,
    required this.topicId,
    this.unitId,
  }) : super(key: key);
  final File? file;
  final String? title;
  final String? url;
  final String chapterId;
  final String chapterName;
  final String subjectname;
  final String topicId;
  final String? unitId;
  final bool fromNCERT;
  @override
  State<PdfViewerPageMCQ> createState() => _PdfViewerPageMCQState();
}

class _PdfViewerPageMCQState extends State<PdfViewerPageMCQ> {
  PdfViewerController? controller;
  int pages = 0;
  int indexPage = 0;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingScreen(
              subjectName: widget.subjectname,
              chapterId: widget.chapterId,
              topicId: widget.topicId,
              fromNCERT: widget.fromNCERT,
              unitId: widget.unitId,
            ),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String myUrl = 'https://drive.google.com/file/d/1s7ohA1irGQsN8QqqXAf_5shZ17zZIKPD/view?usp=sharing';
    // ignore: unused_local_variable
    String gitaUrl = 'https://drive.google.com/file/d/1LL29RTC6kPIc8iK5PCRpx92DUJAA0zdP/view?usp=sharing';
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 65),
        child: SolvifyAppbar(title: widget.title ?? ''),
      ),

      body: SfPdfViewer.network(
        PDFApi.modifieURL(widget.url),
        interactionMode: PdfInteractionMode.selection,
        controller: controller,
        enableTextSelection: true,
        // onDocumentLoaded: (details) => Fluttertoast.showToast(msg: 'pdf loded sueccessfully', backgroundColor: Colors.white, textColor: Colors.black),
        // onDocumentLoadFailed: (details) {
        //   Fluttertoast.showToast(msg: details.description, backgroundColor: Colors.red);
        //   popPage(context);
        //   debugPrint(details.description);
        //   debugPrint(details.error);
        // },
      ),
      // body: SingleChildScrollView(
      //   padding: const EdgeInsets.all(15),
      //   child: Column(
      //     children: [
      //       Text(
      //         utf8.decode(base64Decode(widget.url!)),
      //         textAlign: TextAlign.left,
      //         textDirection: TextDirection.rtl,
      //         style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
      //       )
      //     ],
      //   ),
      // ),

      /*   
       to load pdf from file
      body: PDFView(
        filePath: widget.file.path,
        autoSpacing: false,
        pageSnap: true,
        pageFling: true,
        onRender: (pages) => setState(() => this.pages = pages),
        onViewCreated: (controller) => setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) => setState(() => this.indexPage = indexPage),
      ),*/

      bottomNavigationBar: Container(
        height: 75,
        child: ElevatedButton(
          onPressed: () {
            pushTo(
                context,
                LoadingScreen(
                  subjectName: widget.subjectname,
                  chapterId: widget.chapterId,
                  topicId: widget.topicId,
                  fromNCERT: widget.fromNCERT,
                  unitId: widget.unitId,
                ));
          },
          child: const Text(
            'Start Test',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
