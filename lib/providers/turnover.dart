import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';

class TurnoverItem {
  final DateTime date;
  final double turnover;

  TurnoverItem({
    @required this.date,
    @required this.turnover,
  });
}

class Turnover with ChangeNotifier {

  List<TurnoverItem> _turnovers = [];
  final String authToken;
  DateTime _firstPickedDate;
  DateTime _lastPickedDate;
  double _total =0;
  int x = 10;

  Turnover(this.authToken){
    _firstPickedDate = DateTime.now().subtract(Duration(days: 7));
    _lastPickedDate = DateTime.now();
  }

  List<TurnoverItem> get turnovers {
    return [..._turnovers];
  }

  DateTime get firstPickedDate => _firstPickedDate;
  DateTime get lastPickedDate => _lastPickedDate;

  double get total => _total;

  void resetDate(){
    _firstPickedDate = DateTime.now().subtract(Duration(days: 7));
    _lastPickedDate = DateTime.now();
  }

  Future<void> fetchAndSetTurnover(Map<String, DateTime> pickedDates) async {
    const url = "${Constants.appLink}superadmin/turnover";
    if(pickedDates["first_date"] != null)
      _firstPickedDate = pickedDates["first_date"];
    if(pickedDates["last_date"] != null)
      _lastPickedDate = pickedDates["last_date"];
    try {
      final response = await http.post(
        url,
        body: {
          "first_date": pickedDates["first_date"] != null ? DateFormat('yyyy-MM-dd').format(pickedDates["first_date"]) : DateFormat('yyyy-MM-dd').format(_firstPickedDate),
          "last_date": pickedDates["last_date"] != null ? DateFormat('yyyy-MM-dd').format(pickedDates["last_date"]) : DateFormat('yyyy-MM-dd').format(_lastPickedDate),
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      final responseData = json.decode(response.body) as List<dynamic>;
      print(responseData);
      final List<TurnoverItem> loadedTurnover = [];
      if (responseData != null) {
        if(!responseData[0].containsKey("error"))
        responseData.forEach((value) {
          loadedTurnover.add(TurnoverItem(
              date: DateTime.parse(value['d']),
              turnover: double.parse((value['CA']/10000000).toStringAsFixed(3)),
          ));
        });
      }
      _turnovers = loadedTurnover;
      _total = loadedTurnover.map<double>((p) => (p.turnover)).reduce((a, b) => a + b);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
