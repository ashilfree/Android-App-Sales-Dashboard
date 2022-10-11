import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../constants.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/order.dart';
import '../../widgets/errorDialog.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = 'order-detail';
  final String id;

  OrderDetailScreen(this.id);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final oCcy = new NumberFormat("#,##0.00", "en_US");
    final orderDetail = Provider.of<Order>(context).order;
    final screenheigth = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: <Widget>[
          Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenheigth * 0.2),
              child: AppBar(
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Commande N°: ${widget.id}'),
                ),
              ),
            ),
            body: Container(
              color: Color.fromRGBO(74, 84, 89, .1),
            ),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: screenheigth * 0.05),
              child: _isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : CarouselSlider(
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        reverse: false,
                        height: screenheigth * 0.77,
                        enlargeCenterPage: true,

                      ),
                      items: orderDetail
                          .map((item) => Container(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: constraints.maxWidth * 0.7,
                                          child: FittedBox(
                                            alignment: Alignment.center,
                                            fit: BoxFit.scaleDown,
                                            child: Text(item.product),
                                          ),
                                        ),
                                        SizedBox(
                                          height: constraints.maxHeight * 0.01,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircularStepProgressIndicator(
                                              totalSteps: 100,
                                              currentStep: item.rate == null
                                                  ? 0
                                                  : (double.parse(item.rate))
                                                              .round() >
                                                          100
                                                      ? 100
                                                      : (double.parse(
                                                              item.rate))
                                                          .round(),
                                              stepSize: 10,
                                              selectedColor:
                                                  item.status == 'Validée'
                                                      ? Theme.of(context)
                                                          .accentColor
                                                          .withOpacity(.8)
                                                      : Theme.of(context)
                                                          .primaryColor,
                                              unselectedColor: Colors.grey[200],
                                              padding: 0,
                                              width:
                                                  constraints.maxWidth * 0.45,
                                              height:
                                                  constraints.maxWidth * 0.45,
                                              selectedStepSize: 15,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    item.status,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: item.status ==
                                                                'Validée'
                                                            ? Theme.of(context)
                                                                .accentColor
                                                            : Theme.of(context)
                                                                .primaryColor),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text('${item.rate}%')
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: constraints.maxHeight * 0.02,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Prix Unitaire'),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 30.0),
                                                  child: Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: Text(
                                                      '${item.price} DA',
                                                    ),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .errorColor
                                                          .withOpacity(.5),
                                                    )),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('TVA'),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: Text('${item.tva}%'),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .errorColor
                                                        .withOpacity(.5),
                                                  )),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: constraints.maxHeight * 0.02,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Quantité Commandée'),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: Text(item.qtyord),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .errorColor
                                                        .withOpacity(.5),
                                                  )),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Unité'),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: Text('TO'),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .errorColor
                                                          .withOpacity(.5),
                                                    )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: constraints.maxHeight * 0.02,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Quantité Livrée'),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: Text(item.qtysat),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .errorColor
                                                        .withOpacity(.5),
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: constraints.maxHeight * 0.02,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(10),
                                              color: Theme.of(context)
                                                  .accentColor
                                                  .withOpacity(.8),
                                              child: Text(
                                                'Montant: ${oCcy.format(double.parse(item.ttc))} DA',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                              ))
                          .toList(),
                    ))
        ],
      );
    });
  }
}
