import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';
import '../helper/convert_helper.dart';

class CheckItem {
  final String credit;
  final String crDate;

  CheckItem(this.credit, this.crDate);
}

class PaymentItem {
  final String number;
  final String bank;
  final String date;
  final String amount;

  PaymentItem({
    this.number,
    this.bank,
    this.date,
    this.amount,
  });

  String getIndex(int index) {
    switch (index) {
      case 0:
        return number;
      case 1:
        return bank;
      case 2:
        return ConvertHelper.convertDateFromString(date);
      case 3:
        return amount;
    }
    return '';
  }
}

class Sold with ChangeNotifier {
  static const tableHeaders = [
    'N° Chèque',
    'Banque',
    'Date',
    'Crédit'
  ];
  int _credit = 0;
  int _debit = 0;
  int _sold = 0;
  int _bail = 0;
  int _lastWeek = 0;
  int _lastMonth = 0;
  final String userId;
  final String selectedCustomerId;
  final String authToken;
  final DateTime createdAt;
  DateTime _firstPickedDate;
  DateTime _lastPickedDate;
  List<CheckItem> _checkCreditList = [];
  List<PaymentItem> _paymentStatusList = [];


  Sold(this.userId, this.selectedCustomerId, this.authToken, this.createdAt){
    _firstPickedDate = this.createdAt;
    _lastPickedDate = DateTime.now();
  }

  int get credit {
    return _credit;
  }

  int get debit {
    return _debit;
  }

  int get sold {
    return _sold;
  }

  int get bail {
    return _bail;
  }

  int get lastWeek {
    return _lastWeek;
  }

  int get lastMonth {
    return _lastMonth;
  }

  List<CheckItem> get checkCreditList {
    return [..._checkCreditList];
  }

  List<PaymentItem> get paymentStatusList {
    return [..._paymentStatusList];
  }

  DateTime get firstPickedDate => _firstPickedDate;
  DateTime get lastPickedDate => _lastPickedDate;

  void resetDate(){
    _firstPickedDate = this.createdAt;
    _lastPickedDate = DateTime.now();
  }

  Future<void> setSold() async {
    var url = "${Constants.appLink}user/sold";
    try {
      var response = await http.post(
        url,
        body: {
          "accountno": userId,
          "account_date": DateFormat('yyyy-MM-dd').format(DateTime.now())
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      var responseData = json.decode(response.body) as List<dynamic>;
      _sold = responseData[0]['sold'];

      url = "${Constants.appLink}user/caution";
      response = await http.post(
        url,
        body: {
          "agentno": userId,
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      responseData = json.decode(response.body) as List<dynamic>;
      _bail = responseData[0]['caution'];
      print('solde: $_sold bail: $_bail');
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetSold(DateTime date) async {
    var url = "${Constants.appLink}user/credit";
    try {
      var response = await http.post(
        url,
        body: {
          "accountno": selectedCustomerId,
          "account_date": DateFormat('yyyy-MM-dd').format(date)
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      var responseData = json.decode(response.body) as List<dynamic>;
      _debit = responseData[0]['db'];
      _credit = responseData[0]['cr'];

      url = "${Constants.appLink}user/debit";
      response = await http.post(
        url,
        body: {
          "accountno": selectedCustomerId,
          "beginning_date":
              DateFormat('yyyy-MM-dd').format(date.subtract(Duration(days: 7))),
          "finishing_date": DateFormat('yyyy-MM-dd').format(date)
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      responseData = json.decode(response.body) as List<dynamic>;
      _lastWeek = responseData[0]['db'] == null ? 0 : responseData[0]['db'];
      response = await http.post(
        url,
        body: {
          "accountno": selectedCustomerId,
          "beginning_date": DateFormat('yyyy-MM-dd')
              .format(date.subtract(Duration(days: 30))),
          "finishing_date": DateFormat('yyyy-MM-dd').format(date)
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      responseData = json.decode(response.body) as List<dynamic>;
      _lastMonth = responseData[0]['db'] == null ? 0 : responseData[0]['db'];
      //---------------
      url = "${Constants.appLink}user/soldebydate";

      response = await http.post(
        url,
        body: {
          "accountno": selectedCustomerId,
          "account_date": DateFormat('yyyy-MM-dd').format(date)
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      responseData = json.decode(response.body);
      print(responseData);
      List<CheckItem> res = [];
      if (responseData != null) {
        responseData.forEach((value) {
          res.add(CheckItem(
              value['credit'].toString(), value['cr_date'].toString()));
        });
      }
      _checkCreditList = res;
      print(_checkCreditList);
      //---------------
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetPaymentStatus(Map<String, DateTime> pickedDates) async {
    var url = "${Constants.appLink}user/paymentstatus";
    if(pickedDates["first_date"] != null)
      _firstPickedDate = pickedDates["first_date"];
    if(pickedDates["last_date"] != null)
      _lastPickedDate = pickedDates["last_date"];
    try {
      var response = await http.post(
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
      print(response.body);
      var responseData = json.decode(response.body) as List<dynamic>;

      List<PaymentItem> res = [];
      if (responseData != null) {
        responseData.forEach((value) {
          if(value['message'] != 'noData')
          res.add(
            PaymentItem(
              number: value["number"].toString(),
              bank: value["bank"].toString(),
              date: value["date"].toString(),
              amount: value["amount"].toString(),
            ),
          );
        });
      }
      _paymentStatusList = res;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
