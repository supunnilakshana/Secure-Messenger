import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:securemsg/service/encryption/keys.dart';

class Cryptovideo {
  var random = new Random();
  KeyStore _keyStore = KeyStore();

  //decrypt
  String decryptText(String text, String keytext) {
    // String keytext = _keyStore.findkey(keycode);
    print(keytext);
    final key = Key.fromUtf8(keytext);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final decryptedText = encrypter.decrypt64(text, iv: iv);
    print(decryptedText);
    return decryptedText;
  }

//encrypt

  Future<EncryptedItem> encryptFile(File video) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File outFile = new File("$dir/videoenc.aes");
    String keytext = KeyStore.genaratekeycode();

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      outFile.create();
      print("created");
    }

    final videoFileContents = video.readAsStringSync(encoding: latin1);

    final key = Key.fromUtf8(keytext);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
    await outFile.writeAsBytes(encrypted.bytes);

    print("encrypted");

    return (EncryptedItem(video: outFile, key: keytext));
  }

  Future<File> decryptFile(File inFile, String keycode) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File outFile = File("$dir/videodec.mp4");

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      outFile.create();
    }

    final videoFileContents = inFile.readAsBytesSync();

    final key = Key.fromUtf8(keycode);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encryptedFile = Encrypted(videoFileContents);
    final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

    final decryptedBytes = latin1.encode(decrypted);
    await outFile.writeAsBytes(decryptedBytes);
    print("decrypted");
    return outFile;
  }
}

class EncryptedItem {
  final File video;
  final String key;

  EncryptedItem({required this.video, required this.key});
}
