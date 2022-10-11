import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../helper/function_helper.dart';
import '../../helper/style.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/remainder_orders.dart';
import '../../widgets/Super_Admin_Sprint/remainder_orders_chart.dart';
import '../../widgets/errorDialog.dart';

class RemainderOrdersScreen extends StatefulWidget {
  @override
  _RemainderOrdersScreenState createState() => _RemainderOrdersScreenState();
}

class _RemainderOrdersScreenState extends State<RemainderOrdersScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshProducts(
      {BuildContext context,
      Map<String, DateTime> pickedDates = const {
        "first_date": null,
        "last_date": null
      }}) async {
    try {
      await Provider.of<RemainderOrder>(context, listen: false)
          .fetchAndSetremainderOrder();
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
    final Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.30),
          child: AppBar(
            elevation: 0,
            backgroundColor: aqsGreenColor,
            flexibleSpace: Center(
              child: FittedBox(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "RELIQUAT",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "Quicksand"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FittedBox(
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Consumer<RemainderOrder>(
                                builder: (ctx, remainderOrder, _) => Text(
                                  numberFormat(remainderOrder.total) + " To",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Quicksand",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.timeline),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Graphique"),
                    ],
                  ),
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
          ),
        ),
        body: FutureBuilder(
          future: _refreshProducts(context: context),
          builder: (ctx, snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  children: [
                    RemainderOrdersChart(),
                    Consumer<RemainderOrder>(
                      builder: (ctx, remainderOrder, _) => remainderOrder
                                  .remainderOrders.length ==
                              0
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Aucune Résultat",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: () {
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                top: 10,
                                bottom: 10,
                              ),
                              child: ListView.builder(
                                itemCount: remainderOrder
                                    .reverseRemainderOrders.length,
                                itemBuilder: (ctx, index) => Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "${remainderOrder.reverseRemainderOrders[index].ref}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Container(
                                        margin: EdgeInsets.only(
                                          top: 8,
                                        ),
                                        child: Text(
                                          "${remainderOrder.reverseRemainderOrders[index].qty} To",
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(.9),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            aqsGrayColor.withOpacity(.2),
                                        child: FittedBox(
                                          child: Text(
                                            remainderOrder
                                                .reverseRemainderOrders[index]
                                                .rate,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        radius: 20,
                                      ),
                                    ),
                                    if (remainderOrder
                                            .reverseRemainderOrders.length !=
                                        index + 1)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Container(
                                          height: 1.0,
                                          color: aqsGrayColor.withOpacity(.5),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
