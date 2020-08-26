
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  String content;
  onConfirmClicked confirmClicked;


  ConfirmDialog({this.content, this.confirmClicked});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
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
            Navigator.of(context).pop(true);
            if(confirmClicked!=null){
              confirmClicked();
            }
          },
        )
      ],
    );
  }
}

typedef onConfirmClicked =void Function();