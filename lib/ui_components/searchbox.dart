import 'package:flutter/material.dart';
import 'package:securemsg/constants_data/ui_constants.dart';
import 'package:securemsg/ui_components/roundedtextFiled.dart';

class Searchbox extends StatelessWidget {
  final String hinttext;
  final Function(String) onchange;
  final Function() onpress;

  const Searchbox(
      {Key? key,
      this.hinttext = "Search...",
      required this.onchange,
      required this.onpress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //  width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RoundedInput(
            onchange: onchange,
            valid: (text) {},
            save: (text) {},
            hintText: hinttext,
            icon: Icons.search_rounded,
          ),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.01),
            child: Container(
              child: IconButton(
                hoverColor: Colors.green,
                icon: Icon(
                  Icons.search_rounded,
                  color: kprimaryColor,
                  size: size.width * 0.025,
                ),
                onPressed: onpress,
              ),
            ),
          )
        ],
      ),
    );
  }
}
