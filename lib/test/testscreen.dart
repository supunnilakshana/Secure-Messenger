import 'package:flutter/material.dart';
import 'package:securemsg/service/encryption/keys.dart';
import 'package:securemsg/service/uploader/file_upload.dart';

class Test1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // String url =
          //     "https://firebasestorage.googleapis.com/v0/b/video-732b5.appspot.com/o/users%2Fsupunnilakshana1999%40gmail.com%2Ffiles%2F20220430211210912917.mp4?alt=media&token=8e14217d-ac52-4f6c-b01b-da776032ffb0";
          // String furl = await ImageUploader.downloadfile(url, "test");
          // print(furl);
          String a = KeyStore.genaratekeycode();
          print(a.length);
          print(a);
        },
      ),
    );
  }
}
