import 'package:ark/bean/catalog_list_bean.dart';
import 'package:ark/res/colors.dart';
/**
 * File: directory_widget.dart
 * Package:
 * Project: tree_view
 * Author: Ajil Oommen (ajil@altorumleren.com)
 * Description:
 * Date: 06 January, 2019 2:04 PM
 */

import 'package:flutter/material.dart';

class DirectoryWidget extends StatelessWidget {
  final CatalogListBean concept;
  final VoidCallback onPressedNext;

  DirectoryWidget({
    @required this.concept,
    this.onPressedNext,
  });


  @override
  Widget build(BuildContext context) {

    Image folderIcon = Image(
      image: AssetImage("assets/images/folder.png"),
      width: 15,
      height: 13,
    );

    IconButton expandButton = IconButton(
      icon: Image(
        image: AssetImage('assets/images/folder_open.png'),
        width: 12,
        height: 12,
      ),
      onPressed: (){
        onPressedNext();
      },
    );

    Row title= Row(
      children: <Widget>[
        Text(
          concept.conceptName,
          style: TextStyle(color: MyColors.color_010A29, fontSize: 16),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            '子概念：${concept.childrenNumber}',
            style: TextStyle(color: MyColors.color_black, fontSize: 14),
          ),
        )
      ],
    );

    Padding subtitle =Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Text(
            '总数：${concept.objectsNumber}',
            style: TextStyle(color: MyColors.color_black, fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              '编号：${concept.code}',
              style:
              TextStyle(color: MyColors.color_black, fontSize: 12),
            ),
          )
        ],
      ),
    );


    return Card(
      child: ListTile(
        leading: folderIcon,
        title: title,
        subtitle: subtitle,
        trailing: expandButton,
      ),
    );
  }
}
