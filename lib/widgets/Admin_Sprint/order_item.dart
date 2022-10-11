import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helper/convert_helper.dart';
import '../../screens/Admin_Sprint/order_detail_screen.dart';

class OrderItem extends StatelessWidget {
  final String id;
  final String numCmdClient;
  final String date;
  final String qtyOrd;
  final String qtySat;
  final String rate;
  final String ttc;

  OrderItem(this.id, this.numCmdClient, this.date, this.qtyOrd, this.qtySat,
      this.rate, this.ttc);

  @override
  Widget build(BuildContext context) {
    final oCcy = new NumberFormat("#,##0.00", "en_US");
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      width: constraints.maxWidth * 0.1,
                      child: Image.asset('assets/images/logo.png')),
                  Container(
                    width: constraints.maxWidth * 0.3,
                    color: Color.fromRGBO(74, 84, 89, .1),
                    padding: EdgeInsets.all(5),
                    child: AutoSizeText(
                      'N° $id',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      maxFontSize: 18,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: FittedBox(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Cdé Le: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${ConvertHelper.convertDateFromString(date)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                                color: Color.fromRGBO(74, 84, 89, .1),
                                padding: EdgeInsets.all(5),
                                child: FittedBox(
                                  child: Text('Cmd: $numCmdClient',
                                      style: TextStyle(
                                        fontSize: 15,
                                      )),
                                )),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: FittedBox(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Cdé: ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$qtyOrd TO',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 2.0, left: 2.0),
                            child: FittedBox(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Livré: ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$qtySat TO',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: FittedBox(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Rate: ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$rate%',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: constraints.maxWidth * 0.6,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Total TTC: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${oCcy.format(double.parse(ttc))} DA',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: constraints.maxWidth * 0.2,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Theme.of(context).accentColor,
                            child: FittedBox(
                              child: Text(
                                'Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration: Duration(
                                      milliseconds: 200,
                                    ),
                                    transitionsBuilder: (context, animation,
                                        animationTime, child) {
                                      animation = CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOut,
                                      );
                                      return FadeTransition(
                                        child: child,
                                        opacity: animation,
                                      );
                                    },
                                    pageBuilder:
                                        (context, animation, animationTime) {
                                      return OrderDetailScreen(id);
                                    }),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
