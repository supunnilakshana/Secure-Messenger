import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/pages/Chat/components/singel_chat.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securemsg/models/FrqModel.dart';
import 'package:securemsg/ui_components/tots.dart';

class ChatList extends StatefulWidget {
  const ChatList({
    Key? key,
  }) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
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
            builder: (context, snapshot1) {
              if (snapshot1.hasData) {
                List<FrqModel> data = snapshot1.data as List<FrqModel>;
                print(data);
                List<String> chatkeyList = [];
                if (data.isNotEmpty) {
                  return StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .ref("users/" +
                            FireDBhandeler.user!.uid +
                            "/" +
                            "chatbox")
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final mydata = Map<dynamic, dynamic>.from(
                            (snapshot.data! as DatabaseEvent).snapshot.value
                                as Map<dynamic, dynamic>);
                        mydata.forEach((key, value) {
                          // msgList = [];
                          // print(value);

                          if (chatkeyList.contains(key) == false) {
                            chatkeyList.add(key);
                          }
                        });

                        return Container(
                            child: ListView.builder(
                                itemCount: chatkeyList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, indext) {
                                  FrqModel frqModel;
                                  if (chatkeyList.isNotEmpty) {
                                    String tempokey = chatkeyList[indext];
                                    frqModel = data.singleWhere(
                                        (element) => element.id == tempokey,
                                        orElse: () {
                                      return FrqModel(
                                          id: "false",
                                          email: "email",
                                          name: "name",
                                          datetime: "datetime");
                                    });
                                    if (frqModel.id != "false") {
                                      String titel;
                                      if (frqModel.name == "") {
                                        titel = frqModel.email.split('@').first;
                                      } else {
                                        titel = frqModel.name;
                                      }
                                      print(titel);
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingelChatScreen(
                                                        rid: frqModel.id,
                                                        email: frqModel.email,
                                                        name: frqModel.name,
                                                      )));
                                        },
                                        child: Card(
                                          color: kprimaryColordark,
                                          child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10.0),
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
                                                titel,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: kdefualtfontcolor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        size.width * 0.037),
                                              ),
                                              subtitle: Row(children: [
                                                Icon(Icons.email_outlined),
                                                Expanded(
                                                  child: Text(frqModel.email,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                          color:
                                                              kdefualtfontcolor
                                                                  .withOpacity(
                                                                      0.7))),
                                                ),
                                              ]),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // IconButton(
                                                  //   onPressed: () async {
                                                  //     // reloaddata();
                                                  //     Navigator.push(
                                                  //         context,
                                                  //         MaterialPageRoute(
                                                  //             builder: (context) =>
                                                  //                 SingelChatScreen(
                                                  //                   rid: frqModel
                                                  //                       .id,
                                                  //                   email: frqModel
                                                  //                       .email,
                                                  //                   name: frqModel
                                                  //                       .name,
                                                  //                 )));
                                                  //     print(data[indext].id);
                                                  //   },
                                                  //   icon: Icon(
                                                  //       Icons.message_rounded),
                                                  //   color: kdefualtfontcolor
                                                  //       .withOpacity(0.8),
                                                  //   iconSize: size.width * 0.08,
                                                  // ),
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
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return Container();
                                  }
                                }));
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
                      return Center(
                          child: Lottie.asset(
                              "assets/animation/loadingwhitec.json",
                              width: size.height * 0.08));
                    },
                  );
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
                            "You have no chats!!",
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
              } else if (snapshot1.hasError) {
                return Text("${snapshot1.error}");
              }
              // By default show a loading spinner.
              return Center(
                  child: Lottie.asset("assets/animation/loadingwhitec.json",
                      width: size.height * 0.08));
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
