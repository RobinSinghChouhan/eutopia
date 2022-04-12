import 'package:eutopia/account_screen.dart';
import 'package:eutopia/authentication.dart';
import 'package:eutopia/home_screen.dart';
import 'package:eutopia/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.user}) : super(key: key);
  final User? user;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selected = 0;
  String img_path = "";
  final picker = ImagePicker();
  // Future<void>? _handleSignOut() {
  //   Authentication.signOut(context: context);
  //   return null;
  // }

  Future<void> _pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    // if (mounted) {
    setState(() {
      img_path = image!.path;
      print("IMAGEPATH:  " + img_path);

      redirectNow();
    });
    // }
    // return image!.path;
  }

  void redirectNow() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostScreen(
              // path: img_path,
              user: widget.user,
              img: img_path,
            ),
          ));
    });
    // if (mounted) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => PostScreen(
    //         // path: img_path,
    //         user: widget.user,
    //         img: img_path,
    //       ),
    //     ),
    //   );
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    // Authentication.initializeFirebase();
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
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blue,
      //   child: const Icon(
      //     Icons.qr_code_scanner_rounded,
      //     size: 28,
      //   ),
      //   onPressed: () async {
      //     _pickImage();
      //     setState(() {
      //       //   _pickImage();
      //       // if (img_path == "") {
      //       // } else {
      //       if (img_path == "") {
      //         selected = 0;
      //       } else {}
      //       // }
      //     });
      //   },
      //   //params
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // bottomNavigationBar: AnimatedBottomNavigationBar(
      //   onTap: (index) {
      //     setState(() {
      //       selected = index;
      //       print("Indexd: " + index.toString());
      //     });
      //   },
      //   icons: const [Icons.home, Icons.settings],
      //   activeIndex: selected,
      //   gapLocation: GapLocation.center,
      //   iconSize: 28,
      //   activeColor: Colors.red,
      //   splashRadius: 20,
      //   notchSmoothness: NotchSmoothness.verySmoothEdge,
      // ),
      bottomNavigationBar: Container(
        margin:
            const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        height: 75.0,
        decoration: BoxDecoration(
          color: const Color(0xff1f0a45),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  selected = 0;
                });
              },
              icon: Icon(
                FeatherIcons.home,
                color: selected == 0
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
              ),
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _pickImage();
                setState(() {
                  //   _pickImage();
                  // if (img_path == "") {
                  // } else {
                  if (img_path == "") {
                    selected = 0;
                  } else {}
                  // }
                });
              },
              child: const Icon(
                FeatherIcons.camera,
                color: Color(0xff1f0a45),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  selected = 1;
                });
              },
              icon: Icon(
                FeatherIcons.user,
                color: selected == 1
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
              ),
            )
          ],
        ),
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
                  onTap: () {
                    Authentication.signOut(context: context);
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
                  : AccountScreen(
                      user: widget.user,
                    )),
        ],
      ),
    );
  }
}
