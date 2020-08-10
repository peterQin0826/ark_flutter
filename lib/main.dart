import 'dart:async';
import 'dart:io';
import 'package:ark/base/nav_key.dart';
import 'package:ark/bean/themeColorMap.dart';
import 'package:ark/common/sp_constant.dart';
import 'package:ark/base/application.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/provider/appinfo_provider.dart';
import 'package:ark/provider_setup.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/routers/routers.dart';
import 'package:ark/ui/login.dart';
import 'package:ark/ui/mian_project.dart';
import 'package:ark/utils/log_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'bean/theme_bean.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();

  runApp(MyApp());

  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  MyApp() {
    Log.init();
    final router = Router();
    Routers.configureRoutes(router);
    Application.router = router;
  }

  Color _themeColor;

  @override
  Widget build(BuildContext context) {
    bool login = SpUtil.getBool(SpConstants.is_Login);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppInfoProvider()),
        ChangeNotifierProvider(create: (_) =>DetailProModel(),)
      ],
      child: Consumer<AppInfoProvider>(
        builder: (context, appinfo, _) {
          String colorkey = appinfo.themeColor;

          print('object=====>$colorkey');
          if (TextUtil.isEmpty(colorkey)) {
            colorkey='blue';
          }
          if (themeColorMap[colorkey] != null) {
            _themeColor = themeColorMap[colorkey];
          }
          return OKToast(
              child: MaterialApp(
                title: '方舟2.0',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: _themeColor,
                ),
                navigatorKey: NavKey.navKey,
                home: login ? MainProject() : Login(),
              ),

              /// Toast 配置
              backgroundColor: Colors.black54,
              textPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              radius: 20.0,
              position: ToastPosition.bottom);
        },
      ),
    );
  }
}
