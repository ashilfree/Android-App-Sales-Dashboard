import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';
import '../helper/convert_helper.dart';

class DeliveryStatusItem {
  final String id;
  final String product;
  final String date;
  final String plateNumber;
  final String trailerPlateNumber;
  final String brutWeight;
  final String tareWeight;
  final String brutTime;
  final String tareTime;
  final String driverName;
  final String ticketNumber;

  DeliveryStatusItem({
    @required this.id,
    @required this.product,
    @required this.date,
    @required this.plateNumber,
    @required this.trailerPlateNumber,
    @required this.brutWeight,
    @required this.tareWeight,
    @required this.brutTime,
    @required this.tareTime,
    @required this.driverName,
    @required this.ticketNumber,
  });

  String getIndex(int index) {
    switch (index) {
      case 0:
        return id;
      case 1:
        return product;
      case 2:
        return plateNumber;
      case 3:
        return trailerPlateNumber;
      case 4:
        return '$brutWeight TO';
      case 5:
        return ConvertHelper.convertTimeFromString(brutTime);
      case 6:
        return '$tareWeight TO';
      case 7:
        return ConvertHelper.convertTimeFromString(tareTime);
      case 8:
        return driverName;
      case 9:
        return ticketNumber;
    }
    return '';
  }
}

class Deliveries with ChangeNotifier {
  static const tableHeaders = [
    'N°',
    'Product',
    'N° Mat',
    'N° Rem',
    'Brut (TO)',
    'Temps',
    'Tare (TO)',
    'Temps',
    'Chauffeur',
    'Ticket',
  ];
  List<DeliveryStatusItem> _deliveries = [];
  final String userId;
  final String authToken;
  final DateTime createdAt;
  DateTime _firstPickedDate;
  DateTime _lastPickedDate;

  Deliveries(this.userId, this.authToken, this.createdAt){
    _firstPickedDate = this.createdAt;
    _lastPickedDate = DateTime.now();
  }

  List<DeliveryStatusItem> get deliveries {
    return [..._deliveries];
  }

  DateTime get firstPickedDate => _firstPickedDate;
  DateTime get lastPickedDate => _lastPickedDate;

  void resetDate(){
    _firstPickedDate = this.createdAt;
    _lastPickedDate = DateTime.now();
  }

  Future<void> fetchAndSetDeliveryStatus(Map<String, DateTime> pickedDates) async {
    const url = "${Constants.appLink}user/deliverystatus";
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
      print(response.body);
      final responseData = json.decode(response.body) as List<dynamic>;
      final List<DeliveryStatusItem> loadedDeliveryStatus = [];
      if (responseData != null) {
        responseData.forEach((value) {
          if(value['message'] != 'noData')
          loadedDeliveryStatus.add(DeliveryStatusItem(
              id: value['Number'].toString(),
              product: value['productRef'].toString(),
              date: value['date'].toString(),
              plateNumber: value['platenumber'].toString(),
              trailerPlateNumber: value['trailer_platenumber'].toString(),
              brutWeight: value['brut_weight'].toString(),
              tareWeight: value['tare_weight'].toString(),
              brutTime: value['brut_time'].toString(),
              tareTime: value['tare_time'].toString(),
              driverName: value['drivername'].toString(),
              ticketNumber: value['existOrderNumber'].toString(),
          ));
        });
      }
      _deliveries = loadedDeliveryStatus;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
