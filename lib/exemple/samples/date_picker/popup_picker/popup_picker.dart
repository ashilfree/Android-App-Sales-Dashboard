///Package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
///Date picker imports
import 'package:syncfusion_flutter_datepicker/datepicker.dart' as _picker;

///Local import
import '../../../model/model.dart';
import '../../../model/sample_view.dart';

/// Renders datepicker with popup menu
class PopUpDatePicker extends SampleView {
  /// Creates datepicker with popup menu
  const PopUpDatePicker(Key key) : super(key: key);

  @override
  _PopUpDatePickerState createState() => _PopUpDatePickerState();
}

class _PopUpDatePickerState extends SampleViewState
    with SingleTickerProviderStateMixin {
  _PopUpDatePickerState();

  DateTime _startDate;
  DateTime _endDate;
  int _value;

  @override
  void initState() {
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 1));
    _value = 1;
    super.initState();
  }

  /// Update the selected date for the date range picker based on the date selected,
  /// when the trip mode set one way.
  void _onSelectedDateChanged(DateTime date) {
    if (date != null && date != _startDate) {
      setState(() {
        final Duration difference = _endDate.difference(_startDate);
        _startDate = DateTime(date.year, date.month, date.day);
        _endDate = _startDate.add(difference);
      });
    }
  }

  /// Update the selected range based on the range selected in the pop up editor,
  /// when the trip mode set as round trip.
  void _onSelectedRangeChanged(_picker.PickerDateRange dateRange) {
    final DateTime startDateValue = dateRange.startDate;
    DateTime endDateValue = dateRange.endDate;
    endDateValue ??= startDateValue;
    setState(() {
      if (startDateValue.isAfter(endDateValue)) {
        _startDate = endDateValue;
        _endDate = startDateValue;
      } else {
        _startDate = startDateValue;
        _endDate = endDateValue;
      }
    });
  }

  Widget _getBooking() {
    return Card(
        elevation: 10,
        margin: model.isWeb
            ? const EdgeInsets.fromLTRB(30, 20, 30, 5)
            : const EdgeInsets.all(30),
        child: Container(
            color: model.isWeb ? model.cardThemeColor : model.cardThemeColor,
            child: ListView(
                padding: model.isWeb
                    ? const EdgeInsets.fromLTRB(30, 10, 10, 5)
                    : const EdgeInsets.fromLTRB(30, 20, 10, 10),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text(
                      'Book a Flight',
                      style: TextStyle(
                          color: model.textColor,
                          backgroundColor: Colors.transparent,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: FlatButton(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 10, 5),
                                  onPressed: () {
                                    setState(() {
                                      _value = 0;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        _value == 0
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                        color: model.backgroundColor,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      new Text(
                                        'One-way',
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: _value == 0
                                                ? FontWeight.w600
                                                : FontWeight.w400),
                                      ),
                                    ],
                                  )),
                            ),
                            Expanded(
                                flex: 5,
                                child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _value = 1;
                                    });
                                  },
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        _value == 1
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                        color: model.backgroundColor,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      new Text(
                                        'Round-Trip',
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: _value == 1
                                                ? FontWeight.w600
                                                : FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                )),
                          ])),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                      'From',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Text('Cleveland (CLE)',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ))),
                        Expanded(
                            flex: 5,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                      'Destination',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Text('Chicago (CHI)',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                )))
                      ])),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Divider(
                        color: Colors.black26,
                        height: 1.0,
                        thickness: 1,
                      )),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: FlatButton(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                onPressed: () async {
                                  if (_value == 0) {
                                    final DateTime date =
                                        await showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DateRangePicker(
                                                  _startDate, null,
                                                  displayDate: _startDate,
                                                  minDate: DateTime.now(),
                                                  model: model);
                                            });
                                    if (date != null) {
                                      _onSelectedDateChanged(date);
                                    }
                                  } else {
                                    final _picker.PickerDateRange range =
                                        await showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DateRangePicker(
                                                null,
                                                _picker.PickerDateRange(
                                                  _startDate,
                                                  _endDate,
                                                ),
                                                displayDate: _startDate,
                                                minDate: DateTime.now(),
                                                model: model,
                                              );
                                            });

                                    if (range != null) {
                                      _onSelectedRangeChanged(range);
                                    }
                                  }
                                },
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Departure Date',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10)),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 5, 0),
                                          child: Text(
                                              DateFormat('dd MMM yyyy')
                                                  .format(_startDate),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    )))),
                        Expanded(
                            flex: 5,
                            child: FlatButton(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                onPressed: _value == 0
                                    ? null
                                    : () async {
                                        final _picker.PickerDateRange range =
                                            await showDialog<dynamic>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DateRangePicker(
                                                    null,
                                                    _picker.PickerDateRange(
                                                        _startDate, _endDate),
                                                    displayDate: _endDate,
                                                    minDate: DateTime.now(),
                                                    model: model,
                                                  );
                                                });

                                        if (range != null) {
                                          _onSelectedRangeChanged(range);
                                        }
                                      },
                                child: Container(
                                    padding: EdgeInsets.all(0),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _value == 0
                                          ? <Widget>[
                                              Text('Return Date',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ]
                                          : <Widget>[
                                              Text('Return Date',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10)),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 5, 5, 0),
                                                child: Text(
                                                    DateFormat('dd MMM yyyy')
                                                        .format(_endDate),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ],
                                    ))))
                      ])),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Divider(
                        color: Colors.black26,
                        height: 1.0,
                        thickness: 1,
                      )),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                      'Travellers',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Text('1 Adult',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ))),
                        Expanded(
                            flex: 5,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                      'Class',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Text('Economy',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                )))
                      ])),
                  Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FlatButton(
                            color: model.backgroundColor,
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                  'Searching...',
                                ),
                                duration: Duration(milliseconds: 200),
                              ));
                            },
                            child: const Text(
                              'SEARCH',
                              style: TextStyle(
                                  color: Colors.white,
                                  backgroundColor: Colors.transparent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      )),
                ])));
  }

  @override
  Widget build([BuildContext context]) {
    return Scaffold(
        backgroundColor: model.themeData == null ||
                model.themeData.brightness == Brightness.light
            ? null
            : const Color(0x171A21),
        body: model.isWeb
            ? Center(
                child: Container(width: 400, height: 380, child: _getBooking()))
            : Container(height: 450, child: _getBooking()));
  }
}

/// Get date range picker
_picker.SfDateRangePicker getPopUpDatePicker() {
  return _picker.SfDateRangePicker();
}

/// Builds the date range picker inside a pop-up based on the properties passed,
/// and return the selected date or range based on the tripe mode selected.
class DateRangePicker extends StatefulWidget {
  /// Creates Date range picker
  const DateRangePicker(this.date, this.range,
      {this.minDate, this.maxDate, this.displayDate, this.model});

  /// Holds date value
  final DateTime date;

  /// Holds date range value
  final _picker.PickerDateRange range;

  /// Holds minimum date value
  final DateTime minDate;

  /// Holds maximu date value
  final DateTime maxDate;

  /// Holds showable date value
  final DateTime displayDate;

  /// Holds Samplemodel instance
  final SampleModel model;

  @override
  State<StatefulWidget> createState() {
    return _DateRangePickerState();
  }
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime date;
  _picker.DateRangePickerController _controller;
  _picker.PickerDateRange range;
  bool _isWeb;

  @override
  void initState() {
    date = widget.date;
    range = widget.range;
    _controller = _picker.DateRangePickerController();
    _isWeb = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //// Extra small devices (phones, 600px and down)
//// @media only screen and (max-width: 600px) {...}
////
//// Small devices (portrait tablets and large phones, 600px and up)
//// @media only screen and (min-width: 600px) {...}
////
//// Medium devices (landscape tablets, 768px and up)
//// media only screen and (min-width: 768px) {...}
////
//// Large devices (laptops/desktops, 992px and up)
//// media only screen and (min-width: 992px) {...}
////
//// Extra large devices (large laptops and desktops, 1200px and up)
//// media only screen and (min-width: 1200px) {...}
//// Default width to render the mobile UI in web, if the device width exceeds
//// the given width agenda view will render the web UI.
    _isWeb = MediaQuery.of(context).size.width > 767;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Widget footerWidget = ButtonBarTheme(
      data: ButtonBarTheme.of(context),
      child: ButtonBar(
        children: <Widget>[
          FlatButton(
            splashColor: widget.model.backgroundColor
                .withOpacity(widget.model.backgroundColor.opacity * 0.2),
            child: Text(
              'Cancel',
              style: TextStyle(color: widget.model.backgroundColor),
            ),
            onPressed: () => Navigator.pop(context, null),
          ),
          FlatButton(
            splashColor: widget.model.backgroundColor
                .withOpacity(widget.model.backgroundColor.opacity * 0.2),
            child: Text(
              'OK',
              style: TextStyle(color: widget.model.backgroundColor),
            ),
            onPressed: () {
              (range != null)
                  ? Navigator.pop(context, range)
                  : Navigator.pop(context, date);
            },
          ),
        ],
      ),
    );

    final Widget selectedDateWidget = Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: range == null ||
                    range.startDate == null ||
                    range.endDate == null ||
                    range.startDate == range.endDate
                ? Text(
                    DateFormat('dd MMM, yyyy').format(range == null
                        ? date
                        : (range.startDate ?? range.endDate)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: widget.model.textColor),
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Text(
                          DateFormat('dd MMM, yyyy').format(
                              range.startDate.isAfter(range.endDate)
                                  ? range.endDate
                                  : range.startDate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: widget.model.textColor),
                        ),
                      ),
                      Container(
                          child: const VerticalDivider(
                        thickness: 1,
                      )),
                      Expanded(
                        flex: 5,
                        child: Text(
                          DateFormat('dd MMM, yyyy').format(
                              range.startDate.isAfter(range.endDate)
                                  ? range.startDate
                                  : range.endDate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: widget.model.textColor),
                        ),
                      ),
                    ],
                  )));

    _controller.selectedDate = date;
    _controller.selectedRange = range;
    final Widget pickerWidget = _picker.SfDateRangePicker(
      controller: _controller,
      initialDisplayDate: widget.displayDate,
      showNavigationArrow: true,
      enableMultiView: range != null && _isWeb,
      selectionMode: range == null
          ? _picker.DateRangePickerSelectionMode.single
          : _picker.DateRangePickerSelectionMode.range,
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      todayHighlightColor: Colors.transparent,
      headerStyle: _picker.DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle:
              TextStyle(color: widget.model.backgroundColor, fontSize: 15)),
      onSelectionChanged:
          (_picker.DateRangePickerSelectionChangedArgs details) {
        setState(() {
          if (range == null) {
            date = details.value;
          } else {
            range = details.value;
          }
        });
      },
    );

    return Dialog(
        backgroundColor: widget.model.cardThemeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Container(
            height: 400,
            width: range != null && _isWeb ? 500 : 300,
            color: widget.model.cardThemeColor,
            child: Theme(
              data: widget.model.themeData.copyWith(
                accentColor: widget.model.backgroundColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  selectedDateWidget,
                  Flexible(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: pickerWidget)),
                  footerWidget,
                ],
              ),
            )));
  }
}
