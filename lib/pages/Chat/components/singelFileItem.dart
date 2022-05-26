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

class SingelFileItem extends StatefulWidget {
  final MsgModel msgModel;
  final Color pcolor;

  SingelFileItem({Key? key, required this.msgModel, required this.pcolor})
      : super(key: key);

  @override
  _SingelFileItemState createState() => _SingelFileItemState();
}

class _SingelFileItemState extends State<SingelFileItem> {
  bool isdownloading = false;

  bool isdownload = false;

  String path = " ";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          color: widget.pcolor,
          child: ListTile(
            leading: Icon(
              Icons.file_present_outlined,
            ),
            title: Text(widget.msgModel.fname),
            trailing: isdownloading
                ? Lottie.asset("assets/animation/loadingwhitec.json",
                    width: size.width * 0.08)
                : isdownload
                    ? GestureDetector(
                        onTap: () {
                          // final pm = pathlist.firstWhere(
                          //     (element) => element.id == msgModel.id);

                          // print(pathlist.length.toString() +
                          //     "------------------");
                          OpenFile.open(path);
                        },
                        child: Icon(Icons.remove_red_eye_outlined))
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
