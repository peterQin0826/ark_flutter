import 'package:ark/widgets/app_bar.dart';
import 'package:ark/widgets/state_layout.dart';
import 'package:flutter/material.dart';

class WidgetNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(
        centerTitle: '页面不存在',
      ),
      body: StateLayout(
        type: StateType.account,
        hintText: '页面不存在',
      ),
    );
  }
}
