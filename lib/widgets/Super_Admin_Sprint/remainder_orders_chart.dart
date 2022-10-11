import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../providers/remainder_orders.dart';
import '../progress_button.dart';

class RemainderOrdersChart extends StatefulWidget {
  @override
  _RemainderOrdersChartState createState() => _RemainderOrdersChartState();
}

class _RemainderOrdersChartState extends State<RemainderOrdersChart> {
  @override
  Widget build(BuildContext context) {
    final remainderOrder = Provider.of<RemainderOrder>(context);
    return (remainderOrder.remainderOrders.isEmpty)
            ? Center(
                child: ProgressButtonDemo(
                    () => remainderOrder.fetchAndSetremainderOrder()),
              )
            : SfPyramidChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(
                    isVisible: false,
                    overflowMode: LegendItemOverflowMode.wrap),
                series:
                    getDefaultPanningSeries()) // This trailing comma makes auto-formatting nicer for build methods.
        ;
  }

  PyramidSeries<RemainderOrderItem, String> getDefaultPanningSeries() {
    return PyramidSeries<RemainderOrderItem, String>(
      dataSource: getDateTimeData(),
      xValueMapper: (RemainderOrderItem sales, _) => sales.ref,
      yValueMapper: (RemainderOrderItem sales, _) => sales.qty,
      pyramidMode: PyramidMode.linear,
      dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.inside,
          textStyle: TextStyle(
            fontSize: 10,
          ),
          // builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          //     int seriesIndex) {
          //   return (pointIndex < 15)
          //       ? null
          //       : Container(height: 30, width: 30, child: Text('To'));
          // }
          ),
    );
  }

  /// Method to get chart data points.
  List<RemainderOrderItem> getDateTimeData() {
    return Provider.of<RemainderOrder>(context).remainderOrders;
  }
}
