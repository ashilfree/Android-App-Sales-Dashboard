import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../providers/turnover.dart';
import '../progress_button.dart';

class TurnoverChart extends StatefulWidget {
  @override
  _TurnoverChartState createState() => _TurnoverChartState();
}

class _TurnoverChartState extends State<TurnoverChart> {
  @override
  Widget build(BuildContext context) {
    final turnover = Provider.of<Turnover>(context);
    return (turnover.turnovers.isEmpty)
            ? Center(
                child: ProgressButtonDemo(() => turnover.fetchAndSetTurnover({
                      "first_date": turnover.firstPickedDate,
                      "last_date": turnover.lastPickedDate
                    })),
              )
            : SfCartesianChart(
                zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    enablePanning: true,
                    enableMouseWheelZooming: false,
                    zoomMode: ZoomMode.x),
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

  List<AreaSeries<TurnoverItem, DateTime>> getDefaultPanningSeries() {
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
    return <AreaSeries<TurnoverItem, DateTime>>[
      AreaSeries<TurnoverItem, DateTime>(
          dataSource: getDateTimeData(),
          xValueMapper: (TurnoverItem sales, _) => sales.date,
          yValueMapper: (TurnoverItem sales, _) => sales.turnover,
          gradient: gradientColors,
          name: 'Chiffre D\'Affaire')
    ];
  }

  /// Method to get chart data points.
  List<TurnoverItem> getDateTimeData() {
    return Provider.of<Turnover>(context).turnovers;
  }
}
