
import 'package:eutopia/authentication.dart';
import 'package:eutopia/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  late GoogleSignInAccount? _currentUser;



  Future<void> _handleSignIn() async{
    // try{
    //   await _googleSignIn.signIn();
    // }catch(error){
    //   print(error);
    // }
    User? user = await Authentication.signInWithGoogle(context: context);

    print(user?.displayName.toString());
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0,),
            const Text("Eutopia",
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
            ),),
            const SizedBox(height: 20.0,),
            const Text("Eutopia \n asdas",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),),
            FutureBuilder(future: Authentication.initializeFirebase(),builder: (context,snapshot){
                if(snapshot.hasError){
                  return Text("Error");
                }else{
              return TextButton(onPressed: _handleSignIn, child: const Text("Sign in with google"));

              }
            })

          ],
        ),
      ),
    );
  }
}
