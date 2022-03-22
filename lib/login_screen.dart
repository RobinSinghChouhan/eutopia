import 'package:eutopia/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;

  initState(){
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        print(_currentUser!.email.toString());
      });
      if (_currentUser != null) {
        // _handleGetContact(_currentUser!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(title: "My New App")));
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async{
    try{
      await _googleSignIn.signIn();
    }catch(error){
      print(error);
    }
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
            TextButton(onPressed: _handleSignIn, child: const Text("Sign in with google")),
          ],
        ),
      ),
    );
  }
}
