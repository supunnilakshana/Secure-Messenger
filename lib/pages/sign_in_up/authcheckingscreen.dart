import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:securemsg/pages/Home/homescreen.dart';
import 'package:securemsg/pages/sign_in_up/signin.dart';

class AuthChecking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return Homescreen();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Somthing wrong!!"),
          );
        } else {
          return Signin();
        }
      },
    ));
  }
}
