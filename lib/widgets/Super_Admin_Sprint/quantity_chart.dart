import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../providers/quantity.dart';
import '../progress_button.dart';

class QuantityChart extends StatefulWidget {
  @override
  _QuantityChartState createState() => _QuantityChartState();
}

class _QuantityChartState extends State<QuantityChart> {
  @override
  Widget build(BuildContext context) {
    final quantity = Provider.of<Quantity>(context);
    return (quantity.quantities.isEmpty)
            ? Center(
                child: ProgressButtonDemo(() => quantity.fetchAndSetQuantity({
                      "first_date": quantity.firstPickedDate,
                      "last_date": quantity.lastPickedDate
                    })),
              )
            : SfCartesianChart(
                plotAreaBorderWidth: 0,
                zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    enablePanning: true,
                    enableMouseWheelZooming: false,
                    zoomMode: ZoomMode.x),
                legend: Legend(
                    isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                primaryXAxis: DateTimeAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    enableAutoIntervalOnZooming: true),
                primaryYAxis: NumericAxis(
                    axisLine: AxisLine(width: 0),
                    labelFormat: '{value} To',
                    majorTickLines: MajorTickLines(size: 0)),
                tooltipBehavior: TooltipBehavior(enable: true),
                series:
                    getDefaultPanningSeries()) // This trailing comma makes auto-formatting nicer for build methods.
        ;
  }

  List<StackedColumnSeries<QuantityItem, DateTime>> getDefaultPanningSeries() {
    final List<Color> color = <Color>[];
    color.add(Colors.teal[50]);
    color.add(Colors.teal[200]);
    color.add(Colors.teal);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.4);
    stops.add(1.0);

    final LinearGradient gradientColors = LinearGradient(
        colors: color,
        stops: stops,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);
    return <StackedColumnSeries<QuantityItem, DateTime>>[
      StackedColumnSeries<QuantityItem, DateTime>(
          dataSource: getDateTimeData(),
          xValueMapper: (QuantityItem sales, _) => sales.x,
          yValueMapper: (QuantityItem sales, _) => sales.y,
          name: 'RAB'),
      StackedColumnSeries<QuantityItem, DateTime>(
          dataSource: getDateTimeData(),
          xValueMapper: (QuantityItem sales, _) => sales.x,
          yValueMapper: (QuantityItem sales, _) => sales.yValue,
          name: 'FML'),
    ];
  }

  /// Method to get chart data points.
  List<QuantityItem> getDateTimeData() {
    return Provider.of<Quantity>(context).quantities;
  }
}
