import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/common/api_constant.dart';
import 'package:ark/common/common.dart';
import 'package:ark/common/sp_constant.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/image_video_list_model.dart';
import 'package:ark/net/dio_utils.dart';
import 'package:ark/net/http_api.dart';
import 'package:ark/net/http_method.dart';
import 'package:ark/net/intercept.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/provider/view_state_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/ui/helper/refresh_helper.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/file_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/common_bottom_sheet.dart';
import 'package:ark/widgets/confirmDialog.dart';
import 'package:ark/widgets/detail/image_video_item.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

//import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageVideoEditView extends StatefulWidget {
  String objKey;
  String proName;
  String na;
  String type;

  ImageVideoEditView(this.objKey, this.proName, this.na, this.type);

  @override
  ImageVideoEditViewState createState() => new ImageVideoEditViewState();
}

TextEditingController proController = TextEditingController();
TextEditingController naController = TextEditingController();
TextEditingController posController = TextEditingController();

DetailProModel detailProModel;

class ImageVideoEditViewState extends State<ImageVideoEditView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextStyle style = TextStyle(color: MyColors.color_black, fontSize: 16);
  CommonProListModel _currentModel;

  @override
  Widget build(BuildContext context) {
    String title;
    if (widget.proName.isNotEmpty) {
      if (Comparable.compare(widget.type, Constant.image) == 0) {
        title = '图片列表编辑';
      } else {
        title = '视频列表编辑';
      }
    } else {
      if (Comparable.compare(widget.type, Constant.image) == 0) {
        title = '创建图片列表';
      } else {
        title = '创建视频列表';
      }
    }
    return Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
            onPressed: () {
              if (widget.proName.isNotEmpty) {
                print('编辑，不分类型');
                _currentModel
                    .propertyEdit(
                  naController.text,
                  StringUtils.isNotEmpty(posController.text)
                      ? int.parse(posController.text)
                      : -1,
                )
                    .then((value) {
                  if (value) {
                    Toast.show('属性更新成功');

                    detailProModel.updateListProNa(
                        widget.proName,
                        naController.text,
                        StringUtils.isNotEmpty(posController.text)
                            ? int.parse(posController.text)
                            : -1);
                  }
                });
              } else {
                String ctp;
                if (Comparable.compare(widget.type, Constant.image) == 0) {
                  ctp = 'img';
                } else {
                  ctp = 'video';
                }
                _currentModel
                    .createListPro(proController.text, naController.text, ctp,
                        json.encode(_currentModel.list))
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
      ),
      body: ProviderWidget<CommonProListModel>(
        model: CommonProListModel(widget.objKey, widget.proName),
        onModelReady: (model) {
          if (widget.proName.isNotEmpty) {
            model.initData();
          }
        },
        builder: (context, model, child) {
          if (model.isBusy) {
            return SkeletonList(
              builder: (context, index) => ArkSkeletonItem(),
            );
          } else if (model.list.isEmpty) {
            return ViewStateEmptyWidget(
              onPressed: model.initData(),
            );
          }
          _currentModel = model;
          return Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
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
                            enabled: widget.proName.isEmpty ? true : false),
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
              ),
              Expanded(
                flex: 1,
                child: SmartRefresher(
                  controller: model.refreshController,
                  header: WaterDropHeader(),
                  footer: RefresherFooter(),
                  onRefresh: model.refresh,
                  onLoading: model.loadMore,
                  enablePullUp: true,
                  child: GridView.builder(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 35 / 59,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: model.list.length,
                      itemBuilder: (context, index) {
                        /// 单条数据
                        Dt imgContent = model.list[index];
                        String imgUrl;
                        if (widget.type == Constant.image) {
                          imgUrl = ImageUtils.getImgUrl(imgContent.content);
                        } else {
                          imgUrl = ImageUtils.getImgUrl(
                              imgContent.content + Constant.videoCover);
                        }
                        print('图片地址==> $imgUrl');
                        return ImageVideoItem(widget.objKey, widget.proName,
                            widget.type, imgContent, index);
                      }),
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          height: 60,
          padding: EdgeInsets.all(10),
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('确定删除当前属性？'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('取消'),
                              ),
                              FlatButton(
                                child: Text('确定'),
                                onPressed: () {
                                  _currentModel.deletePro().then((value) {
                                    Toast.show('属性删除成功');
                                    detailProModel
                                        .deleteListPro(widget.proName);
                                    NavigatorUtils.goBack(context);
                                  });
                                },
                              )
                            ],
                          );
                        });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: MyColors.white,
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: MyColors.color_1246FF, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          '删除',
                          style: TextStyle(
                              color: MyColors.color_1246FF, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: () {
                      print('添加');
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            var list = List();
                            list.add('拍照');
                            list.add('相册');
                            return CommonBottomSheet(
                              list: list,
                              onItemClickListener: (index) async {
                                print('点击位置 $index');
                                switch (index) {
                                  case 0:
                                    _cameraImg();
                                    break;
                                  case 2:
                                    _imgGallery();
                                    break;
                                }
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                          color: MyColors.color_1246FF,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          '添加',
                          style: TextStyle(color: MyColors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    proController.text = widget.proName;
    naController.text = widget.na;
    detailProModel = Provider.of<DetailProModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  /// camera take  photo
  void _cameraImg() async {
    File file;
    if (widget.type == Constant.image) {
      file = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      file = await ImagePicker.pickVideo(source: ImageSource.camera);
    }
    _getGroupId(file);
  }

  /// photo galley pictures
  void _imgGallery() async {
    File file;
    if (widget.type == Constant.image) {
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
    } else {
      file = await ImagePicker.pickVideo(source: ImageSource.gallery);
    }
    _getGroupId(file);
  }

  void _uploadFile(File file, String value) async {
    String path = file.path;
    var name = path.substring(path.lastIndexOf('/') + 1, path.length);
    var end = name.substring(name.lastIndexOf('.') + 1, name.length);

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
      Map<String, dynamic> json = parseData(response.data.toString());
      int code = json['code'];
      if (code == 0) {
        Map<String, dynamic> responseData = json['data'];
        int code = responseData['code'];
        String message = responseData['message'];
        if (code == 1) {
          Map<String, dynamic> resultObj = responseData['resultObj'];
          String label = resultObj['label'];
          Dt dt = new Dt();
          dt.content = label;
          String info = '';

          if (Comparable.compare(widget.type, Constant.image) == 0) {
            info = "img##" +
                end +
                "##" +
                FileUtils.FormatFileSize(await file.length()) +
                "##";
          } else {
            info = "video##" +
                end +
                "##" +
                FileUtils.FormatFileSize(await file.length()) +
                "##";
          }
          dt.info = info;
          dt.time = DateUtils.currentTimeMillis();
          if (widget.proName.isNotEmpty) {
            _currentModel
                .propertyUnitAdd(label, '', info, DateUtils.currentTimeMillis())
                .then((value) {
              dt.id = value;
              _currentModel.list.add(dt);
              detailProModel.updateProListItem(dt, widget.proName, true);
              setState(() {});
            });
          } else {
            _currentModel.list.add(dt);
            setState(() {});
          }
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

  /// get dynamic ip
  void _getGroupId(File file) async {
    if (file == null) {
      return;
    }
    print('object =>${file.length}');
    num size = await file.length();
    _currentModel.getGroupId(widget.type, size / 1000).then((value) {
      if (value != null && value.isNotEmpty) {
        _uploadFile(file, value);
      }
    });
  }
}
