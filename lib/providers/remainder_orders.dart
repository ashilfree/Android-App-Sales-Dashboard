import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class RemainderOrderItem {
  final String ref;
  final double qty;
  final String rate;
  final String text;

  RemainderOrderItem({
    @required this.ref,
    @required this.qty,
    @required this.rate,
    @required this.text,
  });
}

class RemainderOrder with ChangeNotifier {
  List<RemainderOrderItem> _remainderOrders = [];
  final String authToken;
  double _total = 0.0;

  RemainderOrder(this.authToken);

  List<RemainderOrderItem> get remainderOrders {
    return [..._remainderOrders];
  }

  List<RemainderOrderItem> get reverseRemainderOrders {
    return [..._remainderOrders].reversed.toList();
  }

  double get total => _total;

  Future<void> fetchAndSetremainderOrder() async {
    const url = "${Constants.appLink}superadmin/remainderorders";
    try {
      final response = await http.get(
        url,
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });

      final responseData = json.decode(response.body) as List<dynamic>;
      final List<RemainderOrderItem> loadedremainderOrder = [];
      double total = 0.0;
      print(responseData);
      if (responseData != null) {
        if (!responseData[0].containsKey("error"))
          total = responseData
              .map<double>(
                  (p) => ((p['qty'] is int) ? p['qty'].toDouble() : p['qty']))
              .reduce((a, b) => a + b);
        responseData.forEach((value) {
          loadedremainderOrder.add(RemainderOrderItem(
              ref: value['Description2'].toString(),
              qty: (value['qty'] is int)
                  ? value['qty'].toDouble()
                  : value['qty'],
              rate: ((value['qty'] * 100 / total)).toStringAsFixed(1) + '%',
              text: ((value['qty'] * 100 / total) + 50).toStringAsFixed(1) +
                  '%'));
        });
      }
      _remainderOrders = loadedremainderOrder;
      _total = total;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
