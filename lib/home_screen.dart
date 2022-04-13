import 'package:eutopia/comment_screen.dart';
import 'package:eutopia/posts_class.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
    postsList.clear();
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

    postsList.sort((b, a) => a.time.compareTo(b.time));
    // postsList = postsList.reversed;
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
      margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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
              itemCount: postsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(15.0)),
                  margin: EdgeInsets.only(top: index == 0 ? 10.0 : 15.0),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xff1f0a45),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 23,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CachedNetworkImage(
                                      imageUrl: postsList[index].user_img,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
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
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      postsList[index].email.substring(0,
                                          postsList[index].email.length - 10),
                                      style: GoogleFonts.notoSans(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 230.0,
                            ),
                            Container(
                              // color: Colors.grey,
                              // width: MediaQuery.of(context).size.width - 50.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      postsList[index].caption,
                                      maxLines: 3,
                                      style: GoogleFonts.notoSans(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  GestureDetector(
                                    child: const Icon(
                                      FeatherIcons.twitter,
                                      color: Colors.white,
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
                            ),
                            const SizedBox(
                              height: 10.0,
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.07),
                        // color: Colors.black,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            margin:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color(0xff8f87a3).withOpacity(0.7),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: postsList[index].url,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width - 20.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
