import 'package:ark/bean/catalog_list_bean.dart';
import 'package:ark/res/colors.dart';
/**
 * File: file_widget.dart
 * Package:
 * Project: tree_view
 * Author: Ajil Oommen (ajil@altorumleren.com)
 * Description:
 * Date: 06 January, 2019 2:03 PM
 */

import 'package:flutter/material.dart';

class FileWidget extends StatelessWidget {
  final CatalogListBean concept;
  final VoidCallback onPressedNext;


  FileWidget({@required this.concept,this.onPressedNext});

  @override
  Widget build(BuildContext context) {

    Row title= Row(
      children: <Widget>[
        Text(
          concept.conceptName,
          style: TextStyle(color: MyColors.color_010A29, fontSize: 16),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            '子概念：${concept.childrenNumber}',
            style: TextStyle(color: MyColors.color_black, fontSize: 14),
          ),
        )
      ],
    );

    Padding subtitle=Padding(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Text(
            '总数：${concept.objectsNumber}',
            style: TextStyle(color: MyColors.color_black, fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              '编号：${concept.code}',
              style:
              TextStyle(color: MyColors.color_black, fontSize: 12),
            ),
          )
        ],
      ),
    );


    Icon fileIcon = Icon(Icons.insert_drive_file);

    return Card(
      elevation: 0.0,
      child: ListTile(
        onTap: (){
          onPressedNext();

        },
        leading: fileIcon,
        title: title,
        subtitle: subtitle,
      ),
    );
  }
}
