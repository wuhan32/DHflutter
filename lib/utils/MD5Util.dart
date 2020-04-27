import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

//md5加密工具类
class MD5Util {

  // md5 加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    //这里其实就是 digest.toString()
    return hex.encode(digest.bytes).toLowerCase();
  }

}
