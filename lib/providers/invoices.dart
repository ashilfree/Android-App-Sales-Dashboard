import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';
import '../helper/function_helper.dart';

class InvoiceItem {
  final String id;
  final String dateTime;
  final String amount;

  InvoiceItem({
    @required this.id,
    @required this.dateTime,
    @required this.amount,
  });

}

class BillingStatusItem {
  final String id;
  final String date;
  final String product;
  final String quantity;
  final String price;
  final String amount;
  final String vat;

  BillingStatusItem({
    @required this.id,
    @required this.date,
    @required this.product,
    @required this.quantity,
    @required this.price,
    @required this.amount,
    @required this.vat,
  });

  String getIndex(int index) {
    switch (index) {
      case 0:
        return id;
      case 1:
        return product;
      case 2:
        return currencyFormat(price);
      case 3:
        return quantity;
      case 4:
        return currencyFormat(amount);
    }
    return '';
  }
}

class Invoices with ChangeNotifier {
  static const tableHeaders = [
    'N°',
    'Product',
    'Price',
    'Quantity',
    'Total'
  ];

  List<InvoiceItem> _invoices = [];
  List<BillingStatusItem> _billingStatus = [];
  final String userId;
  final String selectedCustomerId;
  final String authToken;
  final DateTime createdAt;
  DateTime _firstPickedDate;
  DateTime _lastPickedDate;


  Invoices(this.userId, this.selectedCustomerId, this.authToken, this.createdAt){
    _firstPickedDate = this.createdAt;
    _lastPickedDate = DateTime.now();
  }

  List<InvoiceItem> get invoices {
    return [..._invoices];
  }

  List<BillingStatusItem> get billingStatus {
    return [..._billingStatus];
  }

  DateTime get firstPickedDate => _firstPickedDate;
  DateTime get lastPickedDate => _lastPickedDate;
  
  void resetDate(){
    _firstPickedDate = this.createdAt;
    _lastPickedDate = DateTime.now();
  }

  Future<void> fetchAndSetInvoices(Map<String, String> filterData) async {
    const url = "${Constants.appLink}user/invoicelist";
    try {
      final response = await http.post(
        url,
        body: {"accountno": selectedCustomerId},
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      final responseData = json.decode(response.body) as List<dynamic>;
      final List<InvoiceItem> loadedInvoices = [];
      if (responseData != null) {
        if(!responseData[0].containsKey("error")){
        responseData.forEach((value) {
          loadedInvoices.add(InvoiceItem(
              id: value['SourceDocNo'].toString(),
              dateTime: value['date'],
              amount: value['db'].toString()));
        });}
      }
      _invoices = loadedInvoices;
      if (filterData['invoiceId'] != '') {
        _invoices = _invoices
            .where((element) => element.id == filterData['invoiceId'])
            .toList();
        print(_invoices);
      }
      if (filterData['invoiceDate'] != '') {
        _invoices = _invoices
            .where((element) => element.dateTime == filterData['invoiceDate'])
            .toList();
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetBillingStatus(Map<String, DateTime> pickedDates) async {
    const url = "${Constants.appLink}user/billingstatus";
    if(pickedDates["first_date"] != null)
     _firstPickedDate = pickedDates["first_date"];
    if(pickedDates["last_date"] != null)
     _lastPickedDate = pickedDates["last_date"];
    try {
      final response = await http.post(
        url,
        body: {
          "accountno": userId,
          "first_date": pickedDates["first_date"] != null ? DateFormat('yyyy-MM-dd').format(pickedDates["first_date"]) : DateFormat('yyyy-MM-dd').format(_firstPickedDate),
          "last_date": pickedDates["last_date"] != null ? DateFormat('yyyy-MM-dd').format(pickedDates["last_date"]) : DateFormat('yyyy-MM-dd').format(_lastPickedDate),
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      final responseData = json.decode(response.body) as List<dynamic>;
      final List<BillingStatusItem> loadedBillingStatus = [];
      if (responseData != null) {
        responseData.forEach((value) {
          if(value['message'] != 'noData')
          loadedBillingStatus.add(BillingStatusItem(
              id: value['number'].toString(),
              date: value['orderDate'].toString(),
              product: value['product'].toString(),
              quantity: value['qty'].toString(),
              price: value['price'].toString(),
              amount: value['amount'].toString(),
              vat: value['VAT'].toString()
          ));
        });
      }
      _billingStatus = loadedBillingStatus;
      print(_billingStatus);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
