
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxListTitle extends StatefulWidget {
  @override
  CheckboxListTitleState createState() => new CheckboxListTitleState();
}

class CheckboxListTitleState extends State<CheckboxListTitle> {

  bool _isSelected =false;
  num _clickPos=-1;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('测试box'),
      ),
      body: ListView(
        children: <Widget>[
          CheckboxListTile(
            value:getSelected(0),
            onChanged:(isCheck) {
              _clickPos=0;
              print('是否选中: $isCheck');
              setState(() {
                getSelected(0);
              });
            },
            activeColor: Colors.red,
            title:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('这是title1'),
                Text('这是title'),
                Text('这是title'),
                Text('这是title'),
              ],
            ),
            //是否要撑满3行
            isThreeLine:false,
            //是否密集
            dense:true,
            selected: true,

            //选择控件放的位置
            controlAffinity:ListTileControlAffinity.platform,
          ),
          CheckboxListTile(
            value:getSelected(1),
            onChanged:(isCheck) {
              print('是否选中: $isCheck');
              setState(() {
                getSelected(1);
              });
            },
            activeColor: Colors.red,
            title:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('这是title 2 哈哈哈哈ashdklahsd ashd dalskhd 沙隆达哈克龙商家互动熬点还是后端'),
                Text('这是title'),
                Text('这是title'),
                Text('这是title'),
              ],
            ),
            //是否要撑满3行
            isThreeLine:false,
            //是否密集
            dense:true,
            selected: true,

            secondary:CircleAvatar(child: Icon(Icons.android),),
            //选择控件放的位置
            controlAffinity:ListTileControlAffinity.trailing,
          ),
          CheckboxListTile(
            value:getSelected(2),
            onChanged:(isCheck) {
              print('是否选中: $isCheck');
              setState(() {
                getSelected(2);
              });
            },
            activeColor: Colors.red,
            title:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('这是title3'),
                Text('这是title'),
                Text('这是title'),
                Text('这是title'),
              ],
            ),
            //是否要撑满3行
            isThreeLine:false,
            //是否密集
            dense:true,
            selected: true,

            secondary:CircleAvatar(child: Icon(Icons.android),),
            //选择控件放的位置
            controlAffinity:ListTileControlAffinity.platform,
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

 bool getSelected(int i) {
    if(_clickPos==i){
      return true;
    }else{
      return false;
    }
 }
}