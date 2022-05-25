import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ScreenErrorpage extends StatelessWidget {
  final String errorname;

  const ScreenErrorpage(
      {Key? key, this.errorname = "Screen error!!\n Please resize your screen"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.4,
            // child: Lottie.asset('assets/animation/screenerror.json'),
            child: Image.asset("assets/icons/screen_error.png"),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.08),
            child: Text(
              errorname,
              style: TextStyle(color: Colors.redAccent),
            ),
          )
        ],
      ),
    ));
  }
}
