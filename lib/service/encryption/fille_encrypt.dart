import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:securemsg/service/encryption/keys.dart';

class CryptoEncryptFile {
  var random = new Random();

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

  Future<EncryptedItem> encryptFile(File file) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File outFile = new File("$dir/fileenc.aes");
    String keytext = KeyStore.genaratekeycode();

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      outFile.create();
      print("created");
    }

    final fileFileContents = file.readAsStringSync(encoding: latin1);

    final key = Key.fromUtf8(keytext);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(fileFileContents, iv: iv);
    await outFile.writeAsBytes(encrypted.bytes);

    print("encrypted");

    return (EncryptedItem(file: outFile, key: keytext));
  }

  Future<File> decryptFile(
      File inFile, String keycode, String extension) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File outFile = File("$dir/filedec" + extension);

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      outFile.create();
    }

    final fileFileContents = inFile.readAsBytesSync();

    final key = Key.fromUtf8(keycode);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encryptedFile = Encrypted(fileFileContents);
    final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

    final decryptedBytes = latin1.encode(decrypted);
    await outFile.writeAsBytes(decryptedBytes);
    print("decrypted");
    return outFile;
  }
}

class EncryptedItem {
  final File file;
  final String key;

  EncryptedItem({required this.file, required this.key});
}
