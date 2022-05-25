import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PopupDialog {
  static showPopupDilog(BuildContext context, Function actionFun, String titel,
      String description) {
    AwesomeDialog(
      aligment: Alignment.center,
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: titel,
      desc: description,
      btnCancelText: "No ",
      btnOkText: "Yes",
      btnCancelOnPress: () {},
      btnOkOnPress: actionFun,
    )..show();
  }

  static showPopupinfo(
      BuildContext context, String titel, String description, Size size) {
    Alert(
      context: context,
      type: AlertType.info,
      title: titel,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: size.width * 0.1,
        )
      ],
    ).show();
  }

  static showPopupwarning(BuildContext context, String titel,
      String description, Function() fun, String okbuttonlable, Size size) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: titel,
      desc: description,
      buttons: [
        DialogButton(
          color: Colors.redAccent,
          child: Text(
            okbuttonlable,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: fun,
          width: size.width * 0.1,
        ),
        DialogButton(
          color: Colors.blueGrey,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: size.width * 0.1,
        )
      ],
    ).show();
  }

  static showPopupcommon(BuildContext context, String titel, String description,
      Size size, AlertType type, Color color) {
    Alert(
      style: AlertStyle(
          animationType: AnimationType.fromBottom,
          titleStyle: TextStyle(color: color)),
      context: context,
      type: type,
      title: titel,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: size.width * 0.1,
        )
      ],
    ).show();
  }
}

























/*static Future<void> showMyDialog(BuildContext context, String titel,
      String description, Function actionFun) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titel),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes , did'),
              onPressed: () {
                /// actionFun();
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  animType: AnimType.LEFTSLIDE,
                  title: 'Dialog Title',
                  desc: 'Dialog description here.............',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {},
                )..show();
              },
            ),
            TextButton(
              child: const Text('Not yet'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } */