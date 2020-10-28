import 'dart:ui';

import 'package:ark/bean/project_model.dart';
import 'package:ark/bean/user.dart';
import 'package:ark/bean/user_data.dart';
import 'package:ark/common/common.dart';
import 'package:ark/model/create_user_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/detail/image_video_item.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CreateUserView extends StatefulWidget {
  final UserBean userBean;

  CreateUserView({this.userBean});

  @override
  CreateUserViewState createState() => new CreateUserViewState();
}

class CreateUserViewState extends State<CreateUserView> {
  String _imgUrl = '';
  bool _enable = true;
  bool _isVisible = true;

  TextEditingController nameCon = TextEditingController();

  TextEditingController passwordCon = TextEditingController();

  TextEditingController confirmCon = TextEditingController();

  TextEditingController phoneCon = TextEditingController();

  TextEditingController emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.userBean != null) {
      nameCon.text = widget.userBean.username;
      phoneCon.text = widget.userBean.phone;
      emailCon.text = widget.userBean.email;
      _imgUrl = ImageUtils.getImgUrl(widget.userBean.image);
      _enable = false;
      _isVisible = false;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('创建用户'),
      ),
      body: ProviderWidget<CreateUserModel>(
        model: CreateUserModel(),
        onModelReady: (model) {
          if (widget.userBean != null) {
            model.getPermissionProjectList(widget.userBean.objKey, '');
          }
        },
        builder: (context, model, child) {
          if (model.isBusy) {
            return SkeletonList(
              builder: (context, index) => ArkSkeletonItem(),
            );
          }

          return SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: _imgUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, img) {
                            return Image.asset(
                              Utils.getImgPath(Constant.empty_view),
                              width: 80,
                              height: 80,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  inputWidget('用户名', nameCon),
                  inputWidget('密码', passwordCon),
                  inputWidget('确认密码', confirmCon),
                  inputWidget('手机号', phoneCon),
                  inputWidget('邮箱', emailCon),
                  Offstage(
                    offstage: !_isVisible,
                    child: Container(
                      alignment: Alignment.centerRight,
                      color: MyColors.white,
                      padding: EdgeInsets.only(right: 15, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              print('取消');
                              NavigatorUtils.goBack(context);
                            },
                            child: Container(
                              width: 60,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: MyColors.white,
                                  border: Border.all(
                                      color: MyColors.color_1246FF, width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(
                                '取消',
                                style: TextStyle(
                                    color: MyColors.color_1246FF, fontSize: 12),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              model
                                  .createUser(nameCon.text, passwordCon.text,
                                      confirmCon.text,
                                      phone: phoneCon.text,
                                      email: emailCon.text,
                                      image: _imgUrl)
                                  .then((value) {
                                if (value != null) {
                                  User user = value;
                                  Toast.show('创建对象成功');
                                  model.getPermissionProjectList(
                                      user.objKey, '');
                                }
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: 60,
                              height: 25,
                              margin: EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                  color: MyColors.color_1246FF,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  '确定',
                                  style: TextStyle(
                                      color: MyColors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: Text(
                      '项目权限设置',
                      style: TextStyle(
                          color: MyColors.color_040404,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      ProjectModel project = model.proList[index];
                      return PermissionProItem(project);
                    },
                    itemCount: model.proList.length,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget inputWidget(String title, TextEditingController controller,
      {bool isString}) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          color: MyColors.white,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: title,
                hintStyle:
                    TextStyle(color: MyColors.color_black, fontSize: 14)),
            style: TextStyle(color: MyColors.color_black, fontSize: 16),
            enabled: _enable,
            controller: controller,
            inputFormatters: title == '密码' || title == '确认密码'
                ? [WhitelistingTextInputFormatter.digitsOnly]
                : null,
          ),
        ),
        Divider(
          color: MyColors.color_EAEBEF,
          height: 1,
        )
      ],
    );
  }
}

class PermissionProItem extends StatefulWidget {
  ProjectModel project;

  PermissionProItem(this.project);

  @override
  PermissionProItemState createState() => new PermissionProItemState();
}

class PermissionProItemState extends State<PermissionProItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: MyColors.color_0DCCCCCC,
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.project.project,
                style: TextStyle(
                    color: MyColors.color_black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  print('设置');
                },
                child: Container(
                  width: 50,
                  height: 25,
                  decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(2),
                      border:
                          Border.all(color: MyColors.color_1246FF, width: 1)),
                  child: Center(
                    child: Text(
                      '设置',
                      style:
                          TextStyle(color: MyColors.color_1246FF, fontSize: 12),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 5,
              children: _getProjectGridItem(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _getProjectGridItem() {
    List<Widget> widgetList = List();
    if (widget.project.conceptLi != null &&
        widget.project.conceptLi.length > 0) {
      for (var conceptLi in widget.project.conceptLi) {
        widgetList.add(Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: MyColors.color_F0F3FE),
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              conceptLi.conceptName,
              style: TextStyle(color: MyColors.color_2E2F33, fontSize: 12),
            ),
          ),
        ));
      }
    }
    return widgetList;
  }
}
