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
  String path = "";
  bool isImageLoaded = false;

  List? _result;
  String _confidence = "";
  String _name = "";

  String numbers = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyModel();
  }

  loadMyModel() async {
    var resultant = await Tflite.loadModel(
        labels: "assets/labels.txt", model: "assets/model_unquant.tflite");
    print("Result after loading model: $resultant");
  }

  applyModelOnImage(String paths) async {
    // final image = img.decodeImage(File(path).readAsBytesSync())!;

    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    // final thumbnail = img.copyResize(image, width: 150,height: 150);

    // Save the thumbnail as a PNG.
    // File('thumbnail.png').writeAsBytesSync(img.encodePng(thumbnail));

    var res = await Tflite.runModelOnImage(
        path:
            "/data/user/0/com.codigo.eutopia/cache/image_picker6367354473638688565.jpg",
        numResults: 6,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _result = res;
      String str = _result?[0]["label"];
      _name = str.substring(2);
      _confidence = _result != null
          ? (_result?[0]['confidence'] * 100.0).toString() + "%"
          : "";
      print(_result.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    applyModelOnImage(path);
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
