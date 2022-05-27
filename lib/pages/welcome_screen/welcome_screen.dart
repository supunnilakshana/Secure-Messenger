import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/pages/authentication/local_auth_screen.dart';
import 'package:securemsg/pages/sign_in_up/authcheckingscreen.dart';
import 'package:securemsg/pages/sign_in_up/signin.dart';
import 'package:securemsg/service/local/localdb_handeler.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<WelcomeScreen> {
  int status = 0;
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    status = await LocalDbHandeler.getFsecureStatus();
    var duration = Duration(seconds: 1);
    return Timer(duration, route);
  }

  route() {
    if (status == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthChecking()));
    }
  }

  initScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("Starting..");
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Colors.black),
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: size.height * 0.35),
          Image.asset(
            "assets/icons/welcomeicon.png",
            width: size.width * 0.6,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.05),
                child: Text(
                  "Secure  Messenger ",
                  style: GoogleFonts.balsamiqSans(
                      fontWeight: FontWeight.w500,
                      fontSize: size.width * 0.04,
                      color: kdefualtfontcolor.withOpacity(0.8)),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
