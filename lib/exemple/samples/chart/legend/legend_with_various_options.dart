/// Package import
import 'package:flutter/material.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/checkbox.dart';
import '../../../widgets/custom_dropdown.dart';

/// Renders the Pie chart with legend
class LegendOptions extends SampleView {
  /// Creates the doughnut chart with legend
  const LegendOptions(Key key) : super(key: key);

  @override
  _LegendOptionsState createState() => _LegendOptionsState();
}

class _LegendOptionsState extends SampleViewState {
  _LegendOptionsState();
  bool toggleVisibility = true;
  final List<String> _positionList =
      <String>['auto', 'bottom', 'left', 'right', 'top'].toList();
  String _selectedPosition = 'auto';
  LegendPosition _position = LegendPosition.auto;

  final List<String> _modeList = <String>['wrap', 'scroll', 'none'].toList();
  String _selectedMode = 'wrap';
  LegendItemOverflowMode _overflowMode = LegendItemOverflowMode.wrap;

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Position    ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                padding: const EdgeInsets.fromLTRB(75, 0, 0, 0),
                height: 50,
                width: 200,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedPosition,
                          item: _positionList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'auto',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            _onPositionTypeChange(value.toString());
                          })),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Overflow mode',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                height: 50,
                width: 200,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedMode,
                          item: _modeList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'wrap',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            _onModeTypeChange(value);
                          })),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Toggle visibility   ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomCheckBox(
                  activeColor: model.backgroundColor,
                  switchValue: toggleVisibility,
                  valueChanged: (dynamic value) {
                    setState(() {
                      toggleVisibility = value;
                    });
                  },
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
    return _getLegendOptionsChart();
  }

  ///Get the circular chart which has legend
  SfCircularChart _getLegendOptionsChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Expenses by category'),
      legend: Legend(
          isVisible: true,
          position: _position,
          overflowMode: _overflowMode,
          toggleSeriesVisibility: toggleVisibility),
      series: _getLegendOptionsSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  ///Get the pie series
  List<PieSeries<ChartSampleData, String>> _getLegendOptionsSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'Tution Fees', y: 21),
      ChartSampleData(x: 'Entertainment', y: 21),
      ChartSampleData(x: 'Private Gifts', y: 8),
      ChartSampleData(x: 'Local Revenue', y: 21),
      ChartSampleData(x: 'Federal Revenue', y: 16),
      ChartSampleData(x: 'Others', y: 8)
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: pieData,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: DataLabelSettings(isVisible: true)),
    ];
  }

  ///Changing the legend position
  void _onPositionTypeChange(String item) {
    setState(() {
      _selectedPosition = item;
      if (_selectedPosition == 'auto') {
        _position = LegendPosition.auto;
      }
      if (_selectedPosition == 'bottom') {
        _position = LegendPosition.bottom;
      }
      if (_selectedPosition == 'right') {
        _position = LegendPosition.right;
      }
      if (_selectedPosition == 'left') {
        _position = LegendPosition.left;
      }
      if (_selectedPosition == 'top') {
        _position = LegendPosition.top;
      }
    });
  }

  ///Change the legend overflow mode
  void _onModeTypeChange(String item) {
    setState(() {
      _selectedMode = item;
      if (_selectedMode == 'wrap') {
        _overflowMode = LegendItemOverflowMode.wrap;
      }
      if (_selectedMode == 'scroll') {
        _overflowMode = LegendItemOverflowMode.scroll;
      }
      if (_selectedMode == 'none') {
        _overflowMode = LegendItemOverflowMode.none;
      }
    });
  }
}
