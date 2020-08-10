import 'package:flutter/material.dart';

import 'detail/detail_property_tab.dart';
import 'detail/detail_relation_tab.dart';

class DetailTabBarView extends StatefulWidget {
  final TabController tabController;
  final String objKey;
  final String conceptName;

  const DetailTabBarView({this.tabController, this.objKey, this.conceptName});

  @override
  DetailTabBarViewState createState() => new DetailTabBarViewState();
}

class DetailTabBarViewState extends State<DetailTabBarView> {
  @override
  Widget build(BuildContext context) {
    var viewList = [
      DetailPropertyTab(
        objKey: widget.objKey,
        conceptName: widget.conceptName,
      ),
      DetailRelationTab()
    ];

    return TabBarView(
      children: viewList,
      controller: widget.tabController,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
