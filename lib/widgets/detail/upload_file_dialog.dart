import 'dart:convert';

import 'package:ark/bean/file_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/file_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Custom File Upload Dialog
/// create 2020-08-24
/// Author：Peter
class UploadDialog extends Dialog {
  FileBean fileBean;
  onConfirmClicked confirmClicked;

  UploadDialog({this.confirmClicked,this.fileBean});

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: MyColors.color_6E757C, fontSize: 12);
    TextStyle inputStyle = TextStyle(fontSize: 16, color: MyColors.color_black);

    TextEditingController nameController = TextEditingController();
    nameController.text = fileBean.fileName;
    TextEditingController summaryController = TextEditingController();

    TextEditingController typeController = TextEditingController();
    typeController.text = fileBean.lastName;

    print('上传的dialog ==》${fileBean.lastName}');
    return Material(
      type: MaterialType.transparency, //透明类型
      child: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Container(
            padding: EdgeInsets.only(left: 20,right: 20,top: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: MyColors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Image.asset(
                      Utils.getImgPath(
                          ImageUtils.getFileResource(fileBean.lastName)),
                      width: 22,
                      height: 22,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Text(
                            DateUtils.formatDateMsByYMDHM(fileBean.createTime),
                            style: style,
                          ),
                          Text(
                            fileBean.fileSize,
                            style: style,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: nameController,
                    style: inputStyle,
                  ),
                ),
                TextField(
                  controller: summaryController,
                  style: inputStyle,
                  decoration: InputDecoration(
                    hintText: '点击编辑简介'
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: typeController,
                        enabled: null == fileBean.lastName ||
                            fileBean.lastName.isEmpty,
                      ),
                    ),
                    Image.asset(
                      Utils.getImgPath('click_more'),
                      width: 14,
                      height: 14,
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20,top: 20),
                  child: Container(
                    height: 40,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                border: Border.all(color: MyColors.color_1246FF,width: 1),
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(
                                child: Text('取消',style: TextStyle(color: MyColors.color_ABAFB2,fontSize: 16),),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              fileBean.fileName=nameController.text;
                              fileBean.summary=summaryController.text;
                              if(confirmClicked!=null){
                                confirmClicked(fileBean);
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.color_1246FF,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(
                                child: Text('确定',style: TextStyle(color: MyColors.white,fontSize: 16),),
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
          ),
        ),
      ),
    );
  }
}

typedef onConfirmClicked = void Function(FileBean fileBean);
