import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securemsg/service/firebase_handeler/user_handeler.dart';
import 'package:securemsg/service/validater/date.dart';
import 'package:securemsg/test/test1.dart';
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
  bool ispressed = false;
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
                      itemBuilder: (context, indext) {
                        return Card(
                          color: kprimaryColordark,
                          child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                  child: Container(
                                      child: Image.asset(
                                          "assets/icons/accountdark.png"))),
                              title: Text(
                                data[indext],
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
                                      style: TextStyle(
                                          color: kdefualtfontcolor
                                              .withOpacity(0.7))),
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
                                            int res1 = await FireDBhandeler
                                                .sendFriendRq(
                                                    FrqModel(
                                                        id: Date
                                                            .getDateTimeId(),
                                                        email: FireDBhandeler
                                                            .user!.email!,
                                                        name: FireDBhandeler
                                                            .user!.displayName!,
                                                        datetime: Date
                                                            .getDatetimenow()),
                                                    data[indext]);
                                            int res2 = await FireDBhandeler
                                                .saveFriendRq(
                                              FrqModel(
                                                  id: Date.getDateTimeId(),
                                                  email: FireDBhandeler
                                                      .user!.email!,
                                                  name: FireDBhandeler
                                                      .user!.displayName!,
                                                  datetime:
                                                      Date.getDatetimenow()),
                                            );
                                            if (res2 == 1 && res1 == 1) {
                                              Customtost.commontost(
                                                  "Request sent",
                                                  Colors.indigoAccent);
                                            } else {
                                              Customtost.commontost(
                                                  "Reques failed",
                                                  Colors.redAccent);
                                              ispressed = false;
                                              setState(() {});
                                            }

                                            // reloaddata();
                                          },
                                    icon: Icon(ispressed
                                        ? Icons.check_circle
                                        : Icons.person_add),
                                    color: kdefualtfontcolor.withOpacity(0.5),
                                    iconSize: size.width * 0.07,
                                  )
                                ],
                              )),
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
