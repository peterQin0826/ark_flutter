import 'package:ark/bean/concept_detail_bean.dart';
import 'package:ark/model/concept_detail_model.dart';
import 'package:ark/provider/provider_widget.dart';
import 'package:ark/res/colors.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/utils/image_utils.dart';
import 'package:ark/utils/theme_utils.dart';
import 'package:ark/utils/utils.dart';
import 'package:ark/widgets/ark_skeleton.dart';
import 'package:ark/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ConceptDetailView extends StatefulWidget {
  String code;

  ConceptDetailView({this.code});

  @override
  ConceptDetailViewState createState() => new ConceptDetailViewState();
}

class ConceptDetailViewState extends State<ConceptDetailView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        centerTitle: true,
        title: Text(
          '概念详情',
          style: TextStyle(color: MyColors.white, fontSize: 18),
        ),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '新建',
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
            onPressed: () {

            },
          )
        ],
      ),
      body: ProviderWidget<ConceptDetailModel>(
        model: ConceptDetailModel(code: widget.code),
        onModelReady: (model) => model.getConceptDetail(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: MyColors.white,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(15),
                        child: Text(
                          model.conceptDetailBean.parent,
                          style: TextStyle(
                              color: MyColors.color_585D7B, fontSize: 12),
                        )),
                    Container(
                      color: MyColors.color_f5f5f5,
                      height: 5,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: ImageUtils.getImgUrl(
                                    model.conceptDetailBean.image),
                                placeholder: (context, img) {
                                  return Image.asset(
                                      Utils.getImgPath('img_empty'));
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 10),
                              height: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          model.conceptDetailBean.conceptName,
                                          style: TextStyle(
                                              color: MyColors.color_black,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Image(
                                        image: ImageUtils.getAssetImage(
                                            'edit_img'),
                                        width: 18,
                                        height: 18,
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Text(
                                      model.conceptDetailBean.aka.isEmpty
                                          ? ""
                                          : '别称：${model.conceptDetailBean.aka}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: MyColors.color_010101),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    padding: EdgeInsets.fromLTRB(8, 0, 8, 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: MyColors.color_759DFF,
                                            width: 1)),
                                    child: Text(
                                      '对象数量：${model.conceptDetailBean.objectsNumber}个',
                                      style: TextStyle(
                                          color: MyColors.color_759DFF,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 5, left: 15),
                      child: Text(
                        '简介：',
                        style: TextStyle(
                            color: MyColors.color_black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        model.conceptDetailBean.summary,
                        style: TextStyle(
                            color: MyColors.color_black, fontSize: 16),
                      ),
                    )
                  ],
                ),
                Positioned(
                  left: 60,
                  right: 60,
                  bottom: 30,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: MyColors.color_1246FF,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                            child: Text(
                          '移动概念',
                          style: TextStyle(color: MyColors.white, fontSize: 18),
                        )),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 42,
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            color: MyColors.color_D7DADE,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                              child: Text(
                            '删除概念',
                            style: TextStyle(color: MyColors.red, fontSize: 18),
                          )),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
