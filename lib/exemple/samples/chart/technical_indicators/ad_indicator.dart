/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC chart with Accumulation distribution indicator samples.
class AdIndicator extends SampleView {
  /// creates the OHLC chart with Accumulation distribution indicator.
  const AdIndicator(Key key) : super(key: key);

  @override
  _AdIndicatorState createState() => _AdIndicatorState();
}

/// State class of the OHLC chart with Accumulation distribution indicator.
class _AdIndicatorState extends SampleViewState {
  _AdIndicatorState();

  @override
  Widget build(BuildContext context) {
    return _getDefaultAdIndicator();
  }

  /// Returns the OHLC chart with Accumulation distribution indicator.
  SfCartesianChart _getDefaultAdIndicator() {
    final List<ChartSampleData> chartData = getChartData();
    return SfCartesianChart(
      legend: Legend(isVisible: !isCardView),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        dateFormat: DateFormat.MMM(),
        interval: 3,
        minimum: DateTime(2016, 01, 01),
        maximum: DateTime(2017, 01, 01),
      ),
      primaryYAxis: NumericAxis(
          minimum: 70,
          maximum: 130,
          interval: 20,
          labelFormat: '\${value}',
          axisLine: AxisLine(width: 0)),
      axes: <ChartAxis>[
        NumericAxis(
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          opposedPosition: true,
          name: 'yaxes',
          minimum: -5000000000,
          maximum: 5000000000,
          interval: 2500000000,
          numberFormat: NumberFormat.compact(),
        )
      ],
      trackballBehavior: TrackballBehavior(
        enable: !isCardView,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      ),
      tooltipBehavior: TooltipBehavior(enable: isCardView ? true : false),
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        /// AD indicator mentioned here.
        AccumulationDistributionIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
          yAxisName: 'yaxes',
        ),
      ],
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      series: <ChartSeries<ChartSampleData, DateTime>>[
        HiloOpenCloseSeries<ChartSampleData, DateTime>(
            emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
            dataSource: chartData,
            opacity: 0.7,
            xValueMapper: (ChartSampleData sales, _) => sales.x,
            lowValueMapper: (ChartSampleData sales, _) => sales.low,
            highValueMapper: (ChartSampleData sales, _) => sales.high,
            openValueMapper: (ChartSampleData sales, _) => sales.open,
            closeValueMapper: (ChartSampleData sales, _) => sales.close,
            volumeValueMapper: (ChartSampleData sales, _) => sales.volume,
            name: 'AAPL'),
      ],
    );
  }
}
