import 'dart:convert';
import 'dart:io';

import 'package:ark/bean/file_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/file_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileUploadView extends StatefulWidget {
  @override
  FileUploadViewState createState() => new FileUploadViewState();
}

Directory directory;
List<FileBean> files;
Map<int, bool> map;

class FileUploadViewState extends State<FileUploadView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('上传文件列表'),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
            onPressed: () {
              if (map.length == 0) {
                Toast.show('请先选择一个文件');
                return;
              }
              if (files == null || files.length == 0) {
                Toast.show('没有要选择的文件');
                return;
              }
              map.forEach((key, value) {
                if (value) {
                  print('被选中的是: $key');
                  NavigatorUtils.goBackWithParams(context, files[key]);
                }
              });
            },
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, position) {
            return _FileItem(position);
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: MyColors.color_E4E5E6,
            );
          },
          itemCount: files.length),
    );
  }

  getTransformDirectory() async {
    directory = await FileUtils.createUploadFile();
    int num = await directory.list().length;
    print('==》$num');

    await directory.list().forEach((element) {
      File file = File(element.path);
      FileBean fileBean = FileBean();
      fileBean.filePath = FileUtils.getFileName(file.path);
      fileBean.fileAbsoulutelyPath=file.path;
      if (fileBean.filePath.contains('.')) {
        fileBean.fileName =
            fileBean.filePath.substring(0, fileBean.filePath.lastIndexOf('.'));
        fileBean.lastName =
            fileBean.filePath.substring(fileBean.filePath.lastIndexOf('.') + 1);
      } else {
        fileBean.fileName = fileBean.filePath;
        fileBean.lastName = '';
      }
      fileBean.createTime = DateUtils.currentTimeMillis();
      setFileSize(file, fileBean);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    files = List();
    map = Map();
    getTransformDirectory();
  }

  void setFileSize(File file, FileBean fileBean) async {
    fileBean.fileSize = FileUtils.FormatFileSize(await file.length());
    fileBean.originSize=await file.length();
    files.add(fileBean);
    print('文件信息：${json.encode(files.length)}');
  }

  Widget _FileItem(int position) {
    FileBean fileBean = files[position];
    return CheckboxListTile(
        title: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Container(
              child: Center(
                child: Image(
                  image: ImageUtils.getAssetImage(
                      ImageUtils.getFileResource(fileBean.lastName)),
                  width: 19,
                  height: 19,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        fileBean.filePath,
                        style: TextStyle(
                            fontSize: 18, color: MyColors.color_black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            DateUtils.formatDateMsByYMDHM(fileBean.createTime),
                            style: TextStyle(
                                fontSize: 12, color: MyColors.color_6E757C),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              fileBean.fileSize,
                              style: TextStyle(
                                  fontSize: 12, color: MyColors.color_6E757C),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        isThreeLine: false,
        dense: true,
        selected: true,
        value: fileBean.selected,
        controlAffinity: ListTileControlAffinity.platform,
        activeColor: Colors.greenAccent,
        onChanged: (value) {
          fileBean.selected = value;
          map[position] = value;

          /// make checkbox singleState
          map.forEach((index, isSelected) {
            if (index == position && isSelected) {
              map[index] = true;
            } else {
              map[index] = false;
              files[index].selected = false;
            }
          });

          setState(() {});
        });
  }
}
