import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/order.dart';
import '../errorDialog.dart';
import 'order_detail_item.dart';

class OrderModalDetail extends StatefulWidget {
  final String id;

  OrderModalDetail(this.id);

  @override
  _OrderModalDetailState createState() => _OrderModalDetailState();
}

class _OrderModalDetailState extends State<OrderModalDetail> {
  var _isLoading = false;

  @override
  void initState() {
    try {
      _isLoading = true;
      Provider.of<Order>(context, listen: false)
          .fetchAndSetOrderById(widget.id, context)
          .timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      super.initState();
    } on SocketException catch (e) {
      final err = ErrorHandler.err(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(err['errorMessage'], err['buttonTxt']);
          });
    } catch (error) {
      if (error.toString().contains('time_out_err')) {
        ErrorToast.showToast();
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

  @override
  Widget build(BuildContext context) {
    final orderDetail = Provider.of<Order>(context).order;
    return _isLoading
        ? Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            height: 350,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      color: Color.fromRGBO(74, 84, 89, .1),
                      padding: EdgeInsets.all(5),
                      child: Text('N°: ' + orderDetail[0].numCmdClient),
                    ),
                    Container(
                      color: Color.fromRGBO(74, 84, 89, .1),
                      padding: EdgeInsets.all(5),
                      child:
                          Text('Le: ' + orderDetail[0].date.toIso8601String()),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 280,
                  child: ListView.builder(
                    itemBuilder: (ctx, i) => OrderDetailItem(
                      product: orderDetail[i].product,
                      quantity: orderDetail[i].qtyord,
                      price: orderDetail[i].price,
                      amount: orderDetail[i].ttc,
                      tva: orderDetail[i].tva,
                    ),
                    itemCount: orderDetail.length,
                  ),
                ),
              ],
            ));
  }
}
