import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:securemsg/models/keymodel.dart';
import 'package:securemsg/models/videomodel.dart';
import 'package:securemsg/test/test1.dart';

class FireDBhandeler {
  static final firestoreInstance = FirebaseFirestore.instance;
  static final DatabaseReference dbRef = FirebaseDatabase.instance.ref("count");

  static final user = FirebaseAuth.instance.currentUser;
  static String mainUserpath = "/users/" + user!.email.toString() + "/";
  static final String rqinboxpath = "rqinbox";
  static final String sentpath = "rqsentbox";
  static final String firendboxtpath = "friendbox";
  static final String inkeyboxpath = "inkeybox";
  static final String sentkeyboxpath = "sentkeybox";

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
    if (status == 1) {
      firestoreInstance
          .collection(senduserpath)
          .doc(gmodel.id)
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
    int status = await checkdocstatus(mainUserpath + sentpath, gmodel.email);
    if (status == 1) {
      firestoreInstance
          .collection(mainUserpath + sentpath)
          .doc(gmodel.id)
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
    int status = await checkdocstatus(mainUserpath + sentpath, gmodel.email);
    if (status == 1) {
      firestoreInstance
          .collection(mainUserpath + sentpath)
          .doc(gmodel.email)
          .set(gmodel.toMap())
          .then((_) {
        print("create  doc");
      });
    } else {
      print("already exsists");
    }
    //friend
    status = await checkdocstatus(
        "/users/" + gmodel.email + "/" + firendboxtpath, gmodel.email);
    if (status == 1) {
      firestoreInstance
          .collection("/users/" + gmodel.email + "/" + firendboxtpath)
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
        await firestoreInstance.collection(mainUserpath + sentpath).get();
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

  static updateDocCountRealtime(String key, int value) async {
    await dbRef.update({
      key: value,
    });
  }

  //delete document
  static Future<int> deletedoc(String id, String collection) async {
    int ishere = await checkdocstatus(collection, id);
    if (ishere == 0) {
      await firestoreInstance.collection(collection).doc(id).delete();
    }
    return ishere;
  }
}
