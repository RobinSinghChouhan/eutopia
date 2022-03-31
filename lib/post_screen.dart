import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key, @required this.user}) : super(key: key);
  final User? user;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final myController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String path = "";
  bool isImageLoaded = false;

  final picker = ImagePicker();
  String img_path = "";

  List? _result;
  String _confidence = "";
  String _name = "";

  String numbers = "";
  String url = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyModel();
  }

  Future<void> _pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      img_path = image!.path;
      applyModelOnImage(img_path);
      print("IMAGEPATH:  " + img_path);
    });
    // return image!.path;
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
        path: paths,
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

  Future<String> uploadPic() async {
    //Get the file from the image picker and store it
    // final image = await picker.pickImage(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("images/$time.png");

    //Upload the file to firebase
    File file = File(img_path);
    // if(image?.path!=null){
    // firebase_storage.UploadTask uploadTask =
    // }

    // Waits till the file is uploaded then stores the download url

    firebase_storage.TaskSnapshot taskSnapshot = await reference.putFile(file);

    // Waits till the file is uploaded then stores the download url
    url = await taskSnapshot.ref.getDownloadURL();
    // url = await firebase_storage.FirebaseStorage.instance
    //     .ref('images/$time.png')
    //     .getDownloadURL();
    print(url);
    addUser(url);
    //returns the download url
    return url;
  }

  Future<void> addUser(String url) {
    // Call the user's CollectionReference to add a new user
    CollectionReference users = FirebaseFirestore.instance.collection('posts');
    return users
        .add({
          'username': widget.user?.displayName, // John Doe
          'email': widget.user?.email,
          'user_img': widget.user?.photoURL, // Stokes and Sons
          'url': url,
          'caption': myController.text // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

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
          Text("POST"),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: img_path == ""
                      ? Container(
                          height: 150.0,
                          width: 180.0,
                          color: Colors.grey,
                        )
                      : Image.file(
                          File(img_path),
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: 180.0,
                        ),
                ),
              ),
              Column(
                children: [
                  Text("Predicted Category:"),
                  Text(_name),
                  Text("Confidence"),
                  Text(_confidence),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: myController,
            keyboardType: TextInputType.multiline,
            minLines: 2, //Normal textInputField will be displayed
            maxLines: 5,
            decoration: InputDecoration(
                labelText: 'Enter Name', hintText: 'Enter Your Name'),
          ),
          TextButton(onPressed: () => uploadPic(), child: Text("Print")),
        ],
      ),
    );
  }
}
