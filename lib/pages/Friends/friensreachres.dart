import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securemsg/service/firebase_handeler/user_handeler.dart';
import 'package:securemsg/service/validater/date.dart';
import 'package:securemsg/models/FrqModel.dart';
import 'package:securemsg/ui_components/tots.dart';

class FirendSearchRes extends StatefulWidget {
  final String svalue;
  const FirendSearchRes({
    Key? key,
    required this.svalue,
  }) : super(key: key);

  @override
  _FirendSearchResState createState() => _FirendSearchResState();
}

class _FirendSearchResState extends State<FirendSearchRes> {
  late Future<List<String>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = UserdbHandeler.searchuser(widget.svalue);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> data = snapshot.data as List<String>;
            print("has data---------------" + data.length.toString());
            print(data);

            if (data.isNotEmpty) {
              return Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, indext) {
                        return GlobelUserItem(
                          data: data[indext],
                        );
                      }));
            } else {
              return Container(
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: size.height * 0.02, left: size.width * 0.035),
                      child: Text(
                        "You have no friends!!",
                        style: TextStyle(
                            color: kdefualtfontcolor.withOpacity(0.8),
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      child: Lottie.asset(
                          "assets/animation/noresultsearch.json",
                          width: size.width * 0.6),
                    )
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default show a loading spinner.
          return Center(
              child: Lottie.asset("assets/animation/loadingwhitec.json",
                  width: size.height * 0.12));
        },
      ),
    );
  }

  reloaddata() {
    setState(() {
      futureData = UserdbHandeler.searchuser(widget.svalue);
    });
  }
}

class GlobelUserItem extends StatefulWidget {
  GlobelUserItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String data;

  @override
  _GlobelUserItemState createState() => _GlobelUserItemState();
}

class _GlobelUserItemState extends State<GlobelUserItem> {
  bool ispressed = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      color: kprimaryColordark,
      child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
              child: Container(
                  child: Image.asset("assets/icons/accountdark.png"))),
          title: Text(
            widget.data,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: kdefualtfontcolor.withOpacity(0.95),
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.037),
          ),
          subtitle: Row(children: [
            Icon(Icons.person_pin),
            Expanded(
              child: Text("Secure Messenger User",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: kdefualtfontcolor.withOpacity(0.7))),
            ),
          ]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: ispressed
                    ? () {}
                    : () async {
                        ispressed = true;
                        setState(() {});

                        int res = await FireDBhandeler.checkdocstatus(
                            FireDBhandeler.mainUserpath +
                                FireDBhandeler.firendboxtpath,
                            widget.data);
                        if (res == 1) {
                          int res1 = await FireDBhandeler.sendFriendRq(
                              FrqModel(
                                  id: FireDBhandeler.user!.uid,
                                  email: FireDBhandeler.user!.email!,
                                  name: FireDBhandeler.user!.displayName!,
                                  datetime: Date.getDatetimenow()),
                              widget.data);
                          int res2 = await FireDBhandeler.saveFriendRq(
                            FrqModel(
                                id: FireDBhandeler.user!.uid,
                                email: FireDBhandeler.user!.email!,
                                name: FireDBhandeler.user!.displayName!,
                                datetime: Date.getDatetimenow()),
                          );
                          if (res2 == 1 && res1 == 1) {
                            Customtost.commontost(
                                "Request sent", Colors.indigoAccent);
                          } else {
                            Customtost.commontost(
                                "Request failed", Colors.redAccent);
                            ispressed = false;
                            setState(() {});
                          }
                        } else {
                          Customtost.commontost(
                              widget.data + " is already friend",
                              Colors.indigoAccent);
                          ispressed = false;
                          setState(() {});
                        }
                      },
                icon: Icon(ispressed ? Icons.check_circle : Icons.person_add),
                color: kdefualtfontcolor.withOpacity(0.5),
                iconSize: size.width * 0.07,
              )
            ],
          )),
    );
  }
}

// class Testwid extends StatefulWidget {
//   final String data;
//   final Function() reloaddata;

//   const Testwid({Key? key, required this.data, required this.reloaddata})
//       : super(key: key);

//   @override
//   _TestwidState createState() => _TestwidState();
// }

// class _TestwidState extends State<Testwid> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: kprimaryColordark,
//       child: Text("----"),
//     );
//   }
// }
