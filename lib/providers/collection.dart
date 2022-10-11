import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';

class CollectionItem {
  final DateTime date;
  final double collection;

  CollectionItem({
    @required this.date,
    @required this.collection,
  });
}

class Collection with ChangeNotifier {

  List<CollectionItem> _collections = [];
  final String authToken;
  DateTime _firstPickedDate;
  DateTime _lastPickedDate;
  double _total =0;

  Collection(this.authToken){
    _firstPickedDate = DateTime.now().subtract(Duration(days: 7));
    _lastPickedDate = DateTime.now();
  }

  List<CollectionItem> get collections {
    return [..._collections];
  }

  DateTime get firstPickedDate => _firstPickedDate;
  DateTime get lastPickedDate => _lastPickedDate;

  double get total => _total;

  void resetDate(){
    _firstPickedDate = DateTime.now().subtract(Duration(days: 7));
    _lastPickedDate = DateTime.now();
  }

  Future<void> fetchAndSetCollection(Map<String, DateTime> pickedDates) async {
    const url = "${Constants.appLink}superadmin/collection";
    if(pickedDates["first_date"] != null)
      _firstPickedDate = pickedDates["first_date"];
    if(pickedDates["last_date"] != null)
      _lastPickedDate = pickedDates["last_date"];
    try {
      final response = await http.post(
        url,
        body: {
          "first_date": pickedDates["first_date"] != null ? DateFormat('yyyy-MM-dd').format(pickedDates["first_date"]) : DateFormat('yyyy-MM-dd').format(_firstPickedDate),
          "last_date": pickedDates["last_date"] != null ? DateFormat('yyyy-MM-dd').format(pickedDates["last_date"]) : DateFormat('yyyy-MM-dd').format(_lastPickedDate),
        },
        headers: {"x-access-token": authToken},
      ).timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      });

      final responseData = json.decode(response.body) as List<dynamic>;
      final List<CollectionItem> loadedCollection = [];
      if (responseData != null) {
        if(!responseData[0].containsKey("error"))
        responseData.forEach((value) {
          loadedCollection.add(CollectionItem(
              date: DateTime(value['AA'], value['MM'], value['days']),
              collection: (value['collection'] is int) ? value['collection'].toDouble():value['collection'],
          ));
        });
      }
      print(loadedCollection);
      _collections = loadedCollection;
      _total = loadedCollection.map<double>((p) => (p.collection)).reduce((a, b) => a + b);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
