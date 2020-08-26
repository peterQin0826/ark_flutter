import 'dart:convert';

import 'package:ark/bean/file_bean.dart';
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/common/sp_constant.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/image_video_list_model.dart';
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
import 'package:ark/widgets/detail/upload_file_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileListItemEdit extends StatefulWidget {
  String objKey;
  String proName;
  Dt dt;

  FileListItemEdit(this.objKey, this.proName, this.dt);

  @override
  FileListItemEditState createState() => new FileListItemEditState();
}

TextEditingController titleController = new TextEditingController();
TextEditingController infoController = new TextEditingController();
TextEditingController timeController = new TextEditingController();

class FileListItemEditState extends State<FileListItemEdit> {
  CommonProListModel _currentModel;

  @override
  Widget build(BuildContext context) {
    DetailProModel detailProModel =
        Provider.of<DetailProModel>(context, listen: false);
    print('文件列表：${detailProModel.key}');
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
            onPressed: () async {
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
                    print('验证详情页数据：${detailProModel.key}');
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
                      },
                      child: Hero(
                        tag: widget.dt,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: <Widget>[
                              Image(
                                image: ImageUtils.getAssetImage(
                                    ImageUtils.getFileResource(
                                        Utils.getIndexName(widget.dt.info, 1))),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              _editWidget(),
                            ],
                          ),
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

    super.initState();
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
        enabled: StringUtils.isNotEmpty(widget.proName)
            ? pos == 2 ? false : true
            : true,
      ),
    );
  }

  void _uploadFile(FileBean file, String value) async {
    String path = file.fileAbsoulutelyPath;
    var name = file.fileName;
    var end = file.lastName;

    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
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
      Map<String, dynamic> json =
          StringUtils.parseData(response.data.toString());
      int code = json['code'];
      if (code == 0) {
        Map<String, dynamic> responseData = json['data'];
        int code = responseData['code'];
        String message = responseData['message'];
        if (code == 1) {
          Map<String, dynamic> resultObj = responseData['resultObj'];
          String label = resultObj['label'];

          widget.dt.content = label;

          widget.dt.info = await FileUtils.getFileType(file.lastName) +
              "##" +
              file.lastName +
              "##" +
              file.fileSize +
              "##" +
              file.summary;
          widget.dt.time = DateUtils.currentTimeMillis();
          widget.dt.title = file.fileName;
          titleController.text = file.fileName;
          timeController.text = DateUtils.formatDateMsByYMDHM(widget.dt.time);
          setState(() {
            Toast.show('更新成功');
          });
//          if (widget.proName.isNotEmpty) {
//            _currentModel
//                .propertyUnitAdd(label, '', info, DateUtils.currentTimeMillis())
//                .then((value) {
//              dt.id = value;
//              _currentModel.list.add(dt);
//              detailProModel.updateProListItem(dt, widget.proName, true);
//              setState(() {});
//            });
//          } else {
//            _currentModel.list.add(dt);
//            setState(() {});
//          }
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
      'r_type': FileUtils.getFileName(end),
      'extension': end,
      "file": await MultipartFile.fromFile(path, filename: name),
    });
  }

  Widget _editWidget() {
    return Positioned(
      /// 透明组件
      child: Opacity(
        opacity: 0.8,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteName.file_upload).then((value) {
              if (null != value) {
                FileBean filebean = value;

                _showDialog(context, filebean);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: MyColors.color_black,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            width: 100,
            height: 20,
            child: Center(
              child: Text(
                '点击编辑',
                style: TextStyle(fontSize: 14, color: MyColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, FileBean filebean) {
    showDialog(
        context: context,
        builder: (context) {
          return UploadDialog(
            confirmClicked: (FileBean file) async {
              String fileType = await FileUtils.getFileType(file.lastName);
              _currentModel
                  .getGroupId(fileType, filebean.originSize / 1000)
                  .then((value) {
                if (value != null && value.isNotEmpty) {
                  print('文件原始路径：${filebean.fileAbsoulutelyPath}');
                  _uploadFile(file, value);
                }
              });
            },
            fileBean: filebean,
          );
        });
  }
}
