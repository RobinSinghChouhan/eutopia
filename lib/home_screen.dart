import 'package:eutopia/comment_screen.dart';
import 'package:eutopia/posts_class.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.user}) : super(key: key);
  final User? user;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('posts');
  List<Posts> postsList = [];

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    //
    // // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc["email"]).toList();
    for (int i = 0; i < allData.length; i++) {
      Posts post = Posts(
        querySnapshot.docs.elementAt(i).get("caption"),
        querySnapshot.docs.elementAt(i).get("email"),
        querySnapshot.docs.elementAt(i).get("url"),
        querySnapshot.docs.elementAt(i).get("user_img"),
        querySnapshot.docs.elementAt(i).get("username"),
        querySnapshot.docs.elementAt(i).id,
        querySnapshot.docs.elementAt(i).get("time"),
      );
      postsList.add(post);
    }

    postsList.sort((a, b) => a.time.compareTo(b.time));
    //
    setState(() {
      print(postsList[0].url);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
            itemCount: postsList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: index == 0 ? 20.0 : 15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 23,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              imageUrl: postsList[index].user_img,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postsList[index].name,
                              style: GoogleFonts.notoSans(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              postsList[index].email.substring(
                                  0, postsList[index].email.length - 10),
                              style: GoogleFonts.notoSans(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        color: Colors.grey.withOpacity(0.1),
                        child: CachedNetworkImage(
                          imageUrl: postsList[index].url,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          height: 200.0,
                          width: MediaQuery.of(context).size.width - 20.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          postsList[index].caption,
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          child: const Image(
                            image: AssetImage("assets/comment.png"),
                            width: 30.0,
                            height: 30.0,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                        postId: postsList[index].id,
                                        user: widget.user,
                                      )),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
