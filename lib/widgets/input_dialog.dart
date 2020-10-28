import 'package:ark/res/colors.dart';
import 'package:ark/utils/string_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputTitleDialog extends StatelessWidget {
  String labelTitle;
  String labelContent;

  Function(String title, String content) onConfirm;

  InputTitleDialog(this.labelTitle, this.labelContent, {this.onConfirm});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    return AlertDialog(
      content: Container(
        height: 200,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: MyColors.white, borderRadius: BorderRadius.circular(5),
              border: Border.all(color: MyColors.color_black,width: 0.5)),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: labelTitle, border: InputBorder.none),
              ),
            ),
            Container(
                height: 120,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(5),
                border: Border.all(color: MyColors.color_black,width: 1)),
                child: TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                      hintText: labelContent, border: InputBorder.none),
                ))
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('确定'),
          onPressed: () {
            if (StringUtils.isEmpty(titleController.text)) {
              Toast.show('属性不能为空');
              return;
            }
            if (StringUtils.isEmpty(contentController.text)) {
              Toast.show('简介不能为空');
              return;
            }
            Navigator.of(context).pop(true);
            if (onConfirm != null) {
              onConfirm(titleController.text, contentController.text);
            }
          },
        )
      ],
    );
  }
}
