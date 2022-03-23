import 'package:eutopia/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key,required this.user}) : super(key: key);
  final User? user;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void>? _handleSignOut(){
    Authentication.signOut(context: context);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          IconButton(onPressed: _handleSignOut, icon: const Icon(Icons.logout)),
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
