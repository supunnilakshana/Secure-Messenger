import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:securemsg/constants_data/init_constansdata.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/models/msgModel.dart';
import 'package:securemsg/service/encryption/message_encrypt.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securemsg/service/uploader/file_upload.dart';
import 'package:securemsg/service/validater/date.dart';

class SingelImgItem extends StatefulWidget {
  final MsgModel msgModel;
  final Color pcolor;
  final double pleft;
  final double pright;
  final CrossAxisAlignment align;

  SingelImgItem(
      {Key? key,
      required this.msgModel,
      required this.pcolor,
      required this.pleft,
      required this.pright,
      required this.align})
      : super(key: key);

  @override
  _SingelImgItemState createState() => _SingelImgItemState();
}

class _SingelImgItemState extends State<SingelImgItem> {
  bool isdownloading = false;

  bool isdownload = false;

  String path = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (isdownload) {
      return Padding(
        padding: EdgeInsets.only(
            top: size.height * 0.01, left: widget.pleft, right: widget.pright),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: widget.pcolor,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    OpenFile.open(path);
                  },
                  child: Container(
                    // width: size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.file(
                        File(path),
                        // height: size.height * 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.01,
                left: widget.pleft,
                right: widget.pright),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: widget.pcolor,
              child: ListTile(
                leading: Icon(
                  Icons.image_outlined,
                ),
                title: Text(widget.msgModel.fname),
                trailing: isdownloading
                    ? Lottie.asset("assets/animation/loadingwhitec.json",
                        width: size.width * 0.08)
                    : GestureDetector(
                        onTap: () async {
                          isdownload = false;
                          isdownloading = true;
                          setState(() {});
                          String downloadfilepath =
                              await FileUploader.downloadfile(
                                  widget.msgModel.message,
                                  Date.getDateTimeId() + enextenion);
                          final keymodel =
                              await FireDBhandeler.getKey(widget.msgModel);
                          File decryptfile = await CryptoEncrpt.decryptFile(
                              File(downloadfilepath),
                              keymodel.key,
                              keymodel.extesion);

                          path = decryptfile.path;
                          print(decryptfile.path +
                              "|||||||||||||||||||||||||||||");
                          // pathlist.add(PathModel(
                          //     id: widget.msgModel.id, path: decryptfile.path));
                          isdownload = true;
                          isdownloading = false;
                          setState(() {});
                        },
                        child: Icon(Icons.download_for_offline_outlined)),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            widget.msgModel.datetime,
            style: TextStyle(
              color: kdefualtfontcolor.withOpacity(0.75),
              fontSize: size.width * 0.025,
            ),
          )
        ],
      );
    }
  }
}
