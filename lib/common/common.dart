import 'package:flutter/foundation.dart';

class Constant {
  /// debug开关，上线需要关闭
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction =
      const bool.fromEnvironment('dart.vm.product');

  static bool isTest = false;

  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';

  static const String keyGuide = 'keyGuide';
  static const String phone = 'phone';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';

  //视频封面的后缀
  static final String videoCover = "_1_cover";

  static const String theme = 'AppTheme';

  static const int CODE_SUCCESS = 1;

  static const int CODE_999 = 999;

  static const int CODE_998 = 998;

  static const int CODE_997 = 997;

  static const int CODE_995 = 995;

  static const String text_replace_value = 'text_replace_value';
  static const String object_replace_value = 'object_replace_value';
  static const String object_replace_object = 'object_replace_object';
  static const String add_relation = 'add_relation';

  static const String txt_ctp = 'txt';
  static const String image = 'image';
  static const String video = 'video';
  static const String file = 'file';
  static const String time = 'time';
  static const String object = 'object';

  static const String empty_view = 'img_empty';
  static const int short_pro = 0;
  static const int bm_pro = 1;
  static const int bf_pro = 2;
  static const int txt_list_pro = 3;
  static const int img_list_pro = 4;
  static const int video_list_pro = 5;
  static const int object_list_pro = 6;
  static const int time_list_pro = 7;
  static const int file_list_pro = 8;
}

class AppConfig {
  static const String appId = 'com.thl.flutterwanandroid';
  static const String appName = 'flutter_wanandroid';
  static const String version = '0.2.5';
  static const bool isDebug = kDebugMode;
}

class LoadStatus {
  static const int fail = -1;
  static const int loading = 0;
  static const int success = 1;
  static const int empty = 2;
}
