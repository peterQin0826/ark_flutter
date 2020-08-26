import 'dart:convert';

import 'package:ark/common/common.dart';
import 'package:ark/model/image_video_list_model.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditViewAppBar extends StatelessWidget {
  String objKey;
  String proName;
  String na;
  int pos;
  String type;

  EditViewAppBar(this.objKey, this.proName, this.type);

  @override
  Widget build(BuildContext context) {
    CommonProListModel model =
        Provider.of<CommonProListModel>(context, listen: false);
    String title;
    if (proName.isNotEmpty) {
      if (type == Constant.image) {
        title = '图片列表编辑';
      } else {
        title = '视频列表编辑';
      }
    } else {
      if (type == Constant.image) {
        title = '创建图片列表';
      } else {
        title = '创建视频列表';
      }
    }

    return new AppBar(
      title: new Text(title),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Text(
            '确定',
            style: TextStyle(color: MyColors.white, fontSize: 16),
          ),
          onPressed: () {
            if (proName.isNotEmpty) {
              print('编辑，不分类型');
              model
                  .propertyEdit(
                      na, pos)
                  .then((value) {
                if (value) {
                  Toast.show('属性更新成功');
                }
              });
            } else {
              String ctp;
              if (type == Constant.image) {
                ctp = 'img';
              } else {
                ctp = 'video';
              }
              model
                  .createListPro(proName, na, ctp,
                      json.encode(model.list))
                  .then((value) {
                if (value) {
                  Toast.show('属性创建成功');
                  NavigatorUtils.goBackWithParams(context, true);
                }
              });
            }
          },
        )
      ],
    );
  }
}
