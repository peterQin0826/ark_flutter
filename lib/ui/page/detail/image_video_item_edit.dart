import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/common/sp_constant.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/image_video_list_model.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/intercept.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/file_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/common_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageVideoItemEditView extends StatefulWidget {
  String objKey;
  String proName;
  Dt dt;
  String type;

  ImageVideoItemEditView(this.objKey, this.proName, this.dt, this.type);

  @override
  ImageVideoItemEditViewState createState() =>
      new ImageVideoItemEditViewState();
}

TextEditingController titleController = new TextEditingController();
TextEditingController infoController = new TextEditingController();
TextEditingController timeController = new TextEditingController();

DetailProModel detailProModel;

class ImageVideoItemEditViewState extends State<ImageVideoItemEditView> {
  CommonProListModel _currentModel;

  @override
  Widget build(BuildContext context) {
    String _imgUrl;
    if (widget.type == Constant.image) {
      _imgUrl = ImageUtils.getImgUrl(widget.dt.content);
    } else {
      _imgUrl = ImageUtils.getImgUrl(widget.dt.content + Constant.videoCover);
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.type == Constant.image ? '图片编辑' : '视频编辑'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
            onPressed: () {
              String before = widget.dt.info
                  .substring(0, widget.dt.info.lastIndexOf("#") + 1);
              widget.dt.title = titleController.text;
              widget.dt.info = before + infoController.text;

              if (StringUtils.isNotEmpty(widget.proName)) {
                /// 更新
                List<Dt> list = List();
                list.add(widget.dt);
                _currentModel
                    .propertyUnitEdit(StringUtils.toJsonString(list))
                    .then((value) {
                  if (value) {
                    Toast.show('更新成功');
                    detailProModel.updateProListItem(
                        widget.dt, widget.proName, false);
                  }
                });
              }
              NavigatorUtils.goBackWithParams(context, widget.dt);
            },
          )
        ],
      ),
      body: ProviderWidget<CommonProListModel>(
        model: CommonProListModel(widget.objKey, widget.proName),
        onModelReady: (model) {},
        builder: (context, model, child) {
          _currentModel = model;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        var list = List();

                        /// 编辑

                        showDialog(
                            context: context,
                            builder: (context) {
                              list.add('拍照');
                              list.add('相册');
                              return CommonBottomSheet(
                                list: list,
                                onItemClickListener: (index) async {
                                  print('点击位置 $index');
                                  switch (index) {
                                    case 0:
                                      _cameraImg(_imgUrl);
                                      break;
                                    case 2:
                                      _imgGallery(_imgUrl);
                                      break;
                                  }
                                  Navigator.pop(context);
                                },
                              );
                            });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: _imgUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Image.asset(
                                  Utils.getImgPath('img_empty'),
                                  width: 150,
                                  height: 150,
                                );
                              },
                              width: 150,
                              height: 150,
                            ),
                            Positioned(
                              /// 透明组件
                              child: Opacity(
                                opacity: 0.8,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: MyColors.color_black,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8))),
                                  width: 150,
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      '点击编辑',
                                      style: TextStyle(
                                          fontSize: 14, color: MyColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _title('标题'),
                    _input(titleController, 0),
                    _title('简介'),
                    _input(infoController, 1),
                    _title('时间'),
                    _input(timeController, 2)
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    titleController.text = widget.dt.title;
    if (widget.dt.info != null && widget.dt.info.isNotEmpty) {
      if (widget.dt.info.contains('##')) {
        infoController.text =
            widget.dt.info.substring(widget.dt.info.lastIndexOf('#') + 1);
      }
    }
    timeController.text = DateUtils.formatDateMsByYMDHM(widget.dt.time);
    detailProModel = Provider.of<DetailProModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _title(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 15),
      child: Text(
        title,
        style: TextStyle(color: MyColors.color_6E757C, fontSize: 14),
      ),
    );
  }

  Widget _input(TextEditingController controller, int pos) {
    return Container(
      color: MyColors.white,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
      margin: EdgeInsets.only(top: 5),
      child: TextField(
        controller: controller,
        style: TextStyle(color: MyColors.color_black, fontSize: 16),
        decoration: InputDecoration(border: InputBorder.none),
        keyboardType: TextInputType.multiline,
        autofocus: pos == 0 ? true : false,
        enabled: StringUtils.isNotEmpty(widget.proName)
            ? pos == 2 ? false : true
            : true,
      ),
    );
  }

  /// take photo by camera
  void _cameraImg(String imgUrl) async {
    File file;
    if (widget.type == Constant.image)
      file = await ImagePicker.pickImage(source: ImageSource.camera);
    else
      file = await ImagePicker.pickVideo(source: ImageSource.camera);
    _getGroupId(file, imgUrl);
  }

  /// take photo by phto galley
  void _imgGallery(String imgUrl) async {
    File file;
    if (widget.type == Constant.image)
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
    else
      file = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _getGroupId(file, imgUrl);
  }

  /// get the dynamic ip from server
  void _getGroupId(File file, String imgUrl) async {
    if (file == null) {
      return;
    }
    print('object =>${file.length}');
    num size = await file.length();
    _currentModel.getGroupId(widget.type, size / 1000).then((value) {
      if (value != null && value.isNotEmpty) {
        _uploadFile(file, value, imgUrl);
      }
    });
  }

  /// start to upload file to server
  void _uploadFile(File file, String value, String imgUrl) async {
    String path = file.path;
    var name = path.substring(path.lastIndexOf('/') + 1, path.length);
    var end = name.substring(name.lastIndexOf('.') + 1, name.length);

    var options = BaseOptions(
//      connectTimeout: 15000,
//      receiveTimeout: 15000,
      responseType: ResponseType.plain,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
//      contentType: Headers.formUrlEncodedContentType,
      baseUrl: value,
    );

    Dio _dio = new Dio(options);

    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());
//    /// 刷新Token
//    _dio.interceptors.add(TokenInterceptor());
    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      _dio.interceptors.add(LoggingInterceptor());
    }

    /// 适配数据(根据自己的数据结构，可自行选择添加)
    _dio.interceptors.add(AdapterInterceptor());

    var formData = await formDataRequest(path, name, end);

    Response response = await _dio.post(HttpApi.up_resource,
        data: await formData, onSendProgress: (received, total) {
      if (total != -1) {
        print('晓鹏秦==> ${(received / total * 100).toStringAsFixed(0)}  %');
      }
    });

    print(json.decode(response.toString()));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = parseData(response.data.toString());
      int code = json['code'];
      if (code == 0) {
        Map<String, dynamic> responseData = json['data'];
        int code = responseData['code'];
        String message = responseData['message'];
        if (code == 1) {
          Map<String, dynamic> resultObj = responseData['resultObj'];
          String label = resultObj['label'];
          widget.dt.content = label;
          imgUrl = ImageUtils.getImgUrl(label);
          setState(() {});
        } else {
          Toast.show(message);
        }
      }
    } else {
      Toast.show('异常:${response.statusMessage}');
    }
  }

  /// FormData will create readable "multipart/form-data" streams.
  /// It can be used to submit forms and file uploads to http server.
  Future<FormData> formDataRequest(String path, String name, String end) async {
    return FormData.fromMap({
      'group_id': SpUtil.getString(SpConstants.user_key),
      'r_type': widget.type,
      'extension': end,
      "file": await MultipartFile.fromFile(path, filename: name),
    });
  }
}
