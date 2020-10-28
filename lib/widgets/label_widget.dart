import 'package:ark/bean/short_property.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/confirmDialog.dart';
import 'package:ark/widgets/input_dialog.dart';
import 'package:flutter/material.dart';

/// 自定义标签
class LabelWidget extends StatefulWidget {
  List<ShortProperty> list;
  bool isAdd;

  LabelWidget({this.list, this.isAdd});

  @override
  LabelWidgetState createState() => new LabelWidgetState();
}

class LabelWidgetState extends State<LabelWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10,
      children: _labelWidgets(widget.list),
    );
  }

  List<Widget> _labelWidgets(List<ShortProperty> labels) {
    List<Widget> widgets = List();
    if (labels != null && labels.length > 0) {
      for (var label in labels) {
        widgets.add(Chip(
          label: Text(
            '${label.key} ：${label.value}',
            style: TextStyle(color: MyColors.color_7B81A9, fontSize: 11),
          ),
          deleteIcon: Image.asset(
            Utils.getImgPath('delete_relation'),
            width: 15,
            height: 15,
          ),
          onDeleted: () {
            print('删除标签');
            showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                    content: '是否要删除关联标签？',
                    confirmClicked: () {
                      List<String> removeList = List();
                      removeList.add(label.key);

                      widget.list.remove(label);
                      setState(() {});
                    },
                  );
                });
          },
        ));
      }
    }
      if (widget.isAdd) {
        widgets.add(Chip(
          label: Text('添加'),
          deleteIcon: Image.asset(
            Utils.getImgPath('relation_add'),
            width: 15,
            height: 15,
          ),
          onDeleted: () {
            print('添加标签');
            showDialog(
                context: context,
                builder: (context) {
                  return InputTitleDialog('属性名称', '简介',
                      onConfirm: (String title, String content) {
                    print('属性名称:$title ,内容：$content');
                    widget.list.add(ShortProperty(key: title, value: content));
                    setState(() {});
                  });
                });
          },
        ));
      }
    return widgets;
  }
}
