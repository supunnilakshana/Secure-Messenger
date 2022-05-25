import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/pages/Chat/components/singel_chat.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securemsg/test/test1.dart';
import 'package:securemsg/ui_components/tots.dart';

class Friendlist extends StatefulWidget {
  const Friendlist({
    Key? key,
  }) : super(key: key);

  @override
  _FriendlistState createState() => _FriendlistState();
}

class _FriendlistState extends State<Friendlist> {
  late Future<List<FrqModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = FireDBhandeler.getFriends();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          FutureBuilder(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<FrqModel> data = snapshot.data as List<FrqModel>;
                print(data);

                if (data.isNotEmpty) {
                  return Container(
                      child: ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, indext) {
                            print(data[indext].name);
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
                                    data[indext].name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: kdefualtfontcolor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.037),
                                  ),
                                  subtitle: Row(children: [
                                    Icon(Icons.email_outlined),
                                    Expanded(
                                      child: Text(" " + data[indext].email,
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
                                          // reloaddata();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingelChatScreen()));
                                        },
                                        icon: Icon(Icons.message_rounded),
                                        color:
                                            kdefualtfontcolor.withOpacity(0.8),
                                        iconSize: size.width * 0.08,
                                      ),
                                      // IconButton(
                                      //   onPressed: () async {
                                      //     reloaddata();
                                      //   },
                                      //   icon: Icon(Icons.close),
                                      //   color: Colors.black.withOpacity(0.5),
                                      //   iconSize: size.width * 0.07,
                                      // )
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
                            "You have no friends!!",
                            style: TextStyle(
                                color: kdefualtfontcolor.withOpacity(0.8),
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          child: Lottie.asset(
                              "assets/animation/nofriendwhite.json",
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
        ],
      ),
    );
  }

  reloaddata() {
    setState(() {
      futureData = FireDBhandeler.getFriends();
    });
  }
}
