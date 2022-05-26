import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securemsg/service/validater/date.dart';
import 'package:securemsg/models/FrqModel.dart';
import 'package:securemsg/ui_components/tots.dart';

class FriendReqlist extends StatefulWidget {
  const FriendReqlist({
    Key? key,
  }) : super(key: key);

  @override
  _FriendReqlistState createState() => _FriendReqlistState();
}

class _FriendReqlistState extends State<FriendReqlist> {
  late Future<List<FrqModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = FireDBhandeler.getFriendRq();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: klightbackgoundcolor,
      appBar: AppBar(
        backgroundColor: klightbackgoundcolor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Friend Requests",
          style: TextStyle(fontSize: size.width * 0.06),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<FrqModel> data = snapshot.data as List<FrqModel>;
              print(data);

              if (data.isNotEmpty) {
                return Container(
                    child: ListView.builder(
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
                                            "assets/icons/accountdark.png")
                                        // child: Image.network(
                                        //   fiximagelink + data[indext].imgname,
                                        //   width: size.width * 0.175,
                                        // ),
                                        )),
                                title: Text(
                                  data[indext].email,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: kdefualtfontcolor.withOpacity(0.9),
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.037),
                                ),
                                subtitle: Row(children: [
                                  // Icon(Icons.email_outlined),
                                  // Text(" " + data[indext].email,
                                  //     style: TextStyle(
                                  //         color:
                                  //             kdefualtfontcolor.withOpacity(0.7))),

                                  Expanded(
                                    child: Text(data[indext].datetime,
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
                                      onPressed: () async {
                                        int res =
                                            await FireDBhandeler.addFriendRq(
                                                FrqModel(
                                                    status: 0,
                                                    id: data[indext].id,
                                                    email: data[indext].email,
                                                    name: data[indext].name,
                                                    datetime:
                                                        Date.getDatetimenow()));
                                        if (res == 1) {
                                          Customtost.commontost(
                                              "Added", Colors.indigoAccent);
                                        } else {
                                          Customtost.commontost("Adding failed",
                                              Colors.redAccent);
                                        }

                                        reloaddata();
                                      },
                                      icon: Icon(Icons.check),
                                      color: kdefualtfontcolor.withOpacity(0.9),
                                      iconSize: size.width * 0.08,
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        int res =
                                            await FireDBhandeler.deletedoc(
                                                data[indext].email,
                                                FireDBhandeler.mainUserpath +
                                                    FireDBhandeler.rqinboxpath);
                                        Customtost.commontost(
                                            "Deleted", Colors.redAccent);
                                        reloaddata();
                                      },
                                      icon: Icon(Icons.close),
                                      color: kdefualtfontcolor.withOpacity(0.7),
                                      iconSize: size.width * 0.08,
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
                            bottom: size.height * 0.02,
                            left: size.width * 0.035),
                        child: Text(
                          "You have no friend Requests!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kdefualtfontcolor.withOpacity(0.8),
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        child: Lottie.asset(
                            "assets/animation/sadfacewhite.json",
                            width: size.width * 0.8),
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
      ),
    );
  }

  reloaddata() {
    setState(() {
      futureData = FireDBhandeler.getFriendRq();
    });
  }
}
