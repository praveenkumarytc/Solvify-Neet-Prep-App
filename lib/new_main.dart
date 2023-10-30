import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Matching Game'),
//         ),
//         body: MatchingGame(),
//       ),
//     );
//   }
// }

class MatchingGame extends StatefulWidget {
  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  List<String> listA = [
    'Apple',
    'LPG',
    'Eraser'
  ];
  List<String> listB = [
    'Cylinder',
    'Rectangle',
    'Circle'
  ];
  List<bool> answers = [];
  bool isLineVisible = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: listA.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    answers.add(listB[index] == 'Cylinder'); // Check if the answer is correct
                    isLineVisible = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  color: Colors.blueGrey,
                  child: Text(
                    listA[index],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                itemCount: listB.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    color: answers.length > index
                        ? answers[index]
                            ? Colors.green
                            : Colors.red
                        : Colors.blueGrey,
                    child: Text(
                      listB[index],
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
              if (isLineVisible)
                CustomPaint(
                  size: Size.infinite,
                  painter: LinePainter(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    canvas.drawLine(Offset(50, 0), Offset(50, 500), paint); // Adjust the coordinates based on your UI
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
