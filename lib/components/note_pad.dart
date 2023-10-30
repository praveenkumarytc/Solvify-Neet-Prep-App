import 'package:flutter/material.dart';

class FlutterNotePad extends StatefulWidget {
  const FlutterNotePad({Key? key, required this.initialText}) : super(key: key);
  final String? initialText;
  @override
  _FlutterNotePadState createState() => _FlutterNotePadState();
}

class _FlutterNotePadState extends State<FlutterNotePad> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
    if (widget.initialText != null) {
      _textEditingController.text = widget.initialText!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Note here'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  controller: _textEditingController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Start typing here...',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print(_textEditingController.text);
                    Navigator.pop(context, _textEditingController.text);
                  },
                  child: Text('Save'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality to clear the text
                    _textEditingController.clear();
                  },
                  child: Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
