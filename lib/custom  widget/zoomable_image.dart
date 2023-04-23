import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableImage extends StatefulWidget {
  final ImageProvider image;

  const ZoomableImage({super.key, required this.image});

  @override
  _ZoomableImageState createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: double.infinity,
            child: PhotoView(
              imageProvider: widget.image,
              minScale: PhotoViewComputedScale.contained,
              maxScale: 2.0,
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: Opacity(
              opacity: 0.6,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
