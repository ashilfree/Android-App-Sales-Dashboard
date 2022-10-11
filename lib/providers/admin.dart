import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Customer {
  final String id;
  final String denomination;
  final String password;
  final bool confirmation;
  final String status;
  final bool appUser;

  Customer({
    @required this.id,
    @required this.denomination,
    @required this.password,
    @required this.confirmation,
    @required this.status,
    @required this.appUser,
  });

  String get getStatus {
    if (!this.confirmation && this.status == "actif")
      return "En instance";
    else if (this.status == "blocked")
      return "Bloqué";
    else
      return this.status;
  }
}

class CustomerDetails {
  final String id;
  final String denomination;
  final String address;
  final String commRegister;
  final String fiscalID;
  final String articleNo;
  final String email;
  final String nif;
  final String nis;
  final String creationTime;
  final String createdAt;

  CustomerDetails({
    @required this.id,
    @required this.denomination,
    @required this.address,
    @required this.commRegister,
    @required this.fiscalID,
    @required this.articleNo,
    @required this.email,
    @required this.nif,
    @required this.nis,
    @required this.creationTime,
    @required this.createdAt,
  });
}

class Admin with ChangeNotifier {
  List<Customer> _customers = [];
  CustomerDetails _customer;
  String _search = '';
  final String userId;
  final String authToken;
  final DateTime createdAt;


  Admin(this.userId, this.authToken, this.createdAt);

  List<Customer> get customers {
    return [..._customers];
  }

  CustomerDetails get customer => _customer;

  String get search => _search;

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }



  Future<void> fetchAndSetCustomerList() async {
    const url = "${Constants.appLink}admin/clientslist";
    try {
      final response = await http.get(
        url,
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      final responseData = json.decode(response.body) as List<dynamic>;
      final List<Customer> loadedCustomers = [];
      if (responseData != null) {
        responseData.forEach((value) {
          if (value['message'] != 'noData')
            loadedCustomers.add(Customer(
                id: value['ID'].toString(),
                denomination: value['Denomination'].toString(),
                password: value['user_password'].toString(),
                confirmation: value['confirmation'],
                status: value['status'].toString(),
                appUser: value['using_app'] == 1));
        });
      }
      print(loadedCustomers);
      _customers = loadedCustomers;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // ignore: missing_return
  Future<bool> resetClientPassword(String id) async {
    var url = "${Constants.appLink}admin/resetclientpassword/$id";
    try {
      final response = await http.put(
        url,
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      print(responseData);
      if (responseData != null) {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> changeClientStatus(String id, String status) async {
    var url = "${Constants.appLink}admin/changeclientstatus/$id";
    try {
      final response = await http.put(url, headers: {
        "x-access-token": authToken
      }, body: {
        "status": status
      }).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      print(responseData);
      if (responseData != null) {
        if (responseData['error'] != 'true')
          return true;
        else
          return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<void> fetchAndSetCustomerById(String id) async {
    final url = "${Constants.appLink}admin/getclient/$id";
    try {
      final response = await http.get(
        url,
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      var customer;
      if (responseData != null) {
        if (responseData['message'] != 'noData')
          customer = CustomerDetails(
            id: responseData['ID'].toString(),
            denomination: responseData['Denomination'].toString(),
            address: responseData['Address'].toString(),
            commRegister: responseData['CommRegister'].toString(),
            fiscalID: responseData['FiscalID'].toString(),
            articleNo: responseData['ArticleNo'].toString(),
            email: responseData['email'].toString(),
            nif: responseData['nif'].toString(),
            nis: responseData['NIS'].toString(),
            creationTime: responseData['creation_time'].toString(),
            createdAt: responseData['created_at'].toString(),
          );
      }
      print(customer);
      _customer = customer;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
