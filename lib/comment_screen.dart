import 'package:eutopia/comments_class.dart';
import 'package:flutter/material.dart';
import 'classifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.postId, this.user})
      : super(key: key);
  final String postId;
  final User? user;
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late TextEditingController _controller;
  late Classifier _classifier;
  List<Comments> commentsList = [];
  int status = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _controller = TextEditingController();
    _classifier = Classifier();
  }

  Future<void> getData() async {
    // Get docs from collection reference
    print("done");
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('comments');
    QuerySnapshot querySnapshot =
        await _collectionRef.doc("posts").collection(widget.postId).get();
    //
    // // Get data from docs and convert map to List
    final allData = querySnapshot.docs.length;
    print(allData.toString());
    // FirebaseFirestore.instance.collection('comments').doc("posts")
    //     .collection(widget.postId).snapshots()
    //     .listen((event) {
    //     event.docs.forEach((element) {
    //
    // });
    // });
    for (int i = 0; i < allData; i++) {
      Comments post = Comments(
        querySnapshot.docs.elementAt(i).get("comment"),
        querySnapshot.docs.elementAt(i).get("status"),
        querySnapshot.docs.elementAt(i).get("email"),
        querySnapshot.docs.elementAt(i).get("user_img"),
        querySnapshot.docs.elementAt(i).get("username"),
        querySnapshot.docs.elementAt(i).id,
      );

      commentsList.add(post);
    }
    //
    setState(() {
      print(commentsList.toString());
    });
  }

  Future<void> addComment(int status) {
    // Call the user's CollectionReference to add a new user
    CollectionReference users = FirebaseFirestore.instance
        .collection('comments')
        .doc('posts')
        .collection(widget.postId);
    return users
        .add({
          'username': widget.user?.displayName, // John Doe
          'email': widget.user?.email,
          'user_img': widget.user?.photoURL, // Stokes and Sons
          'comment': _controller.text, // 42
          'status': status,
        })
        .then((value) => print("Comment Added"))
        .catchError((error) => print("Failed to add user: $error"));
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
                      status = 0;
                    } else {
                      status = 1;
                    }
                    addComment(status);
                    print("POSITIVE: " + status.toString());
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
