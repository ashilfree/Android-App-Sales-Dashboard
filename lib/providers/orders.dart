import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';

class OrderItem {
  final String id;
  final String numCmdClient;
  final String date;
  final String qtyOrd;
  final String qtySat;
  final String rate;
  final String ttc;

  OrderItem({
    @required this.id,
    @required this.numCmdClient,
    @required this.date,
    @required this.qtyOrd,
    @required this.qtySat,
    @required this.rate,
    @required this.ttc,
  });

  String getIndex(int index) {
    switch (index) {
      case 0:
        return id;
      case 1:
        return numCmdClient;
      case 2:
        return qtyOrd;
      case 3:
        return rate;
      case 4:
        return ttc;
    }
    return '';
  }
}



class Orders with ChangeNotifier {
  static const tableHeaders = [
    'N°',
    'N° Cmd Client',
    'Quantite Cmd',
    'Pourcentage',
    'Total'
  ];
  List<OrderItem> _orders = [];
  List<OrderItem> _orderStatus = [];
  final String userId;
  final String selectedCustomerId;
  final String authToken;
  final DateTime createdAt;
  DateTime _firstPickedDate;
  DateTime _lastPickedDate;

  Orders(this.userId, this.selectedCustomerId, this.authToken, this.createdAt){
    _firstPickedDate = this.createdAt;
    _lastPickedDate = DateTime.now();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }
  List<OrderItem> get orderStatus {
    return [..._orderStatus];
  }

  DateTime get firstPickedDate => _firstPickedDate;
  DateTime get lastPickedDate => _lastPickedDate;

  void resetDate(){
    _firstPickedDate = this.createdAt;
    _lastPickedDate = DateTime.now();
  }

  Future<void> fetchAndSetOrders(Map<String, String> filterData) async {
    const url = "${Constants.appLink}user/orderlist";
    try {
      print('response.body');
      final response = await http.post(
        url,
        body: {"agentno": selectedCustomerId},
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      final responseData = json.decode(response.body) as List<dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (responseData != null) {
        if(!responseData[0].containsKey("error")){
        responseData.forEach((value) {
          loadedOrders.add(OrderItem(
            id: value['num'].toString(),
            numCmdClient: value['tr'],
            date: value['dat'].toString(),
            qtyOrd: value['qtyord'].toString(),
            qtySat: value['qtysat'].toString(),
            rate: value['rate'].toString(),
            ttc: value['TTC'].toString(),
          ));
        });}
      }
      _orders = loadedOrders;
       if(filterData['invoiceId'] != ''){
        _orders = _orders.where((element) => element.id == filterData['invoiceId']).toList();
        print(_orders);
      }
      if(filterData['invoiceDate'] != ''){
        _orders = _orders.where((element) => element.date == filterData['invoiceDate']).toList();
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetOrderStatus(Map<String, DateTime> pickedDates) async {
    const url = "${Constants.appLink}user/orderstatus";
    if(pickedDates["first_date"] != null)
      _firstPickedDate = pickedDates["first_date"];
    if(pickedDates["last_date"] != null)
      _lastPickedDate = pickedDates["last_date"];
    try {
      print('response.body');
      final response = await http.post(
        url,
        body: {"accountno": userId,
          "first_date": pickedDates["first_date"] != null ? DateFormat('yyyy-MM-dd').format(pickedDates["first_date"]) : DateFormat('yyyy-MM-dd').format(_firstPickedDate),
          "last_date": pickedDates["last_date"] != null ? DateFormat('yyyy-MM-dd').format(pickedDates["last_date"]) : DateFormat('yyyy-MM-dd').format(_lastPickedDate),
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      final responseData = json.decode(response.body) as List<dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (responseData != null) {
        responseData.forEach((value) {
          if(value['message'] != 'noData')
          loadedOrders.add(OrderItem(
            id: value['num'].toString(),
            numCmdClient: value['tr'].toString(),
            date: value['dat'].toString(),
            qtyOrd: value['qtyord'].toString(),
            qtySat: value['qtysat'].toString(),
            rate: value['rate'].toString(),
            ttc: value['TTC'].toString(),
          ));
        });
      }
      _orderStatus = loadedOrders;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
