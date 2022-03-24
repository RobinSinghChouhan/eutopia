import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key, required this.path}) : super(key: key);
  final String path;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.file(
                    File(widget.path),
                    fit: BoxFit.cover,
                    height: 150.0,
                    width: 180.0,
                  ))),
        ],
      ),
    );
  }
}
