import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:securemsg/service/encryption/keys.dart';

class CryptoEncrpt {
  var random = new Random();

  //decrypt
  static String decryptText(EnText enText) {
    final key = Key.fromUtf8(enText.key);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final decryptedText = encrypter.decrypt64(enText.msg, iv: iv);
    print(decryptedText);

    return decryptedText;
  }

//encrypt
  static EnText ecryptText(String text) {
    String keytext = KeyStore.genaratekeycode();
    final key = Key.fromUtf8(keytext);
    final iv = IV.fromLength(16);
    // print(iv.base64);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);

    print(encrypted.base64);

    String encryptedText = encrypted.base64;

    return EnText(key: keytext, msg: encryptedText);
  }

  bool isencrypt(String text) {
    bool isen = false;
    if (text[0] == "initensymbol") {
      isen = true;
    } else {
      isen = false;
    }
    print(isen);
    return isen;
  }
}

class EnText {
  final String key;
  final String msg;

  EnText({required this.key, required this.msg});
}
