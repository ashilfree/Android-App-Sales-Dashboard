import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/auth.dart';
import '../../providers/deliveries.dart';
import '../../screens/Client_Sprint/pdf_screen.dart';
import '../../widgets/Client_Sprint/delivery_list.dart';
import '../../widgets/errorDialog.dart';

class DeliveryStatusScreen extends StatefulWidget {
  @override
  _DeliveryStatusScreenState createState() => _DeliveryStatusScreenState();
}

class _DeliveryStatusScreenState extends State<DeliveryStatusScreen> {
  Future<void> _refreshProducts(
      {BuildContext context,
      Map<String, DateTime> pickedDates = const {
        "first_date": null,
        "last_date": null
      }}) async {
    try {
      if (Provider.of<Auth>(context, listen: false).token != null) {
        await Provider.of<Deliveries>(context, listen: false)
            .fetchAndSetDeliveryStatus(pickedDates);
      } else {
        Fluttertoast.showToast(msg: "Session expirée").then(
          (value) => Navigator.of(context).pushReplacementNamed("/"),
        );
      }
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

  void changeFirstState(DateTime date) {
    _refreshProducts(
        context: context, pickedDates: {"first_date": date, "last_date": null});
    setState(() {
    });
  }

  void changeLastState(DateTime date) {
    _refreshProducts(
        context: context, pickedDates: {"first_date": null, "last_date": date});
    setState(() {
    });
  }

  void restart() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final deliveries = Provider.of<Deliveries>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.print),
              onPressed: () async {
                Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async =>
                      await generateInvoice(
                    PdfPageFormat.a4,
                    deliveries.deliveries,
                    deliveries.firstPickedDate,
                    deliveries.lastPickedDate,
                    Deliveries.tableHeaders,
                    auth.denomination,
                    'Etat de livraison',
                    false,
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: _refreshProducts(context: context),
          builder: (ctx, snapShot) =>
              snapShot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : DeliveryList(size, changeFirstState, changeLastState,
                      restart),
        ),
      ),
    );
  }
}
