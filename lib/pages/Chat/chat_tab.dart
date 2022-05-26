import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/pages/Chat/components/chatList.dart';

class ChatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: klightbackgoundcolor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ChatList(),
          ),
        ));
  }
}
