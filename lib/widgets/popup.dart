import 'package:ark/res/colors.dart';
import 'package:flutter/material.dart';

///  自定义 对象详情页 新建弹框

class Popup extends StatelessWidget {
  final Function(String name) onClick;
  final double right;
  final double top;
  final List<String> data;

  Popup({@required this.data, this.onClick, this.right, this.top});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: MyColors.black_16,
            ),
            Positioned(
              child: Container(
                alignment: Alignment.topLeft,
                width: 100,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      String name = data[index];
                      return InkWell(
                        onTap: () {
                          if (onClick != null) {
                            Navigator.of(context).pop();
                            onClick(name);
                          }
                        },
                        child: Container(
                          color: MyColors.white,
                          padding: index == 0
                              ? EdgeInsets.only(top: 15, bottom: 15)
                              : EdgeInsets.only(bottom: 15),
                          child: Center(
                            child: Text(
                              name,
                              style: TextStyle(
                                  color: MyColors.color_010A29,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              right: right,
              top: top,
            )
          ],
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
