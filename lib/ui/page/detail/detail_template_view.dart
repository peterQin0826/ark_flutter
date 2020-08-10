import 'package:ark/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailTemplate extends StatelessWidget {
  String type;

  DetailTemplate({this.type});

  @override
  Widget build(BuildContext context) {
    String templateString;
    String introduceString;
    switch (type) {
      case 'bm':
        introduceString = "key和value都不能为空";
        templateString = "刘德华##演员\n" +
            "百度##网站\n" +
            "微博##软件\n" +
            "微博12##软件\n" +
            "微博122##软件\n" +
            "微博11##软件\n" +
            "微博13##软件\n" +
            "微博14##软件\n" +
            "微博115##软件\n" +
            "微博16##软件\n" +
            "微博17##软件\n" +
            "微博18##软件";
        break;
      case "bf":
        introduceString = "key和value不能为空，且value必须是实数（整数/浮点数";
        templateString = "刘德华##45\n" +
            "梁朝伟##33\n" +
            "成龙#44\n" +
            "李连杰##44\n" +
            "刘德华1##12\n" +
            "刘德华2##33\n" +
            "刘德华3##88\n" +
            "刘德华4##66\n" +
            "刘德华5##55\n" +
            "刘德华6##44\n" +
            "刘德华7##23\n" +
            "刘德华8##44";
        break;
      case "txt":
        introduceString = "时间字符串(必填)##conten（必填）##title（可选项）##info（可选项）";
        templateString = "2010-02-01 11:08:12##这是内容##这是标题##这是介绍\n" +
            "2011-02-01 9:12:01##这是内容12##没有标题##没有内容\n" +
            "2012-12-01 9:12:01##这是内容13##没有标题##没有内容\n" +
            "2013-02-01 9:12:01##这是内容14##没有标题##没有内容\n" +
            "2014-02-01 9:12:01##这是内容151##没有标题##没有内容\n" +
            "2015-02-01 9:12:01##这是内容161##没有标题##没有内容\n" +
            "2015-03-01 9:12:01##这是内容171##没有标题##没有内容\n" +
            "2015-04-01 9:12:01##这是内容181##没有标题##没有内容\n" +
            "2015-05-01 9:12:01##这是内容191##没有标题##没有内容\n" +
            "2015-06-01 9:12:01##这是内容201##没有标题##没有内容\n" +
            "2015-07-01 9:12:01##这是内容211##没有标题##没有内容\n" +
            "2016-08-01 9:12:01##这是内容221##没有标题##没有内容\n" +
            "2016-09-01 9:12:01##这是内容231##没有标题##没有内容\n" +
            "2016-10-01 9:12:01##这是内容241##没有标题##没有内容\n" +
            "2016-11-01 9:12:01##这是内容251##没有标题##没有内容\n" +
            "2017-12-01 9:12:01##这是内容261##没有标题##没有内容\n" +
            "2017-12-11 9:12:01##这是内容271##没有标题##没有内容\n" +
            "2017-12-21 9:12:01##这是内容281##没有标题##没有内容\n" +
            "2020-12-01 9:12:01##这是内容291##没有标题##没有内容";
        break;
      case "time":
        introduceString = "时间字符串(必填)##conten（必须为数字）##title（可选项）##info（可选项）";
        templateString = "2010-02-01 11:08:12##11##这是标题##这是介绍\n" +
            "2011-02-01 9:12:01##12##没有标题##没有内容\n" +
            "2012-12-01 9:12:01##13##没有标题##没有内容\n" +
            "2013-02-01 9:12:01##14##没有标题##没有内容\n" +
            "2014-02-01 9:12:01##15##没有标题##没有内容\n" +
            "2015-02-01 9:12:01##161##没有标题##没有内容\n" +
            "2015-03-01 9:12:01##171##没有标题##没有内容\n" +
            "2015-04-01 9:12:01##181##没有标题##没有内容\n" +
            "2015-05-01 9:12:01##191##没有标题##没有内容\n" +
            "2015-06-01 9:12:01##201##没有标题##没有内容\n" +
            "2015-07-01 9:12:01##211##没有标题##没有内容\n" +
            "2016-08-01 9:12:01##221##没有标题##没有内容\n" +
            "2016-09-01 9:12:01##231##没有标题##没有内容\n" +
            "2016-10-01 9:12:01##241##没有标题##没有内容\n" +
            "2016-11-01 9:12:01##251##没有标题##没有内容\n" +
            "2017-12-01 9:12:01##261##没有标题##没有内容\n" +
            "2017-12-11 9:12:01##271##没有标题##没有内容\n" +
            "2017-12-21 9:12:01##281##没有标题##没有内容\n" +
            "2020-12-01 9:12:01##291##没有标题##没有内容";
        break;
      case "relation":
        introduceString = "对象名字1##对象名字2##概念名字1##概念名字2##关系数字##分数##单向/双向";
        templateString = "刘德华##追龙##演员##电影##12##100#false";
        break;
    }
    TextEditingController controller = TextEditingController();
    controller.text = templateString;

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('数据模板页面'),
      ),
      body: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              introduceString,
              style: TextStyle(color: MyColors.color_black, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side:
                          BorderSide(color: MyColors.color_B2B5C0, width: 1))),
              child: TextField(
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(color: MyColors.color_black, fontSize: 16),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  Clipboard.setData(ClipboardData(text: templateString));
                },
                child: Container(
                  height: 30,
                  decoration: ShapeDecoration(
                      color: MyColors.color_1246FF,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      )),
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Center(
                    child: Text(
                      '复制到剪切板',
                      style: TextStyle(color: MyColors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: ''));
                },
                child: Container(
                  height: 30,
                  decoration: ShapeDecoration(
                      color: MyColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                          side: BorderSide(
                              color: MyColors.color_1246FF, width: 1))),
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Center(
                    child: Text(
                      '清除剪切板',
                      style:
                          TextStyle(color: MyColors.color_1246FF, fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
//      bottomNavigationBar: BottomAppBar(
//        child: Column(
//          children: <Widget>[
//            GestureDetector(
//              child: Container(
//                decoration: ShapeDecoration(
//                    color: MyColors.color_1246FF,
//                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),)),
//                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                child: Center(
//                  child: Text(
//                    '复制到剪切板',
//                    style: TextStyle(color: MyColors.white, fontSize: 16),
//                  ),
//                ),
//              ),
//            ),
//            GestureDetector(
//              child: Container(
//                decoration: ShapeDecoration(
//                    color: MyColors.white,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(7),
//                        side: BorderSide(
//                            color: MyColors.color_1246FF, width: 1))),
//                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                child: Center(
//                  child: Text(
//                    '清除剪切板',
//                    style:
//                        TextStyle(color: MyColors.color_1246FF, fontSize: 16),
//                  ),
//                ),
//              ),
//            )
//          ],
//        ),
//      ),
    );
  }
}
