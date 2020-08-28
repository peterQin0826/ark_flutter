
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/detail_property_tab.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageProTab extends StatefulWidget {


  PropertyListBean property;
  String objKey;


  ImageProTab(this.property, this.objKey);

  @override
  ImageProTabState createState() => new ImageProTabState();
}

class ImageProTabState extends State<ImageProTab> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: MyColors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  TitleRow(
                    title: widget.property.propertyName,
                    type: 4,
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
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: widget.property.data.dt.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) => Column(
                  children: <Widget>[ImageItem(widget.property.data.dt[index])],
                ),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


class ImageItem extends StatefulWidget {
  Dt dt;


  ImageItem(this.dt);

  @override
  ImageItemState createState() => new ImageItemState();
}

class ImageItemState extends State<ImageItem> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: MyColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: ImageUtils.getImgUrl(widget.dt.content),
                fit: BoxFit.cover,
                placeholder: (context, img) => CircularProgressIndicator(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Offstage(
                  offstage: widget.dt.title==null,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      widget.dt.title,
                      style: TextStyle(
                        color: MyColors.color_040404,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),

                Utils.getIndexName(widget.dt.info, 3).isNotEmpty
                    ? Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      Utils.getIndexName(widget.dt.info, 3),
                      style: TextStyle(
                          color: MyColors.color_585D7B, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ))
                    : Container(
                  width: 0,
                  height: 0,
                ),

                /// 时间没有格式化
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    DateUtils.formatDateMsByYMDHM(widget.dt.time),
                    style:
                    TextStyle(color: MyColors.color_989CB6, fontSize: 10),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


