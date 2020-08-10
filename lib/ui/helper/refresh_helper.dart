import 'package:ark/generated/l10n.dart';
import 'package:ark/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



/// 通用的footer
///
/// 由于国际化需要context的原因,所以无法在[RefreshConfiguration]配置
class RefresherFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
//      failedText: S.of(context).loadMoreFailed,
//      idleText: S.of(context).loadMoreIdle,
//      loadingText: S.of(context).loadMoreLoading,
      noDataText: "没有更多的数据了",
      textStyle: TextStyle(color: MyColors.color_black,fontSize: 16),
      loadStyle: LoadStyle.ShowWhenLoading,
    );
  }
}
