import 'dart:io';

import 'package:eutopia/account_screen.dart';
import 'package:eutopia/authentication.dart';
import 'package:eutopia/home_screen.dart';
import 'package:eutopia/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.user}) : super(key: key);
  final User? user;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selected = 0;

  Future<void>? _handleSignOut() {
    Authentication.signOut(context: context);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    print("selected" + selected.toString());
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.red,
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          size: 28,
        ),
        onPressed: () {
          setState(() {
            // _pickImage();
            // if (img_path == "") {
            // } else {
            selected = 2;
            // }
          });
        },
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        onTap: (index) {
          setState(() {
            selected = index;
          });
        },
        icons: const [Icons.home, Icons.settings],
        activeIndex: selected,
        gapLocation: GapLocation.center,
        iconSize: 28,
        activeColor: Colors.red,
        splashRadius: 20,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              bottom: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Eutopia"),
                GestureDetector(
                  onTap: () {
                    _handleSignOut();
                  },
                  child: CircleAvatar(
                    radius: 25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: CachedNetworkImage(
                        imageUrl: widget.user!.photoURL.toString(),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: selected == 0
                ? HomeScreen()
                : selected == 1
                    ? AccountScreen()
                    : PostScreen(
                        // path: img_path,
                        user: widget.user,
                      ),
          ),
        ],
      ),
    );
  }
}
