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
  // void initializeFirebase() {
  //   Firebase.initializeApp().whenComplete(() {
  //     print("completed");
  //     // setState(() {});
  //   });
  // }

  Future<void> _handleSignIn() async {
    // try{
    //   await _googleSignIn.signIn();
    // }catch(error){
    //   print(error);
    // }
    User? user = await Authentication.signInWithGoogle(context: context);

    print(user?.displayName.toString());

    // Authentication.initializeFirebase();

    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainScreen(user: user)),
          (route) => false);
    });
    // Navigator.pushAndRemoveUntil(
    //     // we are making YourHomePage widget the root if there is a user.
    //     context,
    //     MaterialPageRoute(builder: (context) => MainScreen(user: user)),
    //     (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // Authentication.initializeFirebase();
    checkUser();
    // FirebaseAuth.instance.currentUser!().then((user) {
    //   if (user != null) {
    //     //if there isn't any user currentUser function returns a null so we should check this case.
    //     Navigator.pushAndRemoveUntil(
    //         // we are making YourHomePage widget the root if there is a user.
    //         context,
    //         MaterialPageRoute(builder: (context) => MainScreen(user: user)),
    //         (Route<dynamic> route) => false);
    //   }
    // });
    super.initState();
  }

  Future<void> checkUser() async {
    User? userN = FirebaseAuth.instance.currentUser;
    if (userN != null && mounted) {
      // Authentication.initializeFirebase();
      setState(() {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainScreen(user: userN)),
              (route) => false);
        });

        // Navigator.pushAndRemoveUntil(
        //     // we are making YourHomePage widget the root if there is a user.
        //     context,
        //     MaterialPageRoute(builder: (context) => MainScreen(user: userN)),
        //     (Route<dynamic> route) => false);
      });
    }
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
                    return GestureDetector(
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
