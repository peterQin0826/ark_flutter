
import 'package:ark/bean/short_property.dart';
import 'package:ark/res/colors.dart';
import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {

  ShortProperty property;


  InfoItem(this.property);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 5, bottom: 5),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 84,
            child: Text(
              property.key,
              style: TextStyle(
                  color: MyColors
                      .color_black,
                  fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 10),
              child: Text(
                property.value,
                style: TextStyle(
                    color: MyColors
                        .color_6E757C,
                    fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }
}