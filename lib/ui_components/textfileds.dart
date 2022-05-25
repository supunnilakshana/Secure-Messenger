import 'package:flutter/material.dart';
import 'package:securemsg/service/validater/validate_handeler.dart';

////////////////// textfiled//////////////////////////////////
class Gtextformfiled extends StatelessWidget {
  final String label;
  final TextInputType keybordtype;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isenabel;

  final Function(String) onchange;
  final Function(String?) save;
  final String? Function(String?) valid;
  const Gtextformfiled({
    this.hintText = "Text",
    this.icon = Icons.person,
    required this.onchange,
    required this.valid,
    required this.save,
    Key? key,
    required this.controller,
    this.label = "Textfiled",
    this.keybordtype = TextInputType.text,
    this.isenabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // initialValue: "sdsd",
      enabled: isenabel,
      keyboardType: keybordtype,
      onChanged: onchange,
      onSaved: save,
      controller: controller,
      validator: valid,
      decoration: InputDecoration(
        icon: Icon(icon),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide:
              const BorderSide(color: Colors.deepPurpleAccent, width: 1.6),
        ),
        hintText: hintText,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }
}

////////////////// passwordfiled//////////////////////////////////
class Gpasswordformfiled extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextInputType textinput;
  final Function(String) onchange;
  final Function(String?) save;
  final bool isenabel;
  const Gpasswordformfiled({
    this.hintText = "Password",
    this.icon = Icons.person,
    required this.onchange,
    required this.save,
    this.textinput = TextInputType.text,
    Key? key,
    this.isenabel = true,
  }) : super(key: key);

  @override
  _GpasswordformfiledState createState() => _GpasswordformfiledState();
}

class _GpasswordformfiledState extends State<Gpasswordformfiled> {
  bool isHidepassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isHidepassword,
      validator: (text) {
        return Validater.signupPassword(text!);
      },
      onChanged: widget.onchange,
      onSaved: widget.save,
      //initialValue: '',
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide:
              const BorderSide(color: Colors.deepPurpleAccent, width: 1.6),
        ),
        labelText: widget.hintText,
        icon: Icon(widget.icon),
        suffixIcon:
            InkWell(onTap: _viewPassword, child: Icon(Icons.visibility)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }

  void _viewPassword() {
    if (isHidepassword == true) {
      isHidepassword = false;
    } else {
      isHidepassword = true;
    }
    setState(() {});
  }
}

///////////////////////////////np icon /////////////////////////////
///

class Gnoiconformfiled extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final int maxlines;
  final bool isenabel;
  final TextInputType textinput;
  final Function(String) onchange;
  final Function(String?) save;
  final String? Function(String?) valid;
  const Gnoiconformfiled({
    this.hintText = "Text",
    required this.onchange,
    required this.valid,
    required this.save,
    this.textinput = TextInputType.text,
    Key? key,
    required this.controller,
    this.label = "Textfiled",
    this.maxlines = 1,
    this.isenabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // initialValue: "sdsd",
      enabled: isenabel,
      onChanged: onchange,
      maxLines: maxlines,
      onSaved: save,
      controller: controller,
      validator: valid,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Colors.deepPurpleAccent, width: 1.6),
          borderRadius: BorderRadius.circular(100.0),
        ),
        hintText: hintText,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }
}
