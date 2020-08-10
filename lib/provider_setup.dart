import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'bean/theme_bean.dart';

List<SingleChildStatelessWidget> providers = [
  ChangeNotifierProvider<ThemeBean>(
    create: (_) =>
        ThemeBean(themeData: ThemeData.dark(), themeType: ThemeType.light),
  ),
];
