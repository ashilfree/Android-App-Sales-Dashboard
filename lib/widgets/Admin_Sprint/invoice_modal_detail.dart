import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../helper/convert_helper.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/invoice.dart';
import '../errorDialog.dart';
import 'invoice_detail_item.dart';

class InvoiceModalDetail extends StatefulWidget {
  final String id;

  InvoiceModalDetail(this.id);

  @override
  _InvoiceModalDetailState createState() => _InvoiceModalDetailState();
}

class _InvoiceModalDetailState extends State<InvoiceModalDetail> {
  var _isLoading = false;

  @override
  void initState() {
    try {
      _isLoading = true;
      Provider.of<Invoice>(context, listen: false)
          .fetchAndSetInvoiceById(widget.id, context)
          .timeout(Duration(seconds: Constants.timeOut), onTimeout: () {
        throw Exception("time_out_err");
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } on SocketException catch (e) {
      final err = ErrorHandler.err(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(err['errorMessage'], err['buttonTxt']);
          });
    } catch (error) {
      Navigator.of(context).pop();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final invoiceDetail = Provider.of<Invoice>(context).invoice;
    return _isLoading
        ? Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : invoiceDetail.length == 0
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Aucun détail'),
                ),
              ],
            )
            : LayoutBuilder(builder: (context, constraints) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              color: Color.fromRGBO(74, 84, 89, .1),
                              padding: EdgeInsets.all(5),
                              child: Text('N°: ' + invoiceDetail[0].id),
                            ),
                            Container(
                              color: Color.fromRGBO(74, 84, 89, .1),
                              padding: EdgeInsets.all(5),
                              child: Text('Le: ' + ConvertHelper.convertDateFromString(invoiceDetail[0].date)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.48,
                          child: ListView.builder(
                            itemBuilder: (ctx, i) => InvoiceDetailItem(
                              product: invoiceDetail[i].product,
                              quantity: invoiceDetail[i].quantity,
                              price: invoiceDetail[i].price,
                              amount: invoiceDetail[i].amount,
                              tva: invoiceDetail[i].tva,
                            ),
                            itemCount: invoiceDetail.length,
                          ),
                        ),
                      ],
                    ));
              });
  }
}
