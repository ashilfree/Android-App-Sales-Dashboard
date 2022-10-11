import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helper/convert_helper.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/sold.dart';
import '../../widgets/Admin_Sprint/spending.dart';
import '../../widgets/Client_Sprint/payment_methods.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/progress_button.dart';

class SoldScreen extends StatefulWidget {
  static const routeName = '/Sold';

  @override
  _SoldScreenState createState() => _SoldScreenState();
}

class _SoldScreenState extends State<SoldScreen>
    with SingleTickerProviderStateMixin {
  var isShow = false;
  var _selectedDay = DateTime.now();

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.parse("2019-03-31"),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDay = value;
      });
    });
  }

  Future<bool> _refreshSold(BuildContext context) async {
    try {
      await Provider.of<Sold>(context, listen: false)
          .fetchAndSetSold(_selectedDay);
      isShow = false;
    } on SocketException catch (e) {
      isShow = true;
      final err = ErrorHandler.err(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(err['errorMessage'], err['buttonTxt']);
          });
    } catch (error) {
      print("err: " + error.toString());
      isShow = true;
      if (error.toString().contains('time_out_err')) {
        ErrorToast.showToast();
      } else {
        isShow = true;
        final err = ErrorHandler.err(error.toString());
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(err['errorMessage'], err['buttonTxt']);
            });
      }
    }
    return isShow;
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).accentColor,
      flexibleSpace: Center(
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Le :",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              FlatButton(
                child: Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDay),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: _presentDatePicker,
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                iconSize: 25.0,
                onPressed: _presentDatePicker,
              )
            ],
          ),
        ),
      ),
      bottom: TabBar(
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            text: "Statistique",
          ),
          Tab(
            child: Row(
              children: <Widget>[
                Icon(Icons.history),
                SizedBox(
                  width: 8,
                ),
                Text("Historique"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final oCcy = new NumberFormat("#,##0.00", "en_US");
    double size =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return LayoutBuilder(builder: (context, constraints) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(size * 0.32),
              child: buildAppBar(context)),
          body: FutureBuilder(
            future: _refreshSold(context),
            builder: (ctx, snapShot) => snapShot.connectionState ==
                    ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : TabBarView(
                    children: [
                      Consumer<Sold>(
                        builder: (ctx, sold, _) => isShow
                            ? ProgressButtonDemo(
                                () => _refreshSold(context).then((value) {
                                      if (!value) setState(() {});
                                    }))
                            : Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.only(top: 15),
                                    padding: new EdgeInsets.only(
                                      //top: 10,
                                      right: 20.0,
                                      left: 20.0,
                                    ),
                                    child: new Container(
                                      height: size * 0.46 -15,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView(
                                        primary: false,
                                        children: <Widget>[
                                          PaymentMethods(
                                            name: "Solde",
                                            amount:
                                                "${oCcy.format(sold.credit - sold.debit)} DA",
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          PaymentMethods(
                                            name: "Crédit",
                                            amount:
                                                "${oCcy.format(sold.credit)} DA",
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          PaymentMethods(
                                            name: "La somme des factures",
                                            amount:
                                                "${oCcy.format(sold.debit)} DA",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: new EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          .04,
                                      left: MediaQuery.of(context).size.width *
                                          .04,
                                    ),
                                    child: new Container(
                                      height: size * 0.22 - 15,
                                      width:
                                          MediaQuery.of(context).size.width,
                                      child: GridView(
                                        primary: false,
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio:
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  ((size - 15) / 2.5),
                                        ),
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                              right: 10.0,
                                            ),
                                            child: Spending(
                                              name: "Ce mois-ci",
                                              amount:
                                                  "${oCcy.format(sold.lastMonth)} DA",
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Spending(
                                              name: "Cette semaine",
                                              amount:
                                                  "${oCcy.format(sold.lastWeek)} DA",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      Consumer<Sold>(
                        builder: (ctx, sold, _) => isShow
                            ? ProgressButtonDemo(
                                () => _refreshSold(context).then((value) {
                                      if (!value) setState(() {});
                                    }))
                            : Column(
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    alignment: Alignment.topLeft,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: AutoSizeText(
                                          'La liste des chèques',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          maxFontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size * 0.68 - 58,
                                    child: ListView.builder(
                                      itemCount: sold.checkCreditList.length,
                                      itemBuilder: (ctx, i) => ListTile(
                                        leading: CircleAvatar(
                                          child: FaIcon(
                                            FontAwesomeIcons.coins,
                                            size: 22,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          radius: 18,
                                        ),
                                        title: Container(
                                          child: Text(
                                            "${oCcy.format(double.parse(sold.checkCreditList[i].credit))} DA",
                                          ),
                                        ),
                                        subtitle: Container(
                                          child: Text(
                                            "Le : ${ConvertHelper.convertDateFromString(sold.checkCreditList[i].crDate)}",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
