import 'dart:ui';

import 'package:ark/bean/user_data.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/existing_user_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ExistingUsers extends StatefulWidget {
  @override
  ExistingUsersState createState() => new ExistingUsersState();
}

class ExistingUsersState extends State<ExistingUsers> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.white,
      appBar: new AppBar(
        title: new Text('已创建用户'),
        centerTitle: true,
      ),
      body: ProviderWidget<ExistingUsersModel>(
        model: ExistingUsersModel(),
        onModelReady: (model) {
          model.getExistingUsers();
        },
        builder: (context, model, child) {
          if (model.isBusy) {
            return SkeletonList(builder: (context, index) => ArkSkeletonItem());
          }

          return ListView.separated(
              itemBuilder: (context, index) {
                UserBean userBean = model.userData.data[index];
                return UserItem(userBean);
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  color: MyColors.color_EAEBEF,
                );
              },
              itemCount:
                  model.userData != null ? model.userData.data.length : 0);
        },
      ),
    );
  }
}

class UserItem extends StatefulWidget {
  UserBean userBean;

  UserItem(this.userBean);

  @override
  UserItemState createState() => new UserItemState();
}

class UserItemState extends State<UserItem> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteName.create_user,
            arguments: [widget.userBean]);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  widget.userBean.username,
                  style: TextStyle(
                      color: MyColors.color_040404,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    widget.userBean.objKey,
                    style:
                        TextStyle(color: MyColors.color_1246FF, fontSize: 12),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 13, top: 13),
                      decoration: BoxDecoration(
                          color: MyColors.color_FAFAFA,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '手机号：${widget.userBean.phone}',
                            style: TextStyle(
                                color: MyColors.color_585D7B, fontSize: 12),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              '邮箱：${widget.userBean.email}',
                              style: TextStyle(
                                  color: MyColors.color_585D7B, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: ImageUtils.getImgUrl(widget.userBean.image),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, img) {
                          return Image.asset(
                            Utils.getImgPath('img_empty'),
                            width: 60,
                            height: 60,
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
