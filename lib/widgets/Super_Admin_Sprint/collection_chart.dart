import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../providers/collection.dart';
import '../progress_button.dart';

class CollectionChart extends StatefulWidget {
  @override
  _CollectionChartState createState() => _CollectionChartState();
}

class _CollectionChartState extends State<CollectionChart> {
  @override
  Widget build(BuildContext context) {
    final collection = Provider.of<Collection>(context);
    return (collection.collections.isEmpty)
            ? Center(
                child: ProgressButtonDemo(
                  () => collection.fetchAndSetCollection({"first_date":collection.firstPickedDate, "last_date": collection.lastPickedDate})
                ),
              )
            : SfCartesianChart(
                plotAreaBorderWidth: 0,
                zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    enablePanning: true,
                    enableMouseWheelZooming: false,
                    zoomMode: ZoomMode.x),
                /*legend: Legend(
            isVisible: true, overflowMode: LegendItemOverflowMode.wrap),*/
                primaryXAxis: DateTimeAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    enableAutoIntervalOnZooming: true),
                primaryYAxis: NumericAxis(
                    axisLine: AxisLine(width: 0),
                    labelFormat: '{value} Md',
                    majorTickLines: MajorTickLines(size: 0)),
                tooltipBehavior: TooltipBehavior(enable: true),
                series:
                    getDefaultPanningSeries()) // This trailing comma makes auto-formatting nicer for build methods.
        ;
  }

  List<LineSeries<CollectionItem, DateTime>> getDefaultPanningSeries() {
    return <LineSeries<CollectionItem, DateTime>>[
      LineSeries<CollectionItem, DateTime>(
          animationDuration: 2500,
          dataSource: getDateTimeData(),
          xValueMapper: (CollectionItem sales, _) => sales.date,
          yValueMapper: (CollectionItem sales, _) => double.parse((sales.collection/10000000).toStringAsFixed(3)),
          width: 2,
          name: 'Encaissement',
          markerSettings: MarkerSettings(isVisible: true)),
    ];
  }

  /// Method to get chart data points.
  List<CollectionItem> getDateTimeData() {
    return Provider.of<Collection>(context).collections;
  }
}
