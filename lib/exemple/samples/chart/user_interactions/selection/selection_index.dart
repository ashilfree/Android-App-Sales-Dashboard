/// Package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_dropdown.dart';

/// Renders the chart with default selection option sample.
class SelectionIndex extends SampleView {
  /// Creates the chart with default selection option
  const SelectionIndex(Key key) : super(key: key);

  @override
  _DefaultSelectionState createState() => _DefaultSelectionState();
}

/// State class of the chart with default selection.
class _DefaultSelectionState extends SampleViewState {
  _DefaultSelectionState();

  final List<String> _seriesIndexList = <String>['0', '1', '2'].toList();
  final List<String> _pointIndexList =
      <String>['0', '1', '2', '3', '4'].toList();
  int _seriesIndex;
  int _pointIndex;
  SelectionBehavior _selectionBehavior;

  @override
  void initState() {
    _seriesIndex = 0;
    _pointIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectionBehavior =
        SelectionBehavior(enable: true, unselectedOpacity: 0.5);

    return _getDefaultSelectionChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Series index',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                padding: const EdgeInsets.fromLTRB(78, 0, 0, 0),
                child: Align(
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _seriesIndex.toString(),
                          item: _seriesIndexList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : '0',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            _onSeriesIndexChange(value);
                          })),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Point index ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                child: Align(
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _pointIndex.toString(),
                          item: _pointIndexList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : '0',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            _onPointIndexChange(value);
                          })),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                    child: RaisedButton(
                      color: model.backgroundColor,
                      onPressed: () {
                        selection(_seriesIndex, _pointIndex);
                      },
                      child:
                          Text('Select', style: TextStyle(color: Colors.white)),
                    )))
          ],
        ),
      ],
    );
  }

  /// Returns the cartesian chart with default selection.
  SfCartesianChart _getDefaultSelectionChart() {
    return SfCartesianChart(
      onSelectionChanged: (SelectionArgs args) {
        setState(() {
          _seriesIndex = args.seriesIndex;
          _pointIndex = args.pointIndex;
        });
      },
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Tourism - Number of arrivals'),

      /// To specify the selection mode for chart.
      selectionType: SelectionType.point,
      selectionGesture: ActivationMode.singleTap,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          numberFormat: NumberFormat.compact()),
      series: _getDefaultSelectionSeries(),
    );
  }

  /// Returns the list of chart series
  /// which need to render on the cartesian chart.
  List<ColumnSeries<ChartSampleData, String>> _getDefaultSelectionSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Mexico',
          y: 32093000,
          secondSeriesYValue: 35079000,
          thirdSeriesYValue: 39291000),
      ChartSampleData(
          x: 'Italy',
          y: 50732000,
          secondSeriesYValue: 52372000,
          thirdSeriesYValue: 58253000),
      ChartSampleData(
          x: 'US',
          y: 77774000,
          secondSeriesYValue: 76407000,
          thirdSeriesYValue: 76941000),
      ChartSampleData(
          x: 'Spain',
          y: 68175000,
          secondSeriesYValue: 75315000,
          thirdSeriesYValue: 81786000),
      ChartSampleData(
          x: 'France',
          y: 84452000,
          secondSeriesYValue: 82682000,
          thirdSeriesYValue: 86861000),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          selectionBehavior: _selectionBehavior,
          name: '2015'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          selectionBehavior: _selectionBehavior,
          name: '2016'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          selectionBehavior: _selectionBehavior,
          name: '2017')
    ];
  }

  void _onSeriesIndexChange(String seriesIndex) {
    _seriesIndex = int.parse(seriesIndex);
    setState(() {
      /// update the selection type changes
    });
  }

  void _onPointIndexChange(String pointIndex) {
    _pointIndex = int.parse(pointIndex);
    setState(() {
      /// update the selection type changes
    });
  }

  void selection(int seriesIndex, int pointIndex) {
    _selectionBehavior.selectDataPoints(pointIndex, seriesIndex);
  }
}
