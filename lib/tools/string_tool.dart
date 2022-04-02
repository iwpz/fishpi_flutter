import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class StringTool {
  static String getMd5(String src) {
    var content = const Utf8Encoder().convert(src);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
