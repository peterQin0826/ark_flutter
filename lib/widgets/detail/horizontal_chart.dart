import 'package:ark/bean/property_list_bean.dart';
import 'package:ark/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HorizontalChart extends StatefulWidget {
  PropertyListBean property;

  HorizontalChart({this.property});

  @override
  HorizontalChartState createState() => new HorizontalChartState();
}

ZoomPanBehavior zoomingBehavior;

class HorizontalChartState extends State<HorizontalChart> {
  ZoomMode _zoomModeType = ZoomMode.x;

  @override
  Widget build(BuildContext context) {
    zoomingBehavior = ZoomPanBehavior(

        /// To enable the pinch zooming as true.
        enablePinching: true,
        zoomMode: _zoomModeType,
        enablePanning: true,
        enableMouseWheelZooming: false);
    return getHorizantalGradientAreaChart();
  }

  SfCartesianChart getHorizantalGradientAreaChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
          labelPlacement: LabelPlacement.onTicks,
          interval: null,
          labelRotation: -15,
          majorGridLines: MajorGridLines(width: 0)),
      series: getGradientAreaSeries(),
      tooltipBehavior: TooltipBehavior(enable: true, canShowMarker: true),
      zoomPanBehavior: zoomingBehavior,
    );
  }

  List<ChartSeries<_ChartData, String>> getGradientAreaSeries() {
    /// 构建 x，y 轴的数据

    List<_ChartData> chartData = List();
    if (widget.property != null &&
        widget.property.data != null &&
        widget.property.data.dt != null &&
        widget.property.data.dt.length > 0) {
      for (var dt in widget.property.data.dt) {
        chartData.add(_ChartData(x: dt.time.toString(), y: dt.content));
      }
    }
    final List<double> stops = <double>[];
    stops.add(0.2);
    stops.add(0.7);

    return <ChartSeries<_ChartData, String>>[
      SplineAreaSeries<_ChartData, String>(
        /// To set the gradient colors for border here.
        borderGradient: LinearGradient(List: <Color>[
          Color.fromRGBO(18, 70, 255, 1),
          Color.fromRGBO(18, 70, 255, 1)
        ]),

        /// To set the gradient colors for series.
        gradient: LinearGradient(List: <Color>[
          Color.fromRGBO(225, 225, 225, 0.5),
          Color.fromRGBO(18, 70, 255, 0.64)
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        borderWidth: 2,
        markerSettings: MarkerSettings(
            isVisible: true,
            height: 8,
            width: 8,
            borderColor: Colors.white,
            color: MyColors.color_1246FF,
            borderWidth: 2),
        borderDrawMode: BorderDrawMode.top,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => double.parse(sales.y),
        name: 'Investment',
      )
    ];
  }

  @override
  void initState() {
    _zoomModeType = ZoomMode.x;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class _ChartData {
  _ChartData({this.x, this.y});

  final String x;
  final String y;
}
