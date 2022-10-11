import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/function_helper.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/sold.dart';
import '../errorDialog.dart';

class SoldApp extends StatelessWidget {

  Future<void> _refreshSold(BuildContext context) async {
    try {
      await Provider.of<Sold>(context, listen: false)
          .setSold();
    } on SocketException catch (e) {
      final err = ErrorHandler.err(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(err['errorMessage'], err['buttonTxt']);
          });
    } catch (error) {
      print("err: " + error.toString());
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: FutureBuilder(
        future:_refreshSold(context),
        builder:(ctx, snapShot) =>
        snapShot.connectionState == ConnectionState.waiting ?
          Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.9,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Image.asset(
                                'assets/images/AqsClient_logo.png',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Consumer<Sold>(
                          builder:(ctx, sold, _) => Center(
                            child: Column(
                              children: [
                                Text(currencyFormat('${sold.sold}')),
                                Text(currencyFormat('${sold.bail}')),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              child: AutoSizeText(
                "Copyright 2020 DSI - BDD & DEV",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff070707),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Quicksand',
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                maxFontSize: 14,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: ClipOval(
                child: Material(
                  child: InkWell(
                    splashColor: Color(0xff4A5459),
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.cancel,
                          color: Color(0xff4A5459),
                        )),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
