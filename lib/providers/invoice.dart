import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/error_handler.dart';
import '../models/error_toast.dart';
import '../widgets/errorDialog.dart';

class InvoiceItem {
  final String id;
  final String date;
  final String product;
  final String quantity;
  final String price;
  final String amount;
  final String tva;

  InvoiceItem(
      {this.id,
      this.date,
      this.product,
      this.quantity,
      this.price,
      this.amount,
      this.tva});
}

class Invoice with ChangeNotifier {
  List<InvoiceItem> _invoice = [];
  final String userId;
  final String authToken;

  Invoice(this.userId, this.authToken);

  List<InvoiceItem> get invoice {
    return [..._invoice];
  }

  Future<void> fetchAndSetInvoiceById(String id, BuildContext context) async {
    const url = '${Constants.appLink}user/invoicedetail';
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
      final List<InvoiceItem> loadedInvoices = [];
      if (responseData != null) {
        responseData.forEach((value) {
          loadedInvoices.add(InvoiceItem(
              id: value['number'].toString(),
              date: value['orderDate'],
              product: value['product'],
              quantity: value['qty'].toString(),
              price: value['price'].toString(),
              amount: value['amount'].toString(),
              tva: value['VAT'].toString()));
        });
      }
      _invoice = loadedInvoices;
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
