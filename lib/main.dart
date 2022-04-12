import 'dart:io';
import 'package:eutopia/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();
  // firebase_storage _storage = FirebaseStorage.instance;

  int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //
  //     _counter++;
  //   });
  // }
  FirebaseAuth mAuth = FirebaseAuth.instance;

  void signInAnonymously() async {
    // UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();

    mAuth.signInAnonymously().then((result) {
      setState(() {
        // final User? user = result.user;
      });
    });
  }

  Future<String> uploadPic() async {
    //Get the file from the image picker and store it
    final image = await picker.pickImage(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref().child("images/");

    //Upload the file to firebase
    File file = File(image!.path);
    // if(image?.path!=null){
    firebase_storage.UploadTask uploadTask = reference.putFile(file);
    // }

    // Waits till the file is uploaded then stores the download url

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.snapshot;

    // Waits till the file is uploaded then stores the download url
    String url = await taskSnapshot.ref.getDownloadURL();
    print(url);

    //returns the download url
    return url;
  }

  @override
  Widget build(BuildContext context) {
// signInAnonymously();
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Future<void> addUser() {
    //   // Call the user's CollectionReference to add a new user
    //
    //   return users
    //       .add({
    //     'full_name': 'Robin Singh', // John Doe
    //     'company': 'Codigo', // Stokes and Sons
    //     'age': '22' // 42
    //   })
    //       .then((value) => print("User Added"))
    //       .catchError((error) => print("Failed to add user: $error"));
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadPic,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
