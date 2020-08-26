import 'package:ark/res/colors.dart';
import 'package:flutter/material.dart';

class EditViewTopTitle extends StatelessWidget {
  String proName;


  @override
  Widget build(BuildContext context) {

    TextEditingController proController = TextEditingController();
    TextEditingController naController = TextEditingController();
    TextEditingController posController = TextEditingController();

    TextStyle style = TextStyle(color: MyColors.color_black, fontSize: 16);

    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextField(
              controller: proController,
              decoration: InputDecoration(
                  hintText: '区域名称',
                  enabled: proName.isEmpty ? true : false),
              style: style,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: naController,
                style: style,
                decoration: InputDecoration(
                  hintText: '别称',
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            child: TextField(
              controller: posController,
              decoration: InputDecoration(
                hintText: '位置',
              ),
              style: style,
            ),
          )
        ],
      ),
    );
  }
}