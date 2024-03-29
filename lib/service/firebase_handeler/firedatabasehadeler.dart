import 'dart:collection';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:securemsg/models/keymodel.dart';
import 'package:securemsg/models/msgModel.dart';
import 'package:securemsg/models/videomodel.dart';
import 'package:securemsg/service/validater/date.dart';
import 'package:securemsg/models/FrqModel.dart';

class FireDBhandeler {
  static final firestoreInstance = FirebaseFirestore.instance;
  static final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  static final user = FirebaseAuth.instance.currentUser;
  static String mainUserpath = "/users/" + user!.email.toString() + "/";
  static String mainUserpathRdb = "/users/" + user!.uid + "/";
  static final String rqinboxpath = "rqinbox";
  static final String rqsentpath = "rqsentbox";
  static final String firendboxtpath = "friendbox";
  static final String keyboxpath = "keybox";
  static final String sentkeyboxpath = "sentkeybox";
  static final String chatboxpath = "chatbox";

  //check doc is exists
  static Future<int> checkdocstatus(String collectionpath, String docid) async {
    var a = await FirebaseFirestore.instance
        .collection(collectionpath)
        .doc(docid)
        .get();
    if (a.exists) {
      print('Exists');
      return 0;
    } else if (!a.exists) {
      print('Not exists');
      return 1;
    } else {
      return 2;
    }
  }

  //add
  static Future<int> sendFriendRq(FrqModel gmodel, String email) async {
    String senduserpath = "/users/" + email + "/" + rqinboxpath;
    int status = await checkdocstatus(senduserpath, gmodel.email);
    status = 1;
    if (status == 1) {
      firestoreInstance
          .collection(senduserpath)
          .doc(gmodel.email)
          .set(gmodel.toMap())
          .then((_) {
        print("create  doc");
      });
    } else {
      print("already exsists");
    }
    return status;
  }

  static Future<int> saveFriendRq(FrqModel gmodel) async {
    int status = await checkdocstatus(mainUserpath + rqsentpath, gmodel.email);
    status = 1;
    if (status == 1) {
      firestoreInstance
          .collection(mainUserpath + rqsentpath)
          .doc(gmodel.email)
          .set(gmodel.toMap())
          .then((_) {
        print("create  doc");
      });
    } else {
      print("already exsists");
    }
    return status;
  }

  static Future<int> addFriendRq(FrqModel gmodel) async {
    //us
    int status =
        await checkdocstatus(mainUserpath + firendboxtpath, gmodel.email);
    if (status == 1) {
      firestoreInstance
          .collection(mainUserpath + firendboxtpath)
          .doc(gmodel.email)
          .set(gmodel.toMap())
          .then((_) {
        print("create  doc");
      });
    } else {
      print("already exsists");
    }
    //friend
    final senduser = FrqModel(
        id: user!.uid,
        email: user!.email!,
        name: user!.displayName!,
        datetime: gmodel.datetime);
    status = await checkdocstatus(
        "/users/" + gmodel.email + "/" + firendboxtpath, senduser.email);
    if (status == 1) {
      firestoreInstance
          .collection("/users/" + gmodel.email + "/" + firendboxtpath)
          .doc(senduser.email)
          .set(senduser.toMap())
          .then((_) {
        print("create  doc");
      });
    } else {
      print("already exsists");
    }
    int res = await deletedoc(gmodel.email, mainUserpath + rqinboxpath);

    return status;
  }

  // static Future<int> sendkeydoc(Keymodel gmodel, String email) async {
  //   String senduserpath = "/users/" + email + "/" + inkeyboxpath;
  //   int status = await checkdocstatus(senduserpath, gmodel.id);
  //   if (status == 1) {
  //     firestoreInstance
  //         .collection(senduserpath)
  //         .doc(gmodel.id)
  //         .set(gmodel.toMap())
  //         .then((_) {
  //       print("create  doc");
  //     });
  //   } else {
  //     print("already exsists");
  //   }
  //   return status;
  // }

  // static Future<int> savekeydoc(Keymodel gmodel) async {
  //   int status = await checkdocstatus(mainUserpath + sentkeyboxpath, gmodel.id);
  //   if (status == 1) {
  //     firestoreInstance
  //         .collection(mainUserpath + sentkeyboxpath)
  //         .doc(gmodel.id)
  //         .set(gmodel.toMap())
  //         .then((_) {
  //       print("create  doc");
  //     });
  //   } else {
  //     print("already exsists");
  //   }
  //   return status;
  // }

  //get  items

  static Future<List<FrqModel>> getFriends() async {
    List<FrqModel> glist = [];
    FrqModel gmodel;
    QuerySnapshot querySnapshot =
        await firestoreInstance.collection(mainUserpath + firendboxtpath).get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];

      // teachermodel = Teachermodel.fromSnapshot(a);
      gmodel = FrqModel.fromMap(a.data() as Map<String, dynamic>);
      glist.add(gmodel);
      // print(teachermodel.serialno);
    }
    glist.sort((a, b) => b.id.compareTo(a.id));
    return glist;
  }

  static Future<List<FrqModel>> getFriendRq() async {
    List<FrqModel> glist = [];
    FrqModel gmodel;
    QuerySnapshot querySnapshot =
        await firestoreInstance.collection(mainUserpath + rqinboxpath).get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];

      // teachermodel = Teachermodel.fromSnapshot(a);
      gmodel = FrqModel.fromMap(a.data() as Map<String, dynamic>);
      glist.add(gmodel);
      // print(teachermodel.serialno);
    }
    glist.sort((a, b) => b.id.compareTo(a.id));
    return glist;
  }

  static Future<Keymodel> getsentkey(String id) async {
    final String collectionpath = mainUserpath + sentkeyboxpath;
    Keymodel model;

    DocumentSnapshot documentSnapshot =
        await firestoreInstance.collection(collectionpath).doc(id).get();
    model = Keymodel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    return model;
  }

  static Future<Keymodel> getrecivekey(String id) async {
    final String collectionpath = mainUserpath + sentkeyboxpath;
    Keymodel model;

    DocumentSnapshot documentSnapshot =
        await firestoreInstance.collection(collectionpath).doc(id).get();
    model = Keymodel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    return model;
  }
  //getdoccount

  static Future<int> getDocCount(String collection) async {
    QuerySnapshot _myDoc = await firestoreInstance.collection(collection).get();

    return _myDoc.docs.length;
    // Count of Documents in Collection
  }

  //  static Future updatechatstatus() async {
  //   var firebaseUser = FirebaseAuth.instance.currentUser;
  //   int count = await userusercount();
  //   await firestoreInstance
  //       .collection("users")
  //       .doc("userlist")
  //       .update({"users": count + 1}).then((_) {
  //     print("success!");
  //   });
  // }

  static updateDocCountRealtime(String key, int value) async {
    await dbRef.update({
      key: value,
    });
  }

//realtimedb
  static Future<int> checkfiledstatus(String collectionpath) async {
    final snapshot = await dbRef.child('$collectionpath').get();
    if (snapshot.exists) {
      return 0;
    } else {
      return 1;
    }
  }

//ad
  static Future<int> sendMsgs(MsgModel msgModel) async {
    int res = 0;
    try {
      DatabaseReference ref;

      //sender
      ref = FirebaseDatabase.instance.ref("users/" +
          user!.uid +
          "/" +
          chatboxpath +
          "/" +
          msgModel.reciveid +
          "/" +
          msgModel.id);
//reciver
      await ref.set(msgModel.toMap());
      print("addedsenserm");
      ref = FirebaseDatabase.instance.ref("users/" +
          msgModel.reciveid +
          "/" +
          chatboxpath +
          "/" +
          msgModel.sendid +
          "/" +
          msgModel.id);

      await ref.set(msgModel.toMap());
      print("addedreceverm");
      res = 1;
    } on Exception catch (e) {
      print(e);
    }
    return res;
  }

  static Future<int> sendKey(MsgModel msgModel, Keymodel keymodel) async {
    int res = 0;
    try {
      DatabaseReference ref;

      //sender
      ref = FirebaseDatabase.instance.ref("users/" +
          user!.uid +
          "/" +
          keyboxpath +
          "/" +
          msgModel.reciveid +
          "/" +
          msgModel.id);
//reciver
      await ref.set(keymodel.toMap());
      print("addedsenserm");
      ref = FirebaseDatabase.instance.ref("users/" +
          msgModel.reciveid +
          "/" +
          keyboxpath +
          "/" +
          msgModel.sendid +
          "/" +
          msgModel.id);

      await ref.set(keymodel.toMap());
      print("addedreceverm");
      res = 1;
    } on Exception catch (e) {
      print(e);
    }
    return res;
  }

  static Future<Keymodel> getKey(MsgModel msgModel) async {
    Keymodel keymodel;
    String pathid;
    if (msgModel.sendid == user!.uid) {
      pathid = msgModel.reciveid;
    } else {
      pathid = msgModel.sendid;
    }
    final ref = FirebaseDatabase.instance.ref();
    final path = "users/" +
        user!.uid +
        "/" +
        keyboxpath +
        "/" +
        pathid +
        "/" +
        msgModel.id;
    final snapshot = await ref.child(path).get();
    print(path);
    if (snapshot.exists) {
      print(snapshot.value.toString() + "----------------");

      keymodel = Keymodel.fromMap(snapshot.value as Map<dynamic, dynamic>);
      print(keymodel.key);
      return keymodel;
    } else {
      print("not exit");
      return (Keymodel(
          id: "false",
          key: "key",
          addeddate: "addeddate",
          extesion: "extesion"));
    }
  }

  //delete document
  static Future<int> deletedoc(String id, String collection) async {
    int ishere = await checkdocstatus(collection, id);
    if (ishere == 0) {
      await firestoreInstance.collection(collection).doc(id).delete();
    }
    return ishere;
  }

  static Future<int> deletefiled(String path) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref(path);

    int ishere = await checkfiledstatus(path);
    print(path);
    print(ishere.toString() + "-----------------------------------");

    if (ishere == 0) {
      await ref.remove();
      print("deleted");
    }
    return ishere;
  }
}
