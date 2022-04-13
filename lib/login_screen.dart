import 'package:eutopia/authentication.dart';
import 'package:eutopia/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isClicked = false;

  Future<void> _handleSignIn() async {
    setState(() {
      isClicked = true;
    });
    User? user = await Authentication.signInWithGoogle(context: context);

    // Authentication.initializeFirebase();

    if (user != null) {
      print(user.displayName.toString());
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainScreen(user: user)),
            (route) => false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        // color: Colors.red,
        width: MediaQuery.of(context).size.width,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
        child: Text(
          "By creating an account, you agree to our \nTerms & Conditions and agree to Privacy policy.",
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            color: Colors.grey,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage("assets/logoe.jpg"),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text("Eutopia",
                    style: GoogleFonts.notoSans(
                      fontSize: 50.0,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "Search less \ntravel more!",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 31,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "Great experiences at backpacker prices.",
              style: GoogleFonts.notoSans(
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            FutureBuilder(
                future: Authentication.initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error");
                  } else {
                    return !isClicked
                        ? GestureDetector(
                            onTap: _handleSignIn,
                            child: Container(
                              width: 190.0,
                              color: Color(0xff4285F4),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 2, bottom: 2, left: 2, right: 10),
                                    color: Colors.white,
                                    child: Image.asset(
                                      "assets/glogo.png",
                                      scale: 27,
                                    ),
                                  ),
                                  Text(
                                    "Sign in with Google",
                                    style: GoogleFonts.roboto(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        : Container(
                            color: Color(0xff4285F4),
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(10.0),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
