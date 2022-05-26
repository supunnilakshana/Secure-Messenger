import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/models/keymodel.dart';
import 'package:securemsg/models/msgModel.dart';
import 'package:securemsg/service/encryption/message_encrypt.dart';
import 'package:securemsg/service/firebase_handeler/firedatabasehadeler.dart';

class SingelMsg extends StatefulWidget {
  const SingelMsg({
    Key? key,
    required this.msgModel,
    required this.mcolor,
    required this.align,
  }) : super(key: key);

  final MsgModel msgModel;
  final Color mcolor;
  final CrossAxisAlignment align;

  @override
  _SingelMsgState createState() => _SingelMsgState();
}

class _SingelMsgState extends State<SingelMsg> {
  late Future<Keymodel> futureData;
  @override
  void initState() {
    futureData = FireDBhandeler.getKey(widget.msgModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      color: klightbackgoundcolor,
      elevation: 0,
      child: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("has........................");
            Keymodel data = snapshot.data as Keymodel;
            String demsg;

            if (data.id != "false") {
              print("have key");
              demsg = CryptoEncrpt.decryptText(
                  EnText(key: data.key, msg: widget.msgModel.message));
            } else {
              demsg = widget.msgModel.message;
            }
            print(data.id + "-------------------------");
            print(demsg);
            // print(data.addeddate);
            return Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.1, right: size.width * 0.05),
              child: Column(
                crossAxisAlignment: widget.align,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: widget.mcolor,
                        borderRadius: BorderRadius.circular(28)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        demsg,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 100,
                        style: TextStyle(
                          color: kdefualtfontcolor,
                          fontSize: size.width * 0.04,
                        ),
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
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default show a loading spinner.
          return Center(
              child: Lottie.asset("assets/animation/loadingwhitec.json",
                  width: size.height * 0.06));
        },
      ),
    );
  }
}
