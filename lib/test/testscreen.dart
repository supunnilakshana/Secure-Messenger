import 'package:flutter/material.dart';
import 'package:securemsg/service/auth/emailverification.dart';
import 'package:securemsg/service/encryption/keys.dart';
import 'package:securemsg/service/uploader/file_upload.dart';

class Test1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Emailverification.sendcode("supunnikz@gmail.com", "code");
        },
      ),
    );
  }
}
