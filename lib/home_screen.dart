import 'package:eutopia/comment_screen.dart';
import 'package:eutopia/posts_class.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.ctxt}) : super(key: key);
  final BuildContext ctxt;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('posts');
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
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
      );
      ;
      postsList.add(post);
    }
    //
    setState(() {
      print(postsList[0].url);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
            itemCount: postsList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: postsList[index].user_img,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        Text(postsList[index].name),
                      ],
                    ),
                    CachedNetworkImage(
                      imageUrl: postsList[index].url,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: 200.0,
                      width: MediaQuery.of(context).size.width - 20.0,
                      fit: BoxFit.contain,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(postsList[index].caption),
                        ),
                        GestureDetector(
                          child: Icon(Icons.messenger_outline_outlined),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                        postId: postsList[index].id,
                                      )),
                            );
                          },
                        )
                      ],
                    ),
                    SizedBox(
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
