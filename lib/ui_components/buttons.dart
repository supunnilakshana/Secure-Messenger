import 'package:flutter/material.dart';
import 'package:securemsg/constants_data/ui_constants.dart';

//icon
class Iconbutton extends StatelessWidget {
  final Color color;
  final Color textcolor;
  final String text;
  final double pleft;
  final double pright;
  final double ptop;
  final double pbottom;
  final bool disabled;
  final double fontsize;
  final Function onpress;
  final Icon bicon;
  const Iconbutton({
    this.color = kprimaryColor,
    this.textcolor = kprimarylightcolor,
    this.text = "Button",
    this.pleft = 15,
    this.pright = 15,
    this.ptop = 10,
    this.pbottom = 10,
    this.disabled = false,
    required this.bicon,
    Key? key,
    required this.onpress,
    this.fontsize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onpress();
      },
      icon: bicon,
      label: Text(
        text,
        style: TextStyle(color: textcolor, fontSize: fontsize),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(
            left: pleft, right: pright, top: ptop, bottom: pbottom)),
        backgroundColor: MaterialStateProperty.all<Color>(kprimaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    );
  }
}

//genral

class Genaralbutton extends StatelessWidget {
  final Color color;
  final Color textcolor;
  final String text;
  final double pleft;
  final double pright;
  final double ptop;
  final double pbottom;
  final Function onpress;
  final double fontsize;
  const Genaralbutton({
    this.color = kprimaryColor,
    this.textcolor = kprimarylightcolor,
    this.text = "Button",
    this.pleft = 15,
    this.pright = 15,
    this.ptop = 10,
    this.pbottom = 10,
    Key? key,
    required this.onpress,
    this.fontsize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onpress();
      },
      child: Text(
        text,
        style: TextStyle(color: textcolor, fontSize: fontsize),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(
            left: pleft, right: pright, top: ptop, bottom: pbottom)),
        backgroundColor: MaterialStateProperty.all<Color>(kprimaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    );
  }
}
