import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:securemsg/models/userModel.dart';
import 'package:securemsg/service/firebase_handeler/user_handeler.dart';
import 'package:securemsg/service/validater/date.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    print("tyy");
    try {
      final googleUser = await googleSignIn.signIn();
      print(googleUser);
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await UserdbHandeler.adduser(
          _user!.email.toString(),
          Usermodel(
              id: _user!.id, email: _user!.email.toString(), firends: []));
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
