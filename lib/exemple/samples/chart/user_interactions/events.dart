/// Package import
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';

///Renders default column chart sample
class Events extends SampleView {
  ///Renders default column chart sample
  const Events(Key key) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

// final GlobalKey consoleKey = GlobalKey<ConsoleState>();
final _scrollController = ScrollController();

class _EventsState extends SampleViewState {
  _EventsState();
  List<String> actionsList = [];
  final GlobalKey consoleKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.height >
            MediaQuery.of(context).size.width
        ? Column(children: <Widget>[
            Expanded(
              flex: 6,
              child: _getDefaultEventChart(),
            ),
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4))),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Align(
                                              child: Text(
                                                'Event Trace',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              alignment:
                                                  Alignment.centerLeft))),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            splashRadius: 25,
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              actionsList.clear();
                                              (consoleKey.currentWidget
                                                      as Console)
                                                  .actionsList;
                                              consoleKey.currentState
                                                  .setState(() {});
                                            },
                                          ))),
                                ],
                              ))),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Console(actionsList, consoleKey),
                      ))
                    ],
                  ),
                )),
          ])
        : Row(children: <Widget>[
            Expanded(
              flex: 6,
              child: _getDefaultEventChart(),
            ),
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4))),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Align(
                                              child: Text(
                                                'Event Trace',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              alignment:
                                                  Alignment.centerLeft))),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            splashRadius: 25,
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              actionsList.clear();
                                              (consoleKey.currentWidget
                                                      as Console)
                                                  .actionsList;
                                              // _scrollController.jumpTo(0.0);
                                              // setState(() {});
                                              consoleKey.currentState
                                                  .setState(() {});
                                            },
                                          ))),
                                ],
                              ))),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Console(actionsList, consoleKey),
                      ))
                    ],
                  ),
                )),
          ]);
  }

  /// Get default column chart
  SfCartesianChart _getDefaultEventChart() {
    return SfCartesianChart(
      onAxisLabelRender: (AxisLabelRenderArgs args) {
        actionsList.insert(0, 'Axis label (${args.text}) was rendered');
      },
      onAxisLabelTapped: (AxisLabelTapArgs args) {
        actionsList.insert(0, 'Axis label (${args.text}) was tapped');
        (consoleKey.currentState as _ConsoleState).setState(() {});
      },
      onDataLabelTapped: (DataLabelTapDetails args) {
        actionsList.insert(0, 'Data label (${args.text}) was tapped');
        (consoleKey.currentState as _ConsoleState).setState(() {});
      },
      onPointTapped: (PointTapArgs args) {
        actionsList.insert(
            0, 'Point (${args.pointIndex.toString()}) was tapped');
        (consoleKey.currentState as _ConsoleState).setState(() {});
      },
      onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
        actionsList.insert(0, 'Chart was tapped down');
        (consoleKey.currentState as _ConsoleState).setState(() {});
      },
      onChartTouchInteractionMove: (ChartTouchInteractionArgs args) {
        actionsList.insert(0, 'Moved on chart area');
        (consoleKey.currentState as _ConsoleState).setState(() {});
      },
      onLegendTapped: (LegendTapArgs args) {
        actionsList.insert(0, 'Legend was tapped');
        (consoleKey.currentState as _ConsoleState).setState(() {});
      },
      onMarkerRender: (MarkerRenderArgs args) {
        actionsList.insert(
            0, 'Marker (${args.pointIndex.toString()}) was rendered');
        if (args.pointIndex == 5) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            (consoleKey.currentState as _ConsoleState).setState(() {});
          });
        }
      },
      onTooltipRender: (TooltipArgs args) {
        actionsList.insert(0, 'Tooltip (${args.text}) is showing');
        (consoleKey.currentState as _ConsoleState).setState(() {});
      },
      onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
        actionsList.insert(0, 'Chart was tapped up');
        (consoleKey.currentState as _ConsoleState).setState(() {});
      },
      onLegendItemRender: (LegendRenderArgs args) {
        actionsList.insert(0, 'Legend (${args.text}) was rendered');
      },
      onDataLabelRender: (DataLabelRenderArgs args) {
        actionsList.insert(
            0, 'Data label (${args.text.toString()}) was rendered');
      },
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Population growth of various countries'),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}%',
          majorTickLines: MajorTickLines(size: 0)),
      series: _getDefaultColumnSeries(),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      tooltipBehavior: TooltipBehavior(
        animationDuration: 0,
        canShowMarker: false,
        enable: true,
      ),
    );
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'China', y: 0.541),
      ChartSampleData(x: 'Brazil', y: 0.818),
      ChartSampleData(x: 'Bolivia', y: 1.51),
      ChartSampleData(x: 'Mexico', y: 1.302),
      ChartSampleData(x: 'Egypt', y: 2.017),
      ChartSampleData(x: 'Mongolia', y: 1.683),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        animationDuration: 0,
        name: 'Population',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: MarkerSettings(isVisible: true),
        dataLabelSettings: DataLabelSettings(isVisible: true),
      )
    ];
  }
}

class CustomColumnSeriesRenderer extends ColumnSeriesRenderer {}

class Console extends StatefulWidget {
  Console(this.actionsList, Key consoleKey) : super(key: consoleKey);
  final List<String> actionsList;
  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  void scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    setState(() {});
  }

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(5),
          child: ListView.separated(
            controller: _scrollController,
            separatorBuilder: (context, build) => Divider(
              color: Colors.grey,
              height: 4,
            ),
            itemCount: widget.actionsList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: Text(widget.actionsList[index]),
              );
            },
          )),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.4))),
    );
  }
}
