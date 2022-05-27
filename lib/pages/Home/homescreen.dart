import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/pages/Chat/chat_tab.dart';
import 'package:securemsg/pages/FriendReq/friendreq.dart';
import 'package:securemsg/pages/Friends/friend_tab.dart';

import 'package:securemsg/pages/sign_in_up/signin.dart';
import 'package:securemsg/service/auth/google/GoogleSignAuth.dart';
import 'package:securemsg/service/local/localdb_handeler.dart';
import 'package:securemsg/ui_components/popup_dilog.dart';

import 'components/drawer.dart';

class Homescreen extends StatefulWidget {
  final int index;

  const Homescreen({Key? key, this.index = 1}) : super(key: key);
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;

  int _selectedIndex = 0;
  int fecurestatus = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> _widgetOptions = <Widget>[ChatTab(), FirendTab()];
    return WillPopScope(
      onWillPop: () {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
          final snack = SnackBar(
            content: Text('Press Back button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return Future<bool>.value(false);
        } else {
          return Future<bool>.value(true);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MenuDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: klightbackgoundcolor,
          shadowColor: klightbackgoundcolor,
          elevation: 0,
          leading: GestureDetector(
              onTap: () async {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Icon(
                LineIcons.bars,
                size: size.width * 0.1,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FriendReqlist()));
                },
                icon: Badge(
                    badgeContent: Text(' '),
                    child: Icon(
                      LineIcons.userFriends,
                      color: kdefualtfontcolor,
                      size: size.width * 0.1,
                    )),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Container(
              color: kprimaryColordark,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  backgroundColor: kprimaryColordark,
                  rippleColor: kprimaryColor,
                  hoverColor: kmenucolor,
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 300),
                  tabBackgroundColor: kmenucolor.withOpacity(0.7),
                  color: Colors.black,
                  tabs: [
                    GButton(
                      textColor: kdefualtfontcolor,
                      iconColor: kdefualtfontcolor,
                      icon: LineIcons.rocketChat,
                      text: 'Chat Box',
                      iconActiveColor: kdefualtfontcolor,
                    ),
                    GButton(
                      textColor: kdefualtfontcolor,
                      iconColor: kdefualtfontcolor,
                      icon: Icons.people_alt_sharp,
                      text: 'Firends',
                      iconActiveColor: kdefualtfontcolor,
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
