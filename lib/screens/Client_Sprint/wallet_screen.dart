import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

import '../../helper/function_helper.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/auth.dart';
import '../../providers/sold.dart';
import '../../widgets/errorDialog.dart';

class WalletScreen extends StatelessWidget {
  final _backgroundColor = [
    Color.fromRGBO(249, 249, 249, 1),
    Color.fromRGBO(241, 241, 241, 1),
    Color.fromRGBO(233, 233, 233, 1),
    Color.fromRGBO(222, 222, 222, 1),
  ];
  final _iconColor = Colors.white;
  final _textColor = Colors.white;
  final _actionContainerColor = [
    Color.fromRGBO(74, 84, 89, 1),
    Color.fromRGBO(74, 84, 83, 1),
    Color.fromRGBO(74, 83, 76, 1),
    Color.fromRGBO(74, 83, 71, 1),
  ];
  // final _borderContainer = Color.fromRGBO(31, 148, 106, 1);
  final _borderContainer = Color.fromRGBO(255, 255, 255, 0);
  final logoImage = 'assets/images/wallet_icon.png';

  Future<void> _refreshSold(BuildContext context) async {
    try {
      if (Provider.of<Auth>(context, listen: false).token != null) {
        await Provider.of<Sold>(context, listen: false).setSold();
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
    final auth = Provider.of<Auth>(context);
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          title: Text(
            "Solde",
            style: TextStyle(color: Colors.black),
          ),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.2, 0.3, 0.5, 0.8],
              colors: _backgroundColor),
        ),
        body: FutureBuilder(
          future: _refreshSold(context),
          builder: (ctx, snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 1.157,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.2, 0.3, 0.5, 0.8],
                          colors: _backgroundColor)),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        logoImage,
                        fit: BoxFit.contain,
                        height: 100.0,
                        width: 100.0,
                        color: Colors.blueGrey[800],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 5,
                            right: 5,
                          ),
                          child: Consumer<Sold>(
                            builder: (ctx, sold, _) => SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      child: Image.asset(
                                        'assets/images/money_icon.png',
                                        fit: BoxFit.contain,
                                        color: Colors.blueGrey[800],
                                      ),
                                      backgroundColor: Colors.transparent,
                                      radius: 22,
                                    ),
                                    title: Text(
                                      "Solde",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.only(
                                        top: 8,
                                      ),
                                      child: Text(
                                        sold.sold != null
                                            ? "${currencyFormat((sold.sold - (sold.bail ?? 0)).toString())}"
                                            : "0.0 DA",
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Container(
                                      height: 1.0,
                                      color: Colors.black.withOpacity(.5),
                                    ),
                                  ),
                                  ListTile(
                                    leading: CircleAvatar(
                                      child: Image.asset(
                                        'assets/images/bail.png',
                                        fit: BoxFit.contain,
                                        color: Colors.blueGrey[800],
                                      ),
                                      backgroundColor: Colors.transparent,
                                      radius: 22,
                                    ),
                                    title: Text(
                                      "Caution",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.only(
                                        top: 8,
                                      ),
                                      child: Text(
                                        sold.bail != null
                                            ? "${currencyFormat((sold.bail).toString())}"
                                            : "0.0 DA",
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

// custom action widget
  Widget _actionList(String iconPath, String desc, int bail) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            iconPath,
            fit: BoxFit.contain,
            height: 55.0,
            width: 55.0,
            color: _iconColor,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            currencyFormat('$bail'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _textColor, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: TextStyle(color: _iconColor),
          )
        ],
      ),
    );
  }
}
