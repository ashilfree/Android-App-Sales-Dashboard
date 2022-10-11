import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/error_handler.dart';
import '../models/error_toast.dart';
import '../widgets/errorDialog.dart';

class OrderItem {
  final DateTime date;
  final String numCmdClient;
  final String product;
  final String qtyord;
  final String qtysat;
  final String price;
  final String rate;
  final String status;
  final String tva;
  final String ttc;

  OrderItem({
    this.date,
    this.numCmdClient,
    this.product,
    this.qtyord,
    this.qtysat,
    this.price,
    this.rate,
    this.status,
    this.tva,
    this.ttc,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _order = [];
  final String userId;
  final String authToken;

  Order(this.userId, this.authToken);

  List<OrderItem> get order {
    return [..._order];
  }

  Future<void> fetchAndSetOrderById(String id, BuildContext context) async {
    const url = "${Constants.appLink}user/orderdetail";
    try {
      final response = await http.post(
        url,
        body: {"agentno": userId, "num": id},
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      final responseData = json.decode(response.body) as List<dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (responseData != null) {
        responseData.forEach((value) {
          loadedOrders.add(OrderItem(
            numCmdClient: value['tr'],
            date: DateTime.parse(value['dat']),
            product: value['r'],
            qtyord: value['qtyord'].toString(),
            qtysat: value['qtysat'].toString(),
            price: value['p'].toString(),
            rate: value['rate'].toString(),
            status: value['ds'],
            ttc: value['TTC'].toString(),
            tva: value['VAT'].toString(),
          ));
        });
      }

      _order = loadedOrders;
      notifyListeners();
    } on SocketException catch (e) {
      Navigator.of(context).pop();
      final err = ErrorHandler.err(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(err['errorMessage'], err['buttonTxt']);
          });
    } catch (error) {
      if (error.toString().contains('time_out_err')) {
        ErrorToast.showToast();
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        final err = ErrorHandler.err(error.toString());
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(err['errorMessage'], err['buttonTxt']);
            });
      }
    }
  }
}
