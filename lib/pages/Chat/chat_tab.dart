import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/pages/Chat/components/chatList.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';

class ChatTab extends StatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  late Future<int> futureData;
  @override
  void initState() {
    futureData = FireDBhandeler.checkfiledstatus(
        "users/" + FireDBhandeler.user!.uid + "/" + FireDBhandeler.chatboxpath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: klightbackgoundcolor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: FutureBuilder(
              future: futureData,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  int data = snapshot.data as int;
                  print(data);
                  if (data == 0) {
                    return ChatList();
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
                                "assets/animation/nochatmsg.json",
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
          ),
        ));
  }
}
