import 'package:eutopia/comments_class.dart';
import 'package:flutter/material.dart';
import 'classifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  double _positive = 0.0;
  double _negative = 0.0;

  @override
  void initState() {
    super.initState();
    commentsList.clear();
    getData();
    _controller = TextEditingController();
    _classifier = Classifier();
  }

  Future<void> getData() async {
    // Get docs from collection reference
    print("done");
    commentsList.clear();
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
        querySnapshot.docs.elementAt(i).get("time"),
      );
      commentsList.add(post);
    }
    commentsList.sort((b, a) => a.time.compareTo(b.time));
    //
    setState(() {
      print(commentsList[0].time.toString());
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
          'time': DateTime.now().millisecondsSinceEpoch.toString(),
        })
        .then((value) => print("Comment Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: const Color(0xff1f0a45),
                decoration: const InputDecoration.collapsed(
                    hintText: "Type Comment Here"),
                style: GoogleFonts.notoSans(
                  fontSize: 18.0,
                ),
                controller: _controller,
              ),
              // width: MediaQuery.of(context).size.width - 80,
            ),
            TextButton(
              onPressed: () {
                if (_controller.text != "") {
                  final prediction = _classifier.classify(_controller.text);
                  _positive = prediction[1];
                  _negative = prediction[0];
                  if (prediction[1] < prediction[0]) {
                    status = 0;
                  } else {
                    status = 1;
                  }
                } else {}
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            children: [
                              Text(
                                "Detected Comment",
                                style: GoogleFonts.notoSans(
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              LinearProgressIndicator(
                                value: _positive,
                                backgroundColor: const Color(0xffE5F4F0),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xff52DCB3)),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text("Positive(%): " +
                                  (_positive * 100).toString().substring(0, 5)),
                              const SizedBox(
                                height: 20.0,
                              ),
                              LinearProgressIndicator(
                                value: _negative,
                                backgroundColor: const Color(0xffF5EBEB),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xffE86666)),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text("Negative(%): " +
                                  (_negative * 100).toString().substring(0, 5)),
                              const SizedBox(
                                height: 25.0,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    addComment(status);
                                    setState(() {
                                      _controller.text = "";
                                      getData();

                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                    });
                                    print("POSITIVE: " + _positive.toString());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xff1f0a45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 10.0),
                                    child: Text(
                                      "Post",
                                      style: GoogleFonts.notoSans(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10.0),
                              //       color: const Color(0xff1f0a45),
                              //     ),
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 50.0, vertical: 10.0),
                              //     child: Text(
                              //       "Post",
                              //       style: GoogleFonts.notoSans(
                              //         fontSize: 16.0,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: const CircleAvatar(
                backgroundColor: Color(0xff1f0a45),
                radius: 25.0,
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Comments",
                textAlign: TextAlign.start,
                style: GoogleFonts.notoSans(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Expanded(
                // width: MediaQuery.of(context).size.width - 30,
                // height: MediaQuery.of(context).size.height - 100,
                // margin: const EdgeInsets.only(top: 15.0),
                child: RefreshIndicator(
                  color: const Color(0xff1f0a45),
                  onRefresh: () async {
                    setState(() {
                      getData();
                    });
                  },
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                        itemCount: commentsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              // color: Colors.green.withOpacity(0.15),
                              color: commentsList[index].status == 0
                                  ? const Color(0xffF5EBEB)
                                  : const Color(0xffE5F4F0),
                            ),
                            padding: const EdgeInsets.all(15.0),
                            width: MediaQuery.of(context).size.width - 30,
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 23,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CachedNetworkImage(
                                      imageUrl: commentsList[index].user_img,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        commentsList[index].name,
                                        style: GoogleFonts.notoSans(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        commentsList[index].comment,
                                        style: GoogleFonts.notoSans(
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
