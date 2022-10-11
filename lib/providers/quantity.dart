import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';

class QuantityItem {
  final DateTime x;
  double y;
  double yValue;

  QuantityItem({
    @required this.x,
    this.y,
    this.yValue,
  });
}

class Quantity with ChangeNotifier {
  List<QuantityItem> _quantities = [];
  double _totalFML = 0.0;
  double _totalRAB = 0.0;
  final String authToken;
  DateTime _firstPickedDate;
  DateTime _lastPickedDate;

  Quantity(this.authToken) {
    _firstPickedDate = DateTime.now().subtract(Duration(days: 7));
    _lastPickedDate = DateTime.now();
  }

  List<QuantityItem> get quantities {
    return [..._quantities];
  }

  double get totalFML => _totalFML;

  double get totalRAB => _totalRAB;

  DateTime get firstPickedDate => _firstPickedDate;

  DateTime get lastPickedDate => _lastPickedDate;

  void resetDate() {
    _firstPickedDate = DateTime.now().subtract(Duration(days: 7));
    _lastPickedDate = DateTime.now();
  }

  Future<void> fetchAndSetQuantity(Map<String, DateTime> pickedDates) async {
    const url = "${Constants.appLink}superadmin/quantity";
    if (pickedDates["first_date"] != null)
      _firstPickedDate = pickedDates["first_date"];
    if (pickedDates["last_date"] != null)
      _lastPickedDate = pickedDates["last_date"];
    try {
      final response = await http.post(
        url,
        body: {
          "first_date": pickedDates["first_date"] != null
              ? DateFormat('yyyy-MM-dd').format(pickedDates["first_date"])
              : DateFormat('yyyy-MM-dd').format(_firstPickedDate),
          "last_date": pickedDates["last_date"] != null
              ? DateFormat('yyyy-MM-dd').format(pickedDates["last_date"])
              : DateFormat('yyyy-MM-dd').format(_lastPickedDate),
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });

      final responseData = json.decode(response.body) as List<dynamic>;
      final List<QuantityItem> loadedQuantity = [];
      if (responseData != null) {
        if(!responseData[0].containsKey("error"))
        responseData.forEach((value) {
            var i = loadedQuantity.indexWhere((e) => (e.x == DateTime(value['AA'], value['MM'], value['days'])));
            if (i == -1) {
              loadedQuantity.add(QuantityItem(
                x: DateTime(value['AA'], value['MM'], value['days']),
                y: value['Category'] == 'RAB'
                    ? (value['Quantity'] is int)?  value['Quantity'].toDouble():value['Quantity']
                    : 0.0,
                yValue: value['Category'] == 'FML'
                    ? (value['Quantity'] is int)?  value['Quantity'].toDouble():value['Quantity']
                    : 0.0,
              ));
            } else {
              if (value['Category'] == 'RAB') {
                loadedQuantity[i].y = (value['Quantity'] is int)?  value['Quantity'].toDouble():value['Quantity'];
              } else {
                loadedQuantity[i].yValue = (value['Quantity'] is int)?  value['Quantity'].toDouble():value['Quantity'];
              }
            }
        });
      }
      _quantities = loadedQuantity;
      _totalRAB = loadedQuantity.map<double>((p) => (p.y)).reduce((a, b) => a + b);
      _totalFML = loadedQuantity.map<double>((p) => (p.yValue)).reduce((a, b) => a + b);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
