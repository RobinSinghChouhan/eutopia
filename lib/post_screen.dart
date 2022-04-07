import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key, @required this.user}) : super(key: key);
  final User? user;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final myController = TextEditingController();
  Random random = Random();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String path = "";
  bool isImageLoaded = false;

  final picker = ImagePicker();
  String img_path = "";

  List? _result;
  String _confidence = "12312413452354235423";
  String _name = "";

  String numbers = "";
  String url = "";
  String selected = "";
  String caption = "";
  var predList = [];
  var otherList = [];

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

  void randomize(int num) {
    int randomNumber = 1;
    if (num == 0) {
      randomNumber = random.nextInt(predList.length);
      myController.text = predList[randomNumber].toString();
    } else {
      randomNumber = random.nextInt(otherList.length);
      myController.text = otherList[randomNumber].toString();
    }
    // return predlist[randomNumber].toString();
  }

  Future<String> loadAsset(BuildContext context, String name) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/captions/' + name.toLowerCase() + '.txt');
  }

  loadMyModel() async {
    var resultant = await Tflite.loadModel(
        labels: "assets/labels.txt", model: "assets/model_unquant.tflite");
    print("Result after loading model: $resultant");
    String input = await loadAsset(context, "other");
    otherList = input.split('\n');
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

      selected = _name;
    });

    String fileText = await loadAsset(context, selected);
    predList = fileText.split('\n');
    // print(predList[2].toString());
    randomize(0);
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 35.0,
                      )),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "New Post",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.notoSans(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                height: 250.0,
                margin: const EdgeInsets.only(top: 15.0),
                width: MediaQuery.of(context).size.width - 30,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: img_path == ""
                            ? Container(
                                height: 220.0,
                                width: MediaQuery.of(context).size.width - 20.0,
                                color: Colors.grey,
                              )
                            : Container(
                                color: Colors.grey.withOpacity(0.4),
                                child: Image.file(
                                  File(img_path),
                                  fit: BoxFit.contain,
                                  height: 220.0,
                                  width:
                                      MediaQuery.of(context).size.width - 20.0,
                                ),
                              ),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      margin:
                          EdgeInsets.only(top: 195, left: 20.0, right: 20.0),
                      // color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            height: 40.0,
                            // width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: Text(
                              _name + ": " + _confidence.substring(0, 5) + "%",
                              style: GoogleFonts.roboto(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Caption Theme:",
                      style: GoogleFonts.notoSans(
                        fontSize: 18.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Radio(
                                value: _name,
                                groupValue: selected,
                                autofocus: true,
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Color(0xff1f0a45)),
                                onChanged: (value) {
                                  setState(() {
                                    selected = value.toString();
                                    print(value.toString());
                                  });
                                }),
                            Text(
                              _name,
                              style: GoogleFonts.notoSans(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                                value: "other",
                                groupValue: selected,
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Color(0xff1f0a45)),
                                onChanged: (value) {
                                  setState(() {
                                    selected = value.toString();
                                    print(value.toString());
                                  });
                                }),
                            Text(
                              "Other",
                              style: GoogleFonts.notoSans(),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            randomize(10);
                          },
                          child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Color(0xff1f0a45),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (selected.toLowerCase() == "other") {
                                    randomize(1);
                                  } else {
                                    randomize(0);
                                  }
                                },
                                icon: const Icon(
                                  Icons.refresh_outlined,
                                  color: Colors.white,
                                ),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
              TextFormField(
                controller: myController,
                keyboardType: TextInputType.multiline,
                minLines: 2, //Normal textInputField will be displayed
                maxLines: 5,
                decoration: const InputDecoration(
                    labelText: 'Enter Caption',
                    hintText: 'Type Something.',
                    labelStyle: TextStyle(
                      color: Color(0xff1f0a45),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: const BorderSide(
                          color: Color(0xff1f0a45), width: 2.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  uploadPic();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 30.0),
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Color(0xff1f0a45),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    "Post",
                    style: GoogleFonts.notoSans(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
