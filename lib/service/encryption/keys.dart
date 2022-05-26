import 'dart:math';
import 'package:random_string/random_string.dart';

class KeyStore {
  var random = new Random();

  static String genaratekeycode() {
    String keycode = randomAlphaNumeric(32);
    return keycode;
  }
}
