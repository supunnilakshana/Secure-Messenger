import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:securemsg/constants_data/init_constansdata.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/models/keymodel.dart';
import 'package:securemsg/models/msgModel.dart';
import 'package:securemsg/pages/Chat/components/singelFileItem.dart';
import 'package:securemsg/pages/Chat/components/singelImgItem.dart';
import 'package:securemsg/pages/Chat/components/singelMsg.dart';
import 'package:securemsg/pages/Home/homescreen.dart';
import 'package:securemsg/service/encryption/fille_encrypt.dart';
import 'package:securemsg/service/encryption/message_encrypt.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securemsg/service/uploader/file_upload.dart';
import 'package:securemsg/service/validater/date.dart';
import 'package:securemsg/models/FrqModel.dart';
import 'package:securemsg/ui_components/popup_dilog.dart';
import 'package:securemsg/ui_components/roundedtextFiled.dart';
import 'package:path/path.dart' as p;
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
  bool isdeleing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController mobileNocon = TextEditingController();
  TextEditingController messegecon = TextEditingController();
  ScrollController _scrollController = ScrollController();
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

  bool isdownloading = false;
  bool isdownload = false;
  int nochat = 0;
  List<PathModel> pathlist = [];
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
                  onTap: () async {
                    if (_scrollController.hasClients) {
                      print("has------------------");
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  },
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
                  onTap: () async {
                    PopupDialog.showPopupdelete(
                        context, "Are you sure to delete this chat", () async {
                      isdeleing = true;
                      setState(() {});
                      int res = await FireDBhandeler.deletefiled(
                          FireDBhandeler.mainUserpathRdb +
                              FireDBhandeler.chatboxpath +
                              '/' +
                              widget.rid);
                      loaddata();
                      if (res == 0) {
                        await FireDBhandeler.deletefiled(
                            FireDBhandeler.mainUserpathRdb +
                                FireDBhandeler.keyboxpath +
                                '/' +
                                widget.rid);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Homescreen()));
                        Customtost.commontost(
                            "Deleted", Colors.deepPurpleAccent);
                      } else {
                        Customtost.commontost(
                            "Deleting failed", Colors.redAccent);
                        isdeleing = false;
                        setState(() {});
                      }
                    });
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
          body: isdeleing
              ? Center(
                  child: Lottie.asset(
                      "assets/animation/floadingwhitec.json.json",
                      width: size.width * 0.1),
                )
              : Stack(
                  children: [
                    Container(
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
                                            final myMessages = Map<dynamic,
                                                dynamic>.from((snapshot.data!
                                                        as DatabaseEvent)
                                                    .snapshot
                                                    .value
                                                as Map<dynamic, dynamic>);

                                            // print(myMessages);
                                            MsgModel mModel;

                                            myMessages.forEach((key, value) {
                                              // msgList = [];
                                              // print(value);
                                              Map<dynamic, dynamic> map = value
                                                  as Map<dynamic, dynamic>;
                                              mModel = MsgModel.fromMap(map);
                                              if (msgList.contains(mModel.id) ==
                                                  false) {
                                                msgList.add(mModel);
                                              }
                                            });
                                            msgList.sort((b, a) => b.datetimeid
                                                .compareTo(a.datetimeid));
                                          }
                                          if (msgList.isNotEmpty) {
                                            return ListView.builder(
                                                controller: _scrollController,
                                                // physics: ClampingScrollPhysics(),
                                                // keyboardDismissBehavior:
                                                //     ScrollViewKeyboardDismissBehavior
                                                //         .onDrag,
                                                itemCount: msgList.length,
                                                itemBuilder: (context, indext) {
                                                  if (msgList[indext]
                                                          .sendemail ==
                                                      FireDBhandeler
                                                          .user!.email!) {
                                                    if (msgList[indext]
                                                            .msgtype ==
                                                        "file") {
                                                      String defilepath =
                                                          "no--";
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            top: size.height *
                                                                0.01,
                                                            left: size.width *
                                                                0.25,
                                                            right: 8),
                                                        child: SingelFileItem(
                                                            msgModel:
                                                                msgList[indext],
                                                            pcolor:
                                                                kprimaryColor),
                                                      );
                                                    } else if (msgList[indext]
                                                            .msgtype ==
                                                        "tmsg") {
                                                      return SingelMsg(
                                                        mcolor: kprimaryColor,
                                                        msgModel:
                                                            msgList[indext],
                                                        align:
                                                            CrossAxisAlignment
                                                                .end,
                                                      );
                                                    } else if (msgList[indext]
                                                            .msgtype ==
                                                        "img") {
                                                      return SingelImgItem(
                                                          align:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          msgModel:
                                                              msgList[indext],
                                                          pcolor: kprimaryColor,
                                                          pleft:
                                                              size.width * 0.25,
                                                          pright: size.width *
                                                              0.03);
                                                    } else {
                                                      return Container();
                                                    }
                                                  } else {
                                                    if (msgList[indext]
                                                            .msgtype ==
                                                        "file") {
                                                      String defilepath = "";
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            top: size.height *
                                                                0.01,
                                                            left: 8,
                                                            right: size.width *
                                                                0.25),
                                                        child: SingelFileItem(
                                                            msgModel:
                                                                msgList[indext],
                                                            pcolor:
                                                                kprimaryColordark),
                                                      );
                                                    } else if (msgList[indext]
                                                            .msgtype ==
                                                        "tmsg") {
                                                      return SingelMsg(
                                                        mcolor:
                                                            kprimaryColordark,
                                                        msgModel:
                                                            msgList[indext],
                                                        align:
                                                            CrossAxisAlignment
                                                                .start,
                                                      );
                                                    } else if (msgList[indext]
                                                            .msgtype ==
                                                        "img") {
                                                      return SingelImgItem(
                                                          align:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          msgModel:
                                                              msgList[indext],
                                                          pcolor: kprimaryColor,
                                                          pleft:
                                                              size.width * 0.03,
                                                          pright: size.width *
                                                              0.25);
                                                    } else {
                                                      return Container();
                                                    }
                                                  }
                                                });
                                          } else {
                                            return Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child:
                                                      Text("Start a new chat"),
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
                              child: Column(
                                children: [
                                  isfileload
                                      ? isimg
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                color: kprimaryColordark,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: isfilesending
                                                            ? Lottie.asset(
                                                                "assets/animation/filesuploading.json",
                                                                width:
                                                                    size.width *
                                                                        0.1)
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  isfileload =
                                                                      false;
                                                                  isfilesending =
                                                                      false;
                                                                  isimg = false;
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Icon(Icons
                                                                    .close)),
                                                      ),
                                                      Container(
                                                        // width: size.width * 0.6,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          child: Image.file(
                                                            sendfile!,
                                                            // height: size.height * 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(fileName),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0)),
                                                color: kprimaryColordark,
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.file_present_outlined,
                                                  ),
                                                  title: Text(fileName),
                                                  trailing: isfilesending
                                                      ? Lottie.asset(
                                                          "assets/animation/filesuploading.json",
                                                          width:
                                                              size.width * 0.1)
                                                      : GestureDetector(
                                                          onTap: () {
                                                            isfileload = false;
                                                            isfilesending =
                                                                false;
                                                            isimg = false;
                                                            setState(() {});
                                                          },
                                                          child: Icon(
                                                              Icons.close)),
                                                ),
                                              ),
                                            )
                                      : Container(),
                                  GestureDetector(
                                    onTap: () {
                                      setscroll();
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: RoundedInputWithControll(
                                              textinput:
                                                  TextInputType.multiline,
                                              controller: messegecon,
                                              icon: Icons.chat_rounded,
                                              onchange: (text) {
                                                // message = text;
                                                setscroll();
                                              },
                                              valid: (text) {
                                                return null;
                                              },
                                              save: (text) {}),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.01,
                                              bottom: size.height * 0.015),
                                          child: GestureDetector(
                                            onTap: () {
                                              _chooeseFile();
                                            },
                                            child: Icon(
                                              Icons.attachment,
                                              color: kdefualtfontcolor
                                                  .withOpacity(0.8),
                                              size: size.width * 0.08,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.01,
                                              bottom: size.height * 0.015),
                                          child: GestureDetector(
                                            onTap: () {
                                              _showPicker(context);
                                            },
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              color: kdefualtfontcolor
                                                  .withOpacity(0.8),
                                              size: size.width * 0.06,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.01,
                                              bottom: size.height * 0.02),
                                          child: IconButton(
                                            color:
                                                kprimaryColor.withOpacity(0.95),
                                            icon: Icon(
                                              Icons.send_rounded,
                                              color: kprimaryColor
                                                  .withOpacity(0.95),
                                              size: size.width * 0.1,
                                            ),
                                            onPressed: isfilesending
                                                ? () {
                                                    setscroll();
                                                    Customtost.commontost(
                                                        "file sending..",
                                                        kprimaryColor);
                                                  }
                                                : () async {
                                                    setscroll();
                                                    // print(msgList.length);
                                                    print("pressed");

                                                    if (isfileload) {
                                                      setState(() {
                                                        isfilesending = true;
                                                      });
                                                      print("press");
                                                      EncryptedItem enitem =
                                                          await CryptoEncrpt
                                                              .encryptFile(
                                                                  sendfile!);
                                                      final extensionEn =
                                                          p.extension(
                                                              enitem.file.path);

                                                      print(extensionEn);
                                                      String id = FireDBhandeler
                                                              .user!.uid +
                                                          Date.getDateTimeId();
                                                      String vlink =
                                                          await FileUploader
                                                              .uploadData(
                                                                  enitem.file,
                                                                  id +
                                                                      extensionEn);
                                                      print(vlink);

                                                      if (vlink != "false") {
                                                        Keymodel keymodel = Keymodel(
                                                            id: id,
                                                            key: enitem.key,
                                                            addeddate: Date
                                                                .getDatetimenow(),
                                                            extesion:
                                                                fileExtesnsion);

                                                        MsgModel modelM = MsgModel(
                                                            fname: fileName,
                                                            id: id,
                                                            sendemail:
                                                                FireDBhandeler
                                                                    .user!
                                                                    .email!,
                                                            reciveemail:
                                                                widget.email,
                                                            message: vlink,
                                                            msgtype: mesgtype,
                                                            datetime: Date
                                                                .getDatetimenow(),
                                                            datetimeid: Date
                                                                .getDateTimeId(),
                                                            sendid:
                                                                FireDBhandeler
                                                                    .user!.uid,
                                                            reciveid:
                                                                widget.rid);
                                                        int res1 =
                                                            await FireDBhandeler
                                                                .sendKey(modelM,
                                                                    keymodel);
                                                        int res2 =
                                                            await FireDBhandeler
                                                                .sendMsgs(
                                                                    modelM);
                                                        if (res2 == 1 &&
                                                            res2 == 1) {
                                                          isfileload = false;
                                                          isfilesending = false;
                                                          isimg = false;
                                                          setState(() {});
                                                          loaddata();
                                                          setscroll();
                                                        } else {
                                                          setState(() {
                                                            isfilesending =
                                                                false;
                                                          });
                                                          Customtost.commontost(
                                                              "Sending failed",
                                                              Colors.redAccent);
                                                        }
                                                      } else {
                                                        setState(() {
                                                          isfilesending = false;
                                                        });
                                                        Customtost.commontost(
                                                            "Sending failed",
                                                            Colors.redAccent);
                                                      }
                                                    } else {
                                                      if (messegecon
                                                          .text.isNotEmpty) {
                                                        final id = FireDBhandeler
                                                                .user!.uid +
                                                            Date.getDateTimeId();
                                                        EnText enText =
                                                            CryptoEncrpt
                                                                .ecryptText(
                                                                    messegecon
                                                                        .text);
                                                        Keymodel keymodel =
                                                            Keymodel(
                                                                id: id,
                                                                key: enText.key,
                                                                addeddate: Date
                                                                    .getDatetimenow(),
                                                                extesion:
                                                                    "tmsg");

                                                        MsgModel modelM = MsgModel(
                                                            id: id,
                                                            sendemail:
                                                                FireDBhandeler
                                                                    .user!
                                                                    .email!,
                                                            reciveemail:
                                                                widget.email,
                                                            message: enText.msg,
                                                            msgtype: "tmsg",
                                                            datetime: Date
                                                                .getDatetimenow(),
                                                            datetimeid: Date
                                                                .getDateTimeId(),
                                                            sendid:
                                                                FireDBhandeler
                                                                    .user!.uid,
                                                            reciveid:
                                                                widget.rid);
                                                        await FireDBhandeler
                                                            .sendKey(modelM,
                                                                keymodel);
                                                        await FireDBhandeler
                                                            .sendMsgs(modelM);
                                                        print("done");
                                                        nochat = 1;
                                                        setState(() {});
                                                        messegecon.clear();
                                                        loaddata();
                                                        setscroll();
                                                      }
                                                    }
                                                    if (_formKey.currentState!
                                                        .validate()) {}
                                                  },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
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

  File? sendfile;
  String fileExtesnsion = "";
  String fileName = "";
  bool isfileload = false;
  bool isfilesending = false;
  bool isimg = false;
  String mesgtype = "file";

  _chooeseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        sendfile = file;

        final path = file.path;
        print(path);
        final extension = p.extension(path);
        fileExtesnsion = extension;
        mesgtype = "file";
        print(extension);
        fileName = path.split('/').last;

        isfileload = true;
        print("okkkkkkkkkkkk");

        // widget.onimgfileChanged(base64Image);
      });
    } else {
      // User canceled the picker
    }
  }

  XFile? imgfile;
  final ImagePicker _picker = ImagePicker();
  _imgFromGallery() async {
    XFile? img =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 65);

    if (img != null) {
      setState(() {
        imgfile = img;
        sendfile = File(imgfile!.path);
        final path = imgfile!.path;
        print(path);
        final extension = p.extension(path);
        fileExtesnsion = extension;
        mesgtype = "img";
        print(extension);
        fileName = path.split('/').last;
        isfileload = true;
        isimg = true;
        print("okkkkkkkkkkkk");

        // widget.onimgfileChanged(base64Image);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library_outlined),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.camera_alt_outlined),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    XFile? img =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (img != null) {
      setState(() {
        imgfile = img;
        sendfile = File(imgfile!.path);
        final path = imgfile!.path;
        print(path);
        final extension = p.extension(path);
        fileExtesnsion = extension;
        mesgtype = "img";
        print(extension);
        fileName = path.split('/').last;
        isfileload = true;
        isimg = true;
        print("okkkkkkkkkkkk");

        // widget.onimgfileChanged(base64Image);
      });
    }
  }

  setscroll() {
    if (_scrollController.hasClients) {
      print("has------------------");
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}

class PathModel {
  final String id;
  final String path;

  PathModel({required this.id, required this.path});
}
