import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helper/convert_helper.dart';
import '../../helper/function_helper.dart';
import '../../helper/style.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/turnover.dart';
import '../../widgets/Super_Admin_Sprint/turnover_chart.dart';
import '../../widgets/errorDialog.dart';

class TurnoverScreen extends StatefulWidget {
  @override
  _TurnoverScreenState createState() => _TurnoverScreenState();
}

class _TurnoverScreenState extends State<TurnoverScreen> {
  DateTime _createdDate;
  var _firstDateSelected;
  @override
  void initState() {
    // _createdDate = Provider.of<Auth>(context, listen: false).createdAt;
    _createdDate = DateTime.now().subtract(Duration(days: 7)); // update this
    _firstDateSelected = _createdDate;
    super.initState();
  }

  var _lastDateSelected = DateTime.now();

  void _firstDatePicker() {
    showDatePicker(
            context: context,
            initialDate: _firstDateSelected,
            firstDate: DateTime(2019, 1, 1),
            lastDate: _lastDateSelected.subtract(Duration(days: 4)))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _firstDateSelected = value;
      });
      _refreshProducts(
          context: context,
          pickedDates: {"first_date": value, "last_date": null});
    });
  }

  void _lastDatePicker() {
    showDatePicker(
            context: context,
            initialDate: _lastDateSelected,
            firstDate: _firstDateSelected.add(Duration(days: 4)),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _lastDateSelected = value;
      });
      _refreshProducts(
          context: context,
          pickedDates: {"first_date": null, "last_date": value});
    });
  }

  Future<void> _refreshProducts(
      {BuildContext context,
      Map<String, DateTime> pickedDates = const {
        "first_date": null,
        "last_date": null
      }}) async {
    try {
      await Provider.of<Turnover>(context, listen: false)
          .fetchAndSetTurnover(pickedDates);
    } on SocketException catch (e) {
      final err = ErrorHandler.err(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(err['errorMessage'], err['buttonTxt']);
          });
    } catch (error) {
      if (error.toString().contains('time_out_err')) {
        ErrorToast.showToast();
      } else {
        final err = ErrorHandler.err(error.toString());
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(err['errorMessage'], err['buttonTxt']);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.38),
          child: AppBar(
            elevation: 0,
            backgroundColor: aqsGreenColor,
            flexibleSpace: Center(
              child: FittedBox(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "CHIFFRE D'AFFAIRE",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Quicksand"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FittedBox(
                        child: Container(
                          child: Center(
                            child: FittedBox(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "De :",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    FlatButton(
                                      child: Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(_firstDateSelected),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onPressed: _firstDatePicker,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                      ),
                                      iconSize: 20.0,
                                      onPressed: _firstDatePicker,
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      "À :",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    FlatButton(
                                      child: Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(_lastDateSelected),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onPressed: _lastDatePicker,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                      ),
                                      iconSize: 20.0,
                                      onPressed: _lastDatePicker,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FittedBox(
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Consumer<Turnover>(
                                builder: (ctx, turnover, _) => Text(
                                  "${numberFormat(turnover.total)} Md",
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    fontFamily: "Quicksand",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.timeline),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Graphique"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.history),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Historique"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: _refreshProducts(context: context),
          builder: (ctx, snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  children: [
                    TurnoverChart(),
                    Consumer<Turnover>(
                      builder: (ctx, turnover, _) =>
                          turnover.turnovers.length == 0
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Aucune Résultat",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.refresh),
                                        onPressed: () {
                                          setState(() {});
                                        },
                                      )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left: 10.0,
                                  ),
                                  child: ListView.builder(
                                    itemCount: turnover.turnovers.length,
                                    itemBuilder: (ctx, index) => ListTile(
                                      title: Text(
                                        "${currencyFormatMd(turnover.turnovers[index].turnover.toString(), abv: 'Md')}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Container(
                                        margin: EdgeInsets.only(
                                          top: 8,
                                        ),
                                        child: Text(
                                          "Le : ${ConvertHelper.convertDateFromString(turnover.turnovers[index].date.toString())}",
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
