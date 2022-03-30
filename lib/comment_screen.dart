import 'package:flutter/material.dart';
import 'classifier.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.postId}) : super(key: key);
  final String postId;
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late TextEditingController _controller;
  late Classifier _classifier;
  late List<Widget> _children;
  int positive = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
    _classifier = Classifier();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
              ),
              // width: MediaQuery.of(context).size.width - 80,
            ),
            TextButton(
                onPressed: () {
                  if (_controller.text != "") {
                    final prediction = _classifier.classify(_controller.text);
                    if (prediction[1] < prediction[0]) {
                      positive = 0;
                    } else {
                      positive = 1;
                    }
                    print("POSITIVE: " + positive.toString());
                  }
                },
                child: Text("Send"))
          ],
        ),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Column(
            children: [
              Text("Comments"),
              // GestureDetector(
              //   child: Text("Comments"),
              //   onTap: () {
              //     final prediction =
              //         _classifier.classify("This is a good location.");
              //     setState(() {
              //       print("PREDICTION: " + "positive: ${prediction[1]}");
              //       print("PREDICTION: " + "negative: ${prediction[0]}");
              //     });
              //   },
              // ),
            ],
          )),
    );
  }
}
