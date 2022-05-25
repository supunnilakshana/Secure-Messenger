import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';

class ChatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: klightbackgoundcolor,
        body: Container(
          child: Lottie.asset("assets/animation/loadingwhitec.json",
              width: size.width * 0.6),
        ));
  }
}
