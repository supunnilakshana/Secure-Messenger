import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/pages/sign_in_up/signin.dart';
import 'package:securemsg/service/auth/google/GoogleSignAuth.dart';
import 'package:securemsg/service/local/localdb_handeler.dart';
import 'package:securemsg/ui_components/buttons.dart';
import 'package:securemsg/ui_components/popup_dilog.dart';
import 'package:securemsg/ui_components/tots.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  late bool isswitched;

  late Future<int> fstatus;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    fstatus = LocalDbHandeler.getFsecureStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: fstatus,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          int data = snapshot.data as int;
          print(data);
          if (data == 1) {
            isswitched = true;
          } else {
            isswitched = false;
          }
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage("assets/images/dashappbar.jpg"),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  accountEmail: Text(user!.email.toString()),
                  accountName: Text(user!.displayName.toString()),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(user!.photoURL.toString()),
                  ),
                ),
                ListTile(
                  title: const Text(''),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Reset Password'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.security_rounded),
                  title: Text('Fingerprint Scurity'),
                  trailing: Switch(
                    value: isswitched,
                    autofocus: false,
                    onChanged: (value) async {
                      isswitched = value;
                      setState(() {
                        print(value);
                      });

                      if (value == true) {
                        PopupDialog.showPopupDilog(context, () async {
                          int res =
                              await LocalDbHandeler.updateFsecurestatus(1);
                          if (res == 1) {
                            Customtost.commontost(
                                "Fingerprint Security is on", kprimaryColor);
                          } else {
                            Customtost.commontost(
                                "Somthing went wrong", Colors.redAccent);
                          }
                          loaddata();
                        },
                            "Security",
                            "You must set up your system fringerprint!!",
                            "Switch on");
                      } else {
                        int res = await LocalDbHandeler.updateFsecurestatus(0);
                        if (res == 1) {
                          Customtost.commontost(
                              "Fingerprint Security is off", kprimaryColor);
                        } else {
                          Customtost.commontost(
                              "Somthing went wrong", Colors.redAccent);
                        }
                      }
                      loaddata();
                    },
                    activeTrackColor: kprimarylightcolor,
                    activeColor: kprimaryColor,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Iconbutton(
                    text: "Signout",
                    onpress: () async {
                      PopupDialog.showPopupDilog(context, () async {
                        // await FirebaseAuth.instance.signOut();
                        GoogleSignInProvider googleSignInProvider =
                            GoogleSignInProvider();
                        await googleSignInProvider.logout();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Signin()));
                        print("logingout");
                      }, "Signout", "Do you want to signout ? ", "Signout");
                    },
                    bicon: Icon(Icons.logout_sharp),
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default show a loading spinner.
        return Center(
            child: Lottie.asset("assets/animation/loadingwhitec.json",
                width: size.width * 0.08));
      },
    );
  }

  loaddata() {
    fstatus = LocalDbHandeler.getFsecureStatus();
    setState(() {});
  }
}
