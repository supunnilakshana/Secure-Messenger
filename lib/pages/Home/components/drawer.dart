import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/pages/sign_in_up/signin.dart';
import 'package:securemsg/service/auth/google/GoogleSignAuth.dart';
import 'package:securemsg/ui_components/buttons.dart';
import 'package:securemsg/ui_components/popup_dilog.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool isswitched = true;
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
              onChanged: (value) {
                isswitched = value;
                setState(() {
                  print(value);
                });
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
                }, "Signout", "Do you want to signout ? ");
              },
              bicon: Icon(Icons.logout_sharp),
            ),
          )
        ],
      ),
    );
  }
}
