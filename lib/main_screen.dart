import 'package:eutopia/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key,required this.user}) : super(key: key);
  final User? user;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Future<void>? _handleSignOut(){
    Authentication.signOut(context: context);
  }



  @override
  Widget build(BuildContext context) {
    int selected=1;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.red,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected,
        onTap: (index){
            setState(() {
              selected=index;
              print(index);
            });
        },
        items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo_outlined),label: "Add"),
    BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 30.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Eutopia"),
              IconButton(onPressed: _handleSignOut, icon: const Icon(Icons.logout)),
            ],
          ),

          // GestureDetector(
            // onTap: _handleSignOut,
            // child: GoogleUserCircleAvatar(identity: widget.user,
            // ),
          // )
        ],
      ),
    );
  }
}
