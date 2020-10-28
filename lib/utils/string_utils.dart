import 'dart:convert';

/// 字符创工具类
///
class StringUtils {
  /// judge the string is  empty or not
  static bool isNotEmpty(String string) {
    if (null != string && string.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static bool isEmpty(String string) {
    if (string == null) {
      return true;
    }
    if (null != string && string.length == 0) {
      return true;
    }
    return false;
  }

  /// transform  object to JsonString
  static String toJsonString(dynamic object) {
    return json.encode(object);
  }

  static Map<String, dynamic> parseData(String data) {
    return json.decode(data);
  }
}
