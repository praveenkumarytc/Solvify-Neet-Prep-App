import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:velocity_x/velocity_x.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({super.key});

  GlobalKey _globalKey = GlobalKey();
  Future<void> _onSharePressed() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final file = await File('${directory.path}/image.png').create();

    await file.writeAsBytes(pngBytes);
    String message = 'I just scored 5 out of 10 on the mock test! Check it out:\n\nhttps://play.google.com/store/apps/details?id=com.solvify.neet_prep_app';

    Share.shareFiles([
      file.path
    ], text: message, subject: 'Image sharing', sharePositionOrigin: Rect.fromLTWH(0, 0, 10, 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorResources.COLOR_BLUE.withOpacity(.5),
              Colors.pink.withOpacity(.5)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: RepaintBoundary(
            key: _globalKey,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DecorativeContainer(),
                  50.heightBox,
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Your today\'s result are here:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  20.heightBox,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check, color: Colors.green),
                            SizedBox(height: 8),
                            Text('Correct'),
                            SizedBox(height: 4),
                            Text('2/5'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                        height: 65,
                        child: VerticalDivider(
                          thickness: 1.5,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.close, color: Colors.red),
                            SizedBox(height: 8),
                            Text('Wrong'),
                            SizedBox(height: 4),
                            Text('1/5'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                        height: 65,
                        child: VerticalDivider(
                          thickness: 1.5,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.help_outline, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Skipped'),
                            SizedBox(height: 4),
                            Text('2/5'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  50.heightBox,
                  ShareButton(
                    onSharePressed: _onSharePressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({super.key, required this.onSharePressed});
  final Function() onSharePressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onSharePressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorResources.primaryBlue(context),
                ColorResources.PRIMARY_MATERIAL
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Center(
            child: Text(
              'Share Result',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class DecorativeContainer extends StatelessWidget {
  const DecorativeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          Center(
            child: ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.white
                ],
                stops: [
                  0.0,
                  0.3,
                  1.0
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: Image.asset(
                Images.biology,
                scale: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
