import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'authentication.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key, @required this.user}) : super(key: key);
  final User? user;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String username = "";

  @override
  Widget build(BuildContext context) {
    username = widget.user!.email.toString();
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Card(
            elevation: 5.0,
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width - 30,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
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
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.user!.displayName.toString(),
                    style: GoogleFonts.notoSans(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    username.substring(0, username.length - 10),
                    style: GoogleFonts.notoSans(),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Card(
            elevation: 5.0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 30.0,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(FeatherIcons.mail),
                    title: Text(
                      widget.user!.email.toString(),
                      style: GoogleFonts.notoSans(),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(FeatherIcons.phone),
                    title: Text(
                      // widget.user!.phoneNumber.toString(),
                      widget.user!.phoneNumber.toString(),
                      style: GoogleFonts.notoSans(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Column(
                          children: [
                            Text(
                              "Are you sure you want to logout?",
                              style: GoogleFonts.notoSans(
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Authentication.signOut(context: context);
                                  },
                                  child: const Text("Yes"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                  child: Text("Cancel"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            style: ElevatedButton.styleFrom(
                primary: const Color(0xffdb3c24),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 5.0)),
            child: SizedBox(
                width: MediaQuery.of(context).size.width - 70.0,
                child: ListTile(
                  leading: const Icon(
                    FeatherIcons.power,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Logout",
                    style: GoogleFonts.notoSans(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
