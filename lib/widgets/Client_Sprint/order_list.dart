import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../helper/convert_helper.dart';
import '../../helper/function_helper.dart';
import '../../helper/style.dart';
import '../../providers/orders.dart';
import '../categories_scroller.dart';

class OrderList extends StatefulWidget {
  final Size size;
  final Function firstFn;
  final Function lastFn;
  final Function fn;
  OrderList(this.size, this.firstFn, this.lastFn, this.fn);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  bool closeTopContainer = false;
  double topContainer = 0;
  var provider;

  @override
  void initState() {
    provider = Provider.of<Orders>(context, listen: false);
    scrollController = ScrollController();
    scrollController.addListener(() {
      double value = scrollController.offset / 168.1;

      setState(() {
        topContainer = value;
        closeTopContainer = scrollController.offset > 50;
      });
    });
    fab = IconButton(
      icon: Icon(
        Icons.arrow_upward,
        color: Colors.white,
      ),
      onPressed: () {
        scrollController.animateTo(
          0.0,
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
        );
      },
    );

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if ((scrollMark - scrollController.position.pixels) > 50.0) {
          setState(() {
            reversing = true;
          });
        }
      } else {
        scrollMark = scrollController.position.pixels;
        setState(() {
          reversing = false;
        });
      }
    });
    super.initState();
  }

  ScrollController scrollController;
  bool reversing = false;
  double scrollMark;
  Widget fab;

  @override
  Widget build(BuildContext context) {
    final CategoriesScroller categoriesScroller = CategoriesScroller(
        widget.firstFn,
        widget.lastFn,
        provider.firstPickedDate,
        provider.lastPickedDate);
    final double categoryHeight = widget.size.height * 0.20;
    return Stack(children: [
      Container(
        height: widget.size.height,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Etat de commande",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: closeTopContainer ? 0 : 1,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.size.width,
                  alignment: Alignment.topCenter,
                  height: closeTopContainer ? 0 : categoryHeight,
                  child: categoriesScroller),
            ),
            Expanded(
              child: Consumer<Orders>(
                builder: (ctx, orders, _) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: orders.orderStatus.length <= 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Aucune résultat',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).errorColor,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: widget.fn,
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: orders.orderStatus.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            double scale = 1.0;
                            if (topContainer > 0.5) {
                              scale = index + 0.5 - topContainer;
                              if (scale < 0) {
                                scale = 0;
                              } else if (scale > 1) {
                                scale = 1;
                              }
                            }
                            return Opacity(
                              opacity: scale,
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..scale(scale, scale),
                                alignment: Alignment.bottomCenter,
                                child: Align(
                                  heightFactor: 0.7,
                                  alignment: Alignment.topCenter,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        height: 220,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withAlpha(100),
                                                  blurRadius: 10.0),
                                            ]),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              FittedBox(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 10,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Image.asset(
                                                          "assets/images/logo.png",
                                                          width: 25,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 8.0,
                                                          right: 8,
                                                          bottom: 8,
                                                        ),
                                                        child: Text(
                                                          "Commande N°: ${orders.orderStatus[index].id}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff1F804C),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 10,
                                                  top: 2,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "Etablie le: ${ConvertHelper.convertDateFromString(orders.orderStatus[index].date)}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        orders
                                                                    .orderStatus[
                                                                        index]
                                                                    .numCmdClient
                                                                    .length <=
                                                                8
                                                            ? Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "N° Commande Client: ",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      //fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${orders.orderStatus[index].numCmdClient}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              )
                                                            : Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "N° Commande Client: ",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      //fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${orders.orderStatus[index].numCmdClient}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "Quantité commandée: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                //fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${orders.orderStatus[index].qtyOrd} TO",
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "Rate: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                // fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${orders.orderStatus[index].rate} %",
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.5,
                                                    child: AutoSizeText(
                                                      "TOTAL: ${currencyFormat(orders.orderStatus[index].ttc)}",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      if (reversing && scrollController.position.pixels > 0.0)
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: aqsMaroonColor),
            child: fab,
          ),
        ),
    ]);
  }
}
