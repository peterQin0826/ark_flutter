
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/detail_property_tab.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:flutter/material.dart';

class FileProTab extends StatefulWidget {

  PropertyListBean property;
  String objKey;


  FileProTab(this.property, this.objKey);

  @override
  FileProTabState createState() => new FileProTabState();
}

class FileProTabState extends State<FileProTab> {

  Divider divider = Divider(
    height: 1,
    color: MyColors.color_c5c6ca,
  );

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: MyColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: widget.property.propertyName,
                    type: 8,
                    total: widget.property.total,
                    objKey: widget.objKey,
                    property: widget.property,
                  ),
                  AkaEditWidget(
                    aka: ((null != widget.property.data) ? widget.property.data.na : ""),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.property.data.dt.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, position) {
                return _fileItem(widget.property.data.dt[position]);
              },
              separatorBuilder: (context, position) {
                return divider;
              },
            )
          ],
        ),
      ),
    );
  }
  Widget _fileItem(Dt dt) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: ImageUtils.getAssetImage(
                ImageUtils.getFileResource(Utils.getIndexName(dt.info, 1))),
            width: 19,
            height: 19,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      dt.title + '.' + Utils.getIndexName(dt.info, 1),
                      style:
                      TextStyle(color: MyColors.color_black, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      Utils.getIndexName(dt.info, 3),
                      style:
                      TextStyle(color: MyColors.color_6E757C, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          DateUtils.formatDateMsByYMDHM(dt.time),
                          style: TextStyle(
                              color: MyColors.color_6E757C, fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            Utils.getIndexName(dt.info, 2),
                            style: TextStyle(
                                color: MyColors.color_6E757C, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}