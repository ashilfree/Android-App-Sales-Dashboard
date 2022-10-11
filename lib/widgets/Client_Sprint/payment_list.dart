import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../helper/convert_helper.dart';
import '../../helper/function_helper.dart';
import '../../helper/style.dart';
import '../../providers/sold.dart';
import '../categories_scroller.dart';

class PaymentList extends StatefulWidget {
  final Size size;
  final Function firstFn;
  final Function lastFn;
  final Function fn;

  PaymentList(this.size, this.firstFn, this.lastFn, this.fn);

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  bool closeTopContainer = false;
  double topContainer = 0;
  var provider;

  @override
  void initState() {
    provider = Provider.of<Sold>(context, listen: false);
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
                  "Etat de paiement",
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
              child: Consumer<Sold>(
                builder: (ctx, sold, _) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: sold.paymentStatusList.length <= 0
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
                          itemCount: sold.paymentStatusList.length,
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
                                    child: Container(
                                      height: 220,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    Colors.black.withAlpha(100),
                                                blurRadius: 10.0),
                                          ]),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: FittedBox(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Image.asset(
                                                          "assets/images/logo.png",
                                                          width: 28,
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
                                                          "Chèque N°: ${sold.paymentStatusList[index].number}",
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
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      /*Image.asset(
                                                       "assets/images/fm.jpg",
                                                      width: 100,
                                                    ),*/
                                                      FaIcon(
                                                        FontAwesomeIcons.coins,
                                                        size: 32,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      /*Text(
                                                      "Chèque N°: ${sold.paymentStatusList[index].number}",
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey),
                                                    ),*/
                                                      Text(
                                                        "Etablie le: ${ConvertHelper.convertDateFromString(sold.paymentStatusList[index].date)}",
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      sold.paymentStatusList[index]
                                                                  .bank.length <=
                                                              20
                                                          ? Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Banque: ",
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
                                                                  "${sold.paymentStatusList[index].bank}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
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
                                                                  "Banque: ",
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
                                                                  "${sold.paymentStatusList[index].bank}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
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
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Text(
                                                  "Credit: ${currencyFormat(sold.paymentStatusList[index].amount)}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
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
