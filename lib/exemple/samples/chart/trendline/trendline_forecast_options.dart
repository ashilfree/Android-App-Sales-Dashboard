/// Package imports
import 'package:flutter/material.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/shared/mobile.dart'
    if (dart.library.html) '../../../widgets/shared/web.dart';

/// Renders the spline chart with trend forcasting sample.
class TrendLineForecast extends SampleView {
  /// Renders the spline chart with trend forcasting sample.
  const TrendLineForecast(Key key) : super(key: key);

  @override
  _TrendLineForecastState createState() => _TrendLineForecastState();
}

/// State class of the spline cahrt with trende forcasting.
class _TrendLineForecastState extends SampleViewState {
  _TrendLineForecastState();
  double _backwardForecastValue = 0.0;
  double _forwardForecastValue = 0.0;

  @override
  void initState() {
    _backwardForecastValue = 0.0;
    _forwardForecastValue = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getTrendLineForecastChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Forward forecast',
                style: TextStyle(fontSize: 16.0, color: model.textColor),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: HandCursor(
                    child: CustomDirectionalButtons(
                      minValue: 0,
                      maxValue: 50,
                      initialValue: _forwardForecastValue,
                      onChanged: (double val) => setState(() {
                        _forwardForecastValue = val;
                      }),
                      step: 1,
                      loop: true,
                      padding: 0,
                      iconColor: model.textColor,
                      style: TextStyle(fontSize: 20.0, color: model.textColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Backward forecast',
                style: TextStyle(fontSize: 16.0, color: model.textColor),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: HandCursor(
                    child: CustomDirectionalButtons(
                      minValue: 0,
                      maxValue: 50,
                      initialValue: _backwardForecastValue,
                      onChanged: (double val) => setState(() {
                        _backwardForecastValue = val;
                      }),
                      step: 1,
                      loop: true,
                      padding: 0,
                      iconColor: model.textColor,
                      style: TextStyle(fontSize: 20.0, color: model.textColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  /// Returns the spline chart with trendline forcating.
  SfCartesianChart _getTrendLineForecastChart() {
    int j = 0;
    final List<ChartSampleData> trendLineData = <ChartSampleData>[];
    final List<double> yValue = <double>[
      1.2,
      1.07,
      0.92,
      0.90,
      0.94,
      1.13,
      1.24,
      1.25,
      1.26,
      1.37,
      1.47,
      1.39,
      1.33,
      1.39,
      1.29,
      1.33,
      1.33,
      1.11,
      1.11,
      1.13,
      1.18,
      1.12
    ];
    for (int i = 1999; i <= 2019; i++) {
      trendLineData.add(ChartSampleData(x: i, y: yValue[j]));
      j++;
    }

    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(
            text: isCardView
                ? ''
                : 'Euro to USD yearly exchange rate - 1999 to 2019'),
        legend: Legend(isVisible: !isCardView),
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis:
            NumericAxis(majorGridLines: MajorGridLines(width: 0), interval: 2),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Dollars'),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          minimum: 0.8,
          maximum: 1.8,
          interval: 0.2,
          labelFormat: '\${value}',
        ),
        series: <SplineSeries<ChartSampleData, num>>[
          SplineSeries<ChartSampleData, num>(
              color: const Color.fromRGBO(192, 108, 132, 1),
              dataSource: trendLineData,
              xValueMapper: (ChartSampleData data, _) => data.x,
              yValueMapper: (ChartSampleData data, _) => data.y,
              markerSettings: MarkerSettings(isVisible: true),
              name: 'Exchange rate',
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.linear,
                    width: 3,
                    dashArray: model.isWeb ? <double>[0, 0] : <double>[10, 10],
                    name: 'Linear',
                    enableTooltip: true,

                    /// Here we mention the forward and backward forecast value.
                    forwardForecast: _forwardForecastValue,
                    backwardForecast: _backwardForecastValue)
              ])
        ]);
  }
}
