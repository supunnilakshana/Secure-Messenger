import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:securemsg/models/userModel.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';

class UserdbHandeler {
  static final user = FirebaseAuth.instance.currentUser;
  static final firestoreInstance = FirebaseFirestore.instance;

//--------------------------------------add user----------------------------------------------------------------------------
  static Future<void> adduser(String email, Usermodel usermodel) async {
    int res = await FireDBhandeler.checkdocstatus("users", email);
    if (res == 1) {
      firestoreInstance
          .collection("users")
          .doc(email)
          .set(usermodel.toMap())
          .then((_) async {
        print("create user doc");
        await updateuserlist(email);
        print("updated");
      });
    }
  }

  //--------------------------------------get user user list---------------------------------------------------------------------------
  static Future<List<String>> getuserlist() async {
    List<dynamic> users = [];
    List<String> userlist = [];
    var firebaseUser = FirebaseAuth.instance.currentUser;
    int count = 0;
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .get()
        .then((value) {
      print(value.data()!["user_list"]);
      users = value.data()!["user_list"];
      users.forEach((element) {
        userlist.add(element.toString());
      });
    });
    return userlist;
  }

  //--------------------------------------get user user count----------------------------------------------------------------------------
  static Future userusercount() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;

    int count = 0;
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .get()
        .then((value) {
      print(value.data()!["users"]);
      count = (value.data()!["users"]);
      // print("----------------------------------------------------------------" +  count.toString());
    });
    return count;
  }

  //--------------------------------------update user user count----------------------------------------------------------------------------
  static Future updateusercount() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    int count = await userusercount();
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .update({"users": count + 1}).then((_) {
      print("success!");
    });
  }

  static Future updateuserlist(String name) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    List<String> currentlist = await getuserlist();
    currentlist.add(name);
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .update({"user_list": currentlist}).then((_) {
      print("added");
    });
  }

  static Future inituserlist(String name) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    List<String> currentlist = [];
    currentlist.add(name);
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .update({"user_list": currentlist}).then((_) {
      print("added");
    });
  }

  //--------------------------------------search user---------------------------------------------------------------------------
  static Future<List<String>> searchuser(String email) async {
    List<dynamic> users = [];
    List<String> userlist = [];
    List<String> filterlist = [];
    var firebaseUser = FirebaseAuth.instance.currentUser;
    int count = 0;
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .get()
        .then((value) {
      print(value.data()!["user_list"]);
      users = value.data()!["user_list"];

      users.forEach((element) {
        userlist.add(element.toString());
      });

      filterlist = userlist
          .where((user) => user.toLowerCase().contains(email.toLowerCase()))
          .toList();
    });
    return filterlist;
  }
}
