/// Dart imports
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the update data source chart sample.
class UpdateDataSource extends SampleView {
  /// Creates the update data source chart sample.
  const UpdateDataSource(Key key) : super(key: key);

  @override
  _LiveVerticalState createState() => _LiveVerticalState();
}

/// State class of the update data source chart.
class _LiveVerticalState extends SampleViewState {
  _LiveVerticalState();

  List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 1, y: 30),
    ChartSampleData(x: 3, y: 13),
    ChartSampleData(x: 5, y: 80),
    ChartSampleData(x: 7, y: 30),
    ChartSampleData(x: 9, y: 72)
  ];
  int count = 11;
  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = 60;
    return Scaffold(
        backgroundColor: model.cardThemeColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(5, 15, 5, bottomPadding),
          child: Container(child: _getUpdateDataSourceChart()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            chartData = <ChartSampleData>[];
            chartData = _getChartData();
          }),
          child: const Icon(Icons.refresh, color: Colors.white),
          backgroundColor: model.backgroundColor,
        ));
  }

  /// Returns the update data source cartesian chart.
  SfCartesianChart _getUpdateDataSourceChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          minimum: 0, interval: 1, majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.additional,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          minorGridLines: MinorGridLines(width: 0)),
      series: _getUpdateDataSourceSeries(),
    );
  }

  /// Returns the list of chart series which need to render
  /// on the update data source chart.
  List<ColumnSeries<ChartSampleData, num>> _getUpdateDataSourceSeries() {
    return <ColumnSeries<ChartSampleData, num>>[
      ColumnSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          dataLabelSettings: DataLabelSettings(isVisible: true)),
    ];
  }

  ///Get the random value
  num _getRandomInt(num min, num max) {
    return min + random.nextInt(max - min);
  }

  List<ChartSampleData> _getChartData() {
    chartData.add(ChartSampleData(x: 1, y: _getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 3, y: _getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 5, y: _getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 7, y: _getRandomInt(10, 100)));
    chartData.add(ChartSampleData(x: 9, y: _getRandomInt(10, 100)));
    return chartData;
  }
}
