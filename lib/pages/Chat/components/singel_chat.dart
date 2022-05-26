import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/models/keymodel.dart';
import 'package:securemsg/models/msgModel.dart';
import 'package:securemsg/service/encryption/message_encrypt.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securemsg/service/validater/date.dart';
import 'package:securemsg/test/test1.dart';
import 'package:securemsg/ui_components/popup_dilog.dart';
import 'package:securemsg/ui_components/roundedtextFiled.dart';
import 'package:securemsg/ui_components/tots.dart';

class SingelChatScreen extends StatefulWidget {
  final bool isnew;
  final String email;
  final String rid;
  final String name;

  const SingelChatScreen({
    Key? key,
    this.isnew = true,
    required this.email,
    required this.rid,
    required this.name,
  }) : super(key: key);
  @override
  _SingelChatScreenState createState() => _SingelChatScreenState();
}

class _SingelChatScreenState extends State<SingelChatScreen> {
  // final dbRef = FirebaseDatabase.instance.ref(
  //     "users/" + FireDBhandeler.user!.uid + "/" + "chatbox" + "/" + widget.rid);
  bool isfirsttap = true;
  String sends = "f";
  String titel = "";
  String message = " ";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController mobileNocon = TextEditingController();
  TextEditingController messegecon = TextEditingController();
  bool isnewchat = false;
  late Future<int> futureData;
  int chatcreate = 0;

  settitel() {
    if (widget.name == "") {
      titel = widget.email;
    } else {
      titel = widget.name;
    }
    setState(() {});
  }

  @override
  void initState() {
    settitel();
    futureData = FireDBhandeler.checkfiledstatus("users/" +
        FireDBhandeler.user!.uid +
        "/" +
        "chatbox" +
        "/" +
        widget.rid);
    setState(() {});
    super.initState();
  }

  int nochat = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // backgroundColor: Colors.,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  // Navigator.pop(context, true);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                )),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    titel,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(
                  right: size.width * 0.06,
                ),
                child: GestureDetector(
                  onTap: () async {},
                  child: LineIcon.phone(
                    size: size.width * 0.07,
                    color: kdefualtfontcolor.withOpacity(0.9),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: size.width * 0.06,
                ),
                child: GestureDetector(
                  onTap: () {
                    // PopupDialog.showPopupdelete(
                    //     context, "Are you sure to delete this chat",
                    //     () async {
                    //   await LocalDbHandeler.clearallmsg(widget.mobile);
                    //   await LocalDbHandeler.clearachat(widget.mobile);
                    //   Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => HomeScreen()));
                    //   Customtost.delete();
                    // });
                  },
                  child: LineIcon.alternateTrash(
                    size: size.width * 0.07,
                    color: kdefualtfontcolor.withOpacity(0.9),
                  ),
                ),
              )
            ],
            backgroundColor: klightbackgoundcolor,
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: klightbackgoundcolor,
            ),
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  child: FutureBuilder(
                    future: futureData,
                    builder: (context, snapshot1) {
                      if (snapshot1.hasData) {
                        int data1 = snapshot1.data as int;
                        nochat = data1;
                        chatcreate = data1;
                        print(nochat);
                        if (nochat == 0) {
                          return StreamBuilder(
                            stream: FirebaseDatabase.instance
                                .ref("users/" +
                                    FireDBhandeler.user!.uid +
                                    "/" +
                                    "chatbox" +
                                    "/" +
                                    widget.rid)
                                .onValue,
                            builder: (context, snapshot) {
                              print("users/" +
                                  FireDBhandeler.user!.uid +
                                  "/" +
                                  "chatbox" +
                                  "/" +
                                  widget.rid);
                              List<MsgModel> msgList = [];
                              if (snapshot.hasData) {
                                // List<MsgModel> data =
                                //     snapshot.data as List<MsgModel>;
                                // print(data.length);
                                if (snapshot.data != null) {
                                  print("object");
                                  final myMessages = Map<dynamic, dynamic>.from(
                                      (snapshot.data! as DatabaseEvent)
                                          .snapshot
                                          .value as Map<dynamic, dynamic>);

                                  // print(myMessages);
                                  MsgModel mModel;

                                  myMessages.forEach((key, value) {
                                    // msgList = [];
                                    // print(value);
                                    Map<dynamic, dynamic> map =
                                        value as Map<dynamic, dynamic>;
                                    mModel = MsgModel.fromMap(map);
                                    if (msgList.contains(mModel.id) == false) {
                                      msgList.add(mModel);
                                    }
                                  });
                                  msgList.sort((b, a) =>
                                      b.datetimeid.compareTo(a.datetimeid));
                                }
                                if (msgList.isNotEmpty) {
                                  return ListView.builder(
                                      keyboardDismissBehavior:
                                          ScrollViewKeyboardDismissBehavior
                                              .onDrag,
                                      itemCount: msgList.length,
                                      itemBuilder: (context, indext) {
                                        if (msgList[indext].sendemail ==
                                            FireDBhandeler.user!.email!) {
                                          return Card(
                                            color: klightbackgoundcolor,
                                            elevation: 0,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.width * 0.1,
                                                  right: size.width * 0.05),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: kprimaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(28)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        msgList[indext].message,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 100,
                                                        style: TextStyle(
                                                          color:
                                                              kdefualtfontcolor,
                                                          fontSize:
                                                              size.width * 0.04,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.005),
                                                  Text(
                                                    msgList[indext].datetime,
                                                    style: TextStyle(
                                                      color: kdefualtfontcolor
                                                          .withOpacity(0.75),
                                                      fontSize:
                                                          size.width * 0.025,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Card(
                                            color: klightbackgoundcolor,
                                            elevation: 0,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.width * 0.05,
                                                  right: size.width * 0.1),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            kprimaryColordark,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(28)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        msgList[indext].message,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 100,
                                                        style: TextStyle(
                                                          color:
                                                              kdefualtfontcolor
                                                                  .withOpacity(
                                                                      0.9),
                                                          fontSize:
                                                              size.width * 0.04,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.005),
                                                  Text(
                                                    msgList[indext].datetime,
                                                    style: TextStyle(
                                                      color: kdefualtfontcolor
                                                          .withOpacity(0.75),
                                                      fontSize:
                                                          size.width * 0.025,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                } else {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Text("Start a new chat"),
                                      ),
                                    ),
                                  );
                                }
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
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text("Start a new chat"),
                              ),
                            ),
                          );
                        }
                      } else if (snapshot1.hasError) {
                        return Text("${snapshot1.error}");
                      }
                      // By default show a loading spinner.
                      return Center(
                          child: Lottie.asset(
                              "assets/animation/loadingwhitec.json",
                              width: size.height * 0.08));
                    },
                  ),
                )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RoundedInputWithControll(
                            controller: messegecon,
                            icon: Icons.chat_rounded,
                            onchange: (text) {
                              // message = text;
                            },
                            valid: (text) {
                              return null;
                            },
                            save: (text) {}),
                        Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.01,
                              bottom: size.height * 0.015),
                          child: Icon(
                            Icons.attachment,
                            color: kdefualtfontcolor.withOpacity(0.8),
                            size: size.width * 0.08,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.01,
                              bottom: size.height * 0.015),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: kdefualtfontcolor.withOpacity(0.8),
                            size: size.width * 0.06,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.01,
                              bottom: size.height * 0.02),
                          child: IconButton(
                            color: kprimaryColor.withOpacity(0.95),
                            icon: Icon(
                              Icons.send_rounded,
                              color: kprimaryColor.withOpacity(0.95),
                              size: size.width * 0.1,
                            ),
                            onPressed: () async {
                              // print(msgList.length);
                              print("pressed");
                              if (messegecon.text.isNotEmpty) {
                                final id = FireDBhandeler.user!.uid +
                                    Date.getDateTimeId();
                                EnText enText =
                                    CryptoEncrpt.ecryptText(messegecon.text);
                                Keymodel keymodel = Keymodel(
                                    id: id,
                                    key: enText.key,
                                    addeddate: Date.getDatetimenow(),
                                    extesion: "tmsg");

                                MsgModel modelM = MsgModel(
                                    id: id,
                                    sendemail: FireDBhandeler.user!.email!,
                                    reciveemail: widget.email,
                                    message: enText.msg,
                                    msgtype: "tmsg",
                                    datetime: Date.getDatetimenow(),
                                    datetimeid: Date.getDateTimeId(),
                                    sendid: FireDBhandeler.user!.uid,
                                    reciveid: widget.rid);
                                await FireDBhandeler.sendKey(modelM, keymodel);
                                await FireDBhandeler.sendMsgs(modelM);
                                print("done");
                                nochat = 1;
                                setState(() {});
                                messegecon.clear();
                                loaddata();
                              }
                              if (_formKey.currentState!.validate()) {}
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  loaddata() async {
    futureData = FireDBhandeler.checkfiledstatus("users/" +
        FireDBhandeler.user!.uid +
        "/" +
        "chatbox" +
        "/" +
        widget.rid);

    setState(() {});
    if (mounted) {
      setState(() {});
    }
  }
}
