import 'package:flutter/material.dart';

class PlaceholderContainer extends StatelessWidget {
  const PlaceholderContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.camera_alt,
            size: 50,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Text(
            'Tap to select image',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
