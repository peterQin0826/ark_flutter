
import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/common/common.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/ui/page/detail/detail_property_tab.dart';
import 'package:ark/utils/date_utils.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VideoProTab extends StatefulWidget {

  PropertyListBean property;
  String objKey;


  VideoProTab(this.property, this.objKey);

  @override
  VideoProTabState createState() => new VideoProTabState();
}

class VideoProTabState extends State<VideoProTab>  with AutomaticKeepAliveClientMixin{

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
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10, top: 15),
                    child: Column(
                      children: <Widget>[
                        TitleRow(
                          title: widget.property.propertyName,
                          type: 5,
                          total: widget.property.total,
                          objKey: widget.objKey,
                          property: widget.property,
                        ),
                        AkaEditWidget(
                          aka:
                          ((null != widget.property.data) ? widget.property.data.na : ""),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.property.data.dt.length,
                      itemBuilder: (context, position) {
                        Dt video = widget.property.data.dt[position];
                        return Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    child: Hero(
                                      tag: video,
                                      child: CachedNetworkImage(
                                          width:
                                          MediaQuery.of(context).size.width,
                                          height: 200,
                                          imageUrl: ImageUtils.getImgUrl(
                                              video.content +
                                                  Constant.videoCover),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                Utils.getImgPath('img_empty'),
                                                fit: BoxFit.cover,
                                              )),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  Positioned(
                                    left:
                                    MediaQuery.of(context).size.width / 2 -
                                        20,
                                    top: 80,
                                    width: 45,
                                    height: 45,
                                    child: Image.asset(
                                        Utils.getImgPath('jz_play_normal')),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    null != widget.property.data.dt[position].title
                                        ? Text(
                                      widget.property.data.dt[position].title,
                                      style: TextStyle(
                                          color: MyColors.color_040404,
                                          fontWeight: FontWeight.bold),
                                    )
                                        : Container(
                                      width: 0,
                                      height: 0,
                                    ),
                                    Image.asset(
                                      Utils.getImgPath('img_file_download'),
                                      width: 18,
                                      height: 19,
                                    )
                                  ],
                                ),
                              ),
                              Utils.getIndexName(
                                  widget.property.data.dt[position].info, 3)
                                  .isNotEmpty
                                  ? Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  Utils.getIndexName(
                                      widget. property.data.dt[position].info, 3),
                                  style: TextStyle(
                                      color: MyColors.color_585D7B,
                                      fontSize: 12),
                                ),
                              )
                                  : Container(
                                width: 0,
                                height: 0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 10),
                                child: Text(
                                  DateUtils.formatDateMsByYMDHM(
                                      widget.property.data.dt[position].time),
                                  style:
                                  TextStyle(color: MyColors.color_B2B5C0),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, posirion) {
                        return divider;
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}