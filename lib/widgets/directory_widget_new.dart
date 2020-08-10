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

class DirectoryWidget extends StatefulWidget {

  final CatalogListBean concept;
  final VoidCallback onPressedNext;

  const DirectoryWidget({Key key, @required this.concept, this.onPressedNext}) : super(key: key);


  @override
  DirectoryWidgetState createState() => new DirectoryWidgetState();
}

class DirectoryWidgetState extends State<DirectoryWidget> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation animation;

  @override
  Widget build(BuildContext context) {
    Image folderIcon = Image(
      image: AssetImage("assets/images/folder.png"),
      width: 15,
      height: 13,
    );

//    IconButton expandButton = IconButton(
//      icon: Image(
//        image: AssetImage('assets/images/folder_open.png'),
//        width: 12,
//        height: 12,
//      ),
//      onPressed: (){
//        widget.onPressedNext();
//      },
//    );
    RotationTransition transition =RotationTransition(
      turns: animationController,
      child: IconButton(
        icon: Image(
          image: AssetImage('assets/images/folder_click_in.png'),
          width: 12,
          height: 12,
        ),
        onPressed: (){
          animationController.forward();
          widget.onPressedNext();
        },
      )
    );

    Row title= Row(
      children: <Widget>[
        Text(
         widget. concept.conceptName,
          style: TextStyle(color: MyColors.color_010A29, fontSize: 16),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            '子概念：${widget.concept.childrenNumber}',
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
            '总数：${widget.concept.objectsNumber}',
            style: TextStyle(color: MyColors.color_black, fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              '编号：${widget.concept.code}',
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
        trailing: transition,
      ),
    );
  }
  @override
  void initState() {
    animationController=new AnimationController(
        duration: Duration(seconds: 1),
        vsync:this
    );

    super.initState();

  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();

  }




}
