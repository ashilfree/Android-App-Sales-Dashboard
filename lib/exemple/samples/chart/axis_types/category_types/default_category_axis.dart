/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the column chart with default category axis.
class CategoryDefault extends SampleView {
  /// Creates the column chart with default category x axis.
  const CategoryDefault(Key key) : super(key: key);

  @override
  _CategoryDefaultState createState() => _CategoryDefaultState();
}

/// State class of the column chart with default category x-axis.
class _CategoryDefaultState extends SampleViewState {
  _CategoryDefaultState();

  @override
  Widget build(BuildContext context) {
    return _getDefaultCategoryAxisChart();
  }

  /// Returns the column chart with default category x-axis.
  SfCartesianChart _getDefaultCategoryAxisChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Internet Users - 2016'),
      plotAreaBorderWidth: 0,

      /// X axis as category axis placed here.
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          minimum: 0, maximum: 80, isVisible: false, labelFormat: '{value}M'),
      series: _getDefaultCategory(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartSampleData, String>> _getDefaultCategory() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'South\nKorea', yValue: 39, pointColor: Colors.teal[300]),
      ChartSampleData(
          x: 'India',
          yValue: 20,
          pointColor: const Color.fromRGBO(53, 124, 210, 1)),
      ChartSampleData(x: 'South\nAfrica', yValue: 61, pointColor: Colors.pink),
      ChartSampleData(x: 'China', yValue: 65, pointColor: Colors.orange),
      ChartSampleData(x: 'France', yValue: 45, pointColor: Colors.green),
      ChartSampleData(
          x: 'Saudi\nArabia', yValue: 10, pointColor: Colors.pink[300]),
      ChartSampleData(x: 'Japan', yValue: 16, pointColor: Colors.purple[300]),
      ChartSampleData(
          x: 'Mexico',
          yValue: 31,
          pointColor: const Color.fromRGBO(127, 132, 232, 1))
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      )
    ];
  }
}
