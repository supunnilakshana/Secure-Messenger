import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/pages/Friends/friendlist.dart';
import 'package:securemsg/pages/Friends/friensreachres.dart';
import 'package:securemsg/ui_components/roundedtextFiled.dart';

class FirendTab extends StatefulWidget {
  const FirendTab({
    Key? key,
  }) : super(key: key);

  @override
  _FirendTabState createState() => _FirendTabState();
}

class _FirendTabState extends State<FirendTab> {
  ScrollController _scrollController = ScrollController();
  String stext = "";
  bool issearch = false;
  int val = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black.withOpacity(0.89),
      child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
                child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.005,
                ),
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedInput(
                        onchange: (text) {
                          setState(() {
                            issearch = false;
                          });
                          if (text == "") {
                            setState(() {
                              issearch = false;
                            });
                          }
                          setState(() {
                            stext = text;
                          });
                          print("Search text -------" + stext);
                        },
                        valid: (text) {},
                        save: (text) {},
                        hintText: "Search new friends...",
                        icon: LineIcons.search,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.01),
                        child: Container(
                            decoration: BoxDecoration(
                                // color: kprimarylightcolor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(size.width * 0.05))),
                            width: size.width * 0.15,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: size.height * 0.008),
                              child: IconButton(
                                icon: Icon(
                                  LineIcons.searchengin,
                                  color: kprimaryColor,
                                  size: size.width * 0.1,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    if (stext != "") {
                                      setState(() {
                                        issearch = true;
                                      });
                                    } else {
                                      setState(() {
                                        issearch = false;
                                      });
                                    }
                                  });
                                },
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                issearch
                    ? Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: size.height * 0.02,
                                  left: size.width * 0.035),
                              child: Text(
                                "Search results...",
                                style: TextStyle(
                                    color: kdefualtfontcolor.withOpacity(0.8),
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            FirendSearchRes(svalue: stext)
                          ],
                        ))
                    : SizedBox(height: size.height * 0),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Friendlist()
              ],
            ))
          ]),
    );
  }
}
