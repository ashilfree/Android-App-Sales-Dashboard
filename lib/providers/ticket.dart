import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';

class TicketItem {
  final String number;
  final String denomination;
  final String date;
  final String productRef;
  final String plateNumber;
  final String trailerPlateNumber;
  final String driverName;
  final String tare;
  final String tareTime;
  final String brut;
  final String brutTime;
  final String net;

  TicketItem({
      @required this.number,
      @required this.denomination,
      @required this.date,
      @required this.productRef,
      @required this.plateNumber,
      @required this.trailerPlateNumber,
      @required this.driverName,
      @required this.tare,
      @required this.tareTime,
      @required this.brut,
      @required this.brutTime,
      @required this.net,
  }
  );
}

class Ticket with ChangeNotifier{
  final String selectedCustomerId;
  final String authToken;
  TicketItem _ticket;

  String _ticketMode = "search";

  Ticket(this.selectedCustomerId, this.authToken);

  String get ticketMode{
    return _ticketMode;
  }

  TicketItem get ticket{
    return _ticket;
  }

  Future<void> fetchAndSetTicket(String noTicket) async{
    var url = "${Constants.appLink}user/ticket";
    try{
      var response = await http.post(url, body: {
        "agentno": selectedCustomerId,
        "ticketno": noTicket
      },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });
      print(response.body);
      var responseData = json.decode(response.body) as List<dynamic>;
      if(responseData[0]['error']!= null && responseData[0]['error']){
        throw Exception(responseData[0]['message']);
      }
      print(DateFormat.jm().format(DateTime.parse(responseData[0]['tare_time'])));
      _ticket = TicketItem(number: responseData[0]['Number'].toString(), denomination: responseData[0]['Denomination'], date: responseData[0]['date'], productRef: responseData[0]['productRef'], plateNumber: responseData[0]['platenumber'], trailerPlateNumber: responseData[0]['trailer_platenumber'], driverName: responseData[0]['drivername'], tare: responseData[0]['tare'].toString(), tareTime: DateFormat.jm().format(DateTime.parse(responseData[0]['tare_time'])), brut: responseData[0]['brut'].toString(), brutTime: DateFormat.jm().format(DateTime.parse(responseData[0]['brut_time'])), net: responseData[0]['net'].toString());
      notifyListeners();
    }catch(error){
      throw error;
    }
  }

}