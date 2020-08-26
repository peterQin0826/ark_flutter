import 'dart:io';

import 'package:ark/utils/string_utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  /// 转换文件大小
  static String FormatFileSize(num fileS) {
    String fileSizeString = "";
    String wrongSize = "0B";
    if (fileS == 0) {
      return wrongSize;
    }
    if (fileS < 1024) {
      fileSizeString =
          (NumUtil.getNumByValueDouble(fileS, 2)).toStringAsFixed(2) + "B";
    } else if (fileS < 1048576 && fileS > 1024) {
      fileSizeString =
          (NumUtil.getNumByValueDouble(fileS / 1024, 2)).toStringAsFixed(2) +
              "KB";
    } else if (fileS < 1073741824 && fileS > 1048576) {
      fileSizeString =
          (NumUtil.getNumByValueDouble(fileS / 1048576, 2)).toStringAsFixed(2) +
              "MB";
    } else {
      fileSizeString = (NumUtil.getNumByValueDouble(fileS / 1073741824, 2))
              .toStringAsFixed(2) +
          "GB";
    }
    return fileSizeString;
  }

  /// create uoload File
  static Future<Directory> createUploadFile() async {
    final directory = await getExternalStorageDirectory();

    var file = Directory(directory.path + "/" + "XPQ_Flutter");
    print('创建地址：${directory.path}');
    try {
      bool exists = await file.exists();
      if (!exists) {
        await file.create();
        print('创建成功');
      }
    } catch (e) {
      print(e);
    }
    return file;
  }

  static String getFileName(String filePath) {
    if (null != filePath && filePath.isNotEmpty) {
      return filePath.substring(filePath.lastIndexOf('/') + 1);
    }
    return '';
  }

  static Future<String> getFileType(String name) async {
    String string = "unknow";
    String jsonData = await rootBundle.loadString('assets/tp.json');
    Map<String, dynamic> map = StringUtils.parseData(jsonData);
    map.forEach((key, value) {
//      print('遍历 ：$value');
      if (value is List) {
        if (value.contains(name)) {
          string = key;
        }
      }
    });
    return string;
  }
}
