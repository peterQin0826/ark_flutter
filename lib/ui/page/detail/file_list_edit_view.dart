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
import 'package:ark/provider/view_state_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/ui/helper/refresh_helper.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/file_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/detail/file_item.dart';
import 'package:ark/widgets/detail/image_video_item.dart';
import 'package:ark/widgets/detail/upload_file_dialog.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FileListEditView extends StatefulWidget {
  String objKey;
  String proName;
  String na;

  FileListEditView(this.objKey, this.proName, this.na);

  @override
  FileListEditViewState createState() => new FileListEditViewState();
}

TextEditingController proController = TextEditingController();
TextEditingController naController = TextEditingController();
TextEditingController posController = TextEditingController();

DetailProModel detailProModel;

class FileListEditViewState extends State<FileListEditView>
    with AutomaticKeepAliveClientMixin {
  TextStyle style = TextStyle(color: MyColors.color_black, fontSize: 16);
  CommonProListModel _currentModel;

  @override
  Widget build(BuildContext context) {
    String title = null != widget.proName ? '文件编辑' : '文件列表创建';
    detailProModel = Provider.of<DetailProModel>(context, listen: true);
    print('文件列表：${detailProModel.key}');
    return new Scaffold(
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
                /// edit file property
                _currentModel
                    .propertyEdit(
                        naController.text,
                        StringUtils.isNotEmpty(posController.text)
                            ? num.parse(posController.text)
                            : -1)
                    .then((value) {
                  if (value) {
                    Toast.show('属性更新成功');
                    detailProModel.updateProNa(
                        widget.proName,
                        naController.text,
                        StringUtils.isNotEmpty(posController.text)
                            ? num.parse(posController.text)
                            : -1);
                  }
                });
              } else {
                /// create file property
                _currentModel
                    .createListPro(proController.text, naController.text,
                        Constant.file, json.encode(_currentModel.list))
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
                    child: ListView.separated(
                      itemCount: model.list.length,
                      itemBuilder: (context, index) {
                        /// 单条数据
                        Dt file = model.list[index];
                        return Slidable(
                          actionPane: SlidableScrollActionPane(),
                          actionExtentRatio: 0.25,
                          child: FileItem(widget.objKey, widget.proName, file),
                          secondaryActions: <Widget>[
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 50,
                                color: MyColors.color_FE3B30,
                                child: Center(
                                  child: Text(
                                    '删除',
                                    style: TextStyle(
                                        color: MyColors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                              onTap: () {
                                List<num> idLis = List();
                                idLis.add(file.id);
                                model
                                    .deleteItem(json.encode(idLis))
                                    .then((value) {
                                  if (value) {
                                    model.list.removeAt(index);
                                    detailProModel.deleteListItem(
                                        file.id, widget.proName);
                                  }
                                });

                                setState(() {});
                              },
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 1,
                          color: MyColors.color_E4E5E6,
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          }),
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
                      Navigator.pushNamed(context, RouteName.file_upload)
                          .then((value) {
                        FileBean fileBean = value;
                        if (value != null) {
                          _showDialog(fileBean, context);
                        }
                      });
                    },
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                          color: MyColors.color_1246FF,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          '上传文件',
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
    super.initState();
    createUploadDirectory();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void createUploadDirectory() async {
    await FileUtils.createUploadFile();
  }

  void _showDialog(FileBean fileBean, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return UploadDialog(
            fileBean: fileBean,
            confirmClicked: (FileBean file) async {
              String fileType = await FileUtils.getFileType(file.lastName);
              _currentModel
                  .getGroupId(fileType, fileBean.originSize / 1000)
                  .then((value) {
                if (value != null && value.isNotEmpty) {
                  print('文件原始路径：${fileBean.fileAbsoulutelyPath}');
                  _uploadFile(file, value);
                }
              });
            },
          );
        });
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

    Response response = await _dio.post(HttpApi.up_resource, data: formData,
        onSendProgress: (received, total) {
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

          Dt dt = new Dt();
          dt.content = label;

          dt.info = await FileUtils.getFileType(file.lastName) +
              "##" +
              file.lastName +
              "##" +
              file.fileSize +
              "##" +
              file.summary;
          dt.time = DateUtils.currentTimeMillis();
          dt.title = file.fileName;
          _currentModel.list.add(dt);
          detailProModel.updateProListItem(dt, widget.proName, true);
          setState(() {
            Toast.show('更新成功');
          });
        } else {
          Toast.show(message);
        }
      }
    } else {
      Toast.show('异常:${response.statusMessage}');
    }
  }

  Future<FormData> formDataRequest(String path, String name, String end) async {
    return FormData.fromMap({
      'group_id': SpUtil.getString(SpConstants.user_key),
      'r_type': FileUtils.getFileName(end),
      'extension': end,
      "file": await MultipartFile.fromFile(path, filename: name),
    });
  }
}
