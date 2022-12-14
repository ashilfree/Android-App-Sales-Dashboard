/// Package imports
import 'package:flutter/material.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Render the semi pie series.
class PieSemi extends SampleView {
  /// Creates the semi pie series.
  const PieSemi(Key key) : super(key: key);

  @override
  _PieSemiState createState() => _PieSemiState();
}

class _PieSemiState extends SampleViewState {
  _PieSemiState();
  int _startAngle = 270;
  int _endAngle = 90;

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Start Angle  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    minValue: 90,
                    maxValue: 270,
                    initialValue: _startAngle.toDouble(),
                    onChanged: (double val) => setState(() {
                      _startAngle = val.toInt();
                    }),
                    step: 10,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text('End Angle ',
                    style: TextStyle(fontSize: 16.0, color: model.textColor)),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    minValue: 90,
                    maxValue: 270,
                    initialValue: _endAngle.toDouble(),
                    onChanged: (double val) => setState(() {
                      _endAngle = val.toInt();
                    }),
                    step: 10,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getSemiPieChart();
  }

  /// Return the circular chart with semi pie series.
  SfCircularChart _getSemiPieChart() {
    return SfCircularChart(
      centerY: '60%',
      title: ChartTitle(
          text: isCardView ? '' : 'Rural population of various countries'),
      legend: Legend(
          isVisible: !isCardView, overflowMode: LegendItemOverflowMode.wrap),
      series: _getSemiPieSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, format: 'point.x : point.y%'),
    );
  }

  /// Return the semi pie series.
  List<PieSeries<ChartSampleData, String>> _getSemiPieSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Algeria', y: 28),
      ChartSampleData(x: 'Australia', y: 14),
      ChartSampleData(x: 'Bolivia', y: 31),
      ChartSampleData(x: 'Cambodia', y: 77),
      ChartSampleData(x: 'Canada', y: 19),
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.x,

          /// If we set start and end angle given below
          /// it will render as semi pie chart.
          startAngle: _startAngle ?? 270,
          endAngle: _endAngle ?? 90,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.inside))
    ];
  }
}
