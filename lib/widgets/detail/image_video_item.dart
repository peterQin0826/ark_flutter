import 'dart:convert';

import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/configs/router_manager.dart';
import 'package:ark/model/detail_pro_model.dart';
import 'package:ark/model/image_video_list_model.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:ark/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../confirmDialog.dart';

class ImageVideoItem extends StatefulWidget {
  String objKey;
  String proName;
  String type;
  Dt imgContent;
  int index;

  ImageVideoItem(this.objKey, this.proName, this.type, this.imgContent,this.index);

  @override
  ImageVideoItemState createState() => new ImageVideoItemState();
}

CommonProListModel model;
DetailProModel detailProModel;

class ImageVideoItemState extends State<ImageVideoItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    String imgUrl;
    if (widget.type == Constant.image) {
      imgUrl = ImageUtils.getImgUrl(widget.imgContent.content);
    } else {
      imgUrl =
          ImageUtils.getImgUrl(widget.imgContent.content + Constant.videoCover);
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: MyColors.white),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                /// 矩形剪裁 => ClipRRect;      圆形 剪裁 => ClipOval()
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, img) => CircularProgressIndicator(),
                    height: 175,
                    width: 175,
                  ),
                ),
                Positioned(
                  child: GestureDetector(
                      onTap: () {

                        print('删除条目');
                        List<int> idList = List();
                        idList.add(widget.imgContent.id);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ConfirmDialog(
                                content: '确定要删除？',
                                confirmClicked: () {
                                  model
                                      .deleteItem(json.encode(idList))
                                      .then((value) {
                                    if (value) {
                                      Toast.show('删除成功');
                                      model.list.removeAt(widget.index);
                                      detailProModel.deleteListItem(
                                          widget.imgContent.id, widget.proName);
                                    }
                                  });
                                },
                              );
                            });
                      },
                      child: Image.asset(
                        Utils.getImgPath('img_close'),
                        width: 18,
                        height: 18,
                      )),
                )
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, RouteName.img_video_item_edit,
                  arguments: [
                    widget.objKey,
                    widget.proName,
                    widget.imgContent,
                    widget.type
                  ]).then((value) {
                if (null != value) {
                  Dt dt = value as Dt;
                  widget.imgContent.info = dt.info;
                  widget.imgContent.title = dt.title;
                  widget.imgContent.content = dt.content;
                  widget.imgContent.time = dt.time;
                  setState(() {});
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.imgContent.title != null
                        ? widget.imgContent.title
                        : '',
                    style: TextStyle(
                        color: MyColors.color_black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      Utils.getIndexName(widget.imgContent.info, 3).isNotEmpty
                          ? Utils.getIndexName(widget.imgContent.info, 3)
                          : '',
                      style: TextStyle(
                        color: MyColors.color_2E333C,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      DateUtils.formatDateMsByYMDHM(widget.imgContent.time),
                      style:
                          TextStyle(color: MyColors.color_697796, fontSize: 12),
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

  @override
  void initState() {
    model = Provider.of(context, listen: false);
    detailProModel = Provider.of(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
