import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/pdf_api.dart';
import 'package:shield_neet/helper/push_to.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({Key? key, this.file, required this.title, this.url}) : super(key: key);
  final File? file;
  final String? title;
  final String? url;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  PdfViewerController? controller;
  int pages = 0;
  int indexPage = 0;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String myUrl = 'https://drive.google.com/file/d/1s7ohA1irGQsN8QqqXAf_5shZ17zZIKPD/view?usp=sharing';
    // ignore: unused_local_variable
    String gitaUrl = 'https://drive.google.com/file/d/1LL29RTC6kPIc8iK5PCRpx92DUJAA0zdP/view?usp=sharing';
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: SolvifyAppbar(title: widget.title ?? ''),
      ),
      body: SfPdfViewer.network(
        PDFApi.modifieURL(widget.url),
        interactionMode: PdfInteractionMode.selection,
        controller: controller,
        enableTextSelection: false,
        onDocumentLoaded: (details) => Fluttertoast.showToast(msg: 'pdf loded sueccessfully', backgroundColor: Colors.white, textColor: Colors.black),
        onDocumentLoadFailed: (details) {
          Fluttertoast.showToast(msg: details.description, backgroundColor: Colors.red);
          popPage(context);
          debugPrint(details.description);
          debugPrint(details.error);
        },
      ),
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
    );
  }
}
