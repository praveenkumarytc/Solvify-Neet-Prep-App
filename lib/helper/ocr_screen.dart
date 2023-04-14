// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shield_neet/components/solvify_appbar.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({
    super.key,
  });
  @override
  _OcrScreenState createState() => _OcrScreenState();
}

List<CameraDescription>? cameras;

class _OcrScreenState extends State<OcrScreen> with WidgetsBindingObserver {
  CameraController? controller;

  Future<void>? _initializeControllerFuture;
  String? imagePath;
  // bool _isLoading = false;
  // static const _base64SafeEncoder = Base64Codec.urlSafe();
  // Isolate? _isolate;
  final _textRecognizer = TextRecognizer();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.max);
    setState(() {
      _initializeControllerFuture = controller!.initialize();
    });
    return;
  }

  Future<String> cropSquare(String srcFilePath) async {
    final image = await ImageCropper().cropImage(sourcePath: srcFilePath);
    String? destFilePath;
    if (image != null) {
      destFilePath = join((await getTemporaryDirectory()).path, '${DateTime.now().millisecondsSinceEpoch}.png');
      // final File finalImage = await image.copy(destFilePath);
    }
    return image!.path;
    // return destFilePath;
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    WidgetsBinding.instance.removeObserver(this);
    controller!.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.paused) {
      controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        controller = CameraController(cameras![0], ResolutionPreset.max);
        _initializeControllerFuture = controller!.initialize();
      });
    }
  }

  Future<void> captureImage(BuildContext context) async {
    if (controller == null) return;
    final pictureFile = await controller!.takePicture();
    final file = File(pictureFile.path);
    final inputImage = InputImage.fromFile(file);
    await _textRecognizer.processImage(inputImage).then((value) {
      Navigator.pop(context, value.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SolvifyAppbar(title: 'OCR'),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // final size = MediaQuery.of(context).size;
              // final deviceRatio = size.width / size.height;
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: CameraPreview(controller!),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera,
                        color: Colors.black,
                      ),
                      iconSize: 70.0,
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      onPressed: () async {
                        captureImage(context);
                      },
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
