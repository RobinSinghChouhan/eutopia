import 'dart:io';

import 'package:eutopia/account_screen.dart';
import 'package:eutopia/authentication.dart';
import 'package:eutopia/home_screen.dart';
import 'package:eutopia/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

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
            //   _pickImage();
            // if (img_path == "") {
            // } else {
            selected = 0;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostScreen(
                  // path: img_path,
                  user: widget.user,
                ),
              ),
            );
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
            print("Indexd: " + index.toString());
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
              top: 45.0,
              left: 10.0,
              right: 10.0,
              bottom: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25.0,
                      backgroundImage: AssetImage("assets/logoe.jpg"),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Eutopia",
                      style: GoogleFonts.notoSans(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: selected == 0
                  ? HomeScreen(
                      user: widget.user,
                    )
                  : const AccountScreen()),
        ],
      ),
    );
  }
}
