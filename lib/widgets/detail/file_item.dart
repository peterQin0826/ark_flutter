import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FileItem extends StatefulWidget {
  String objKey;
  String proName;
  Dt file;

  FileItem(this.objKey, this.proName, this.file);

  @override
  FileItemState createState() => new FileItemState();
}

class FileItemState extends State<FileItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteName.file_item_edit_view,
            arguments: [widget.objKey, widget.proName, widget.file]).then((value){
              if(null!=value){
                Dt file =value ;
                widget.file.title=file.title;
                widget.file.info=file.info;
                widget.file.content=file.content;
                widget.file.time=file.time;
                setState(() {

                });
              }
        });
      },
      child: Container(
        color: MyColors.white,
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Hero(
              tag: widget.file,
              child: Container(
                child: Center(
                  child: Image(
                    image: ImageUtils.getAssetImage(ImageUtils.getFileResource(
                        Utils.getIndexName(widget.file.info, 1))),
                    width: 19,
                    height: 19,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        widget.file.title,
                        style: TextStyle(
                            fontSize: 18, color: MyColors.color_black),
                      ),
                    ),
                    Text(
                      Utils.getIndexName(widget.file.info, 3),
                      style:
                          TextStyle(fontSize: 14, color: MyColors.color_6E757C),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            DateUtils.formatDateMsByYMDHM(widget.file.time),
                            style: TextStyle(
                                fontSize: 12, color: MyColors.color_6E757C),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              Utils.getIndexName(widget.file.info, 2),
                              style: TextStyle(
                                  fontSize: 12, color: MyColors.color_6E757C),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Center(
                child: Image.asset(
                  Utils.getImgPath('img_file_download'),
                  width: 19,
                  height: 19,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
