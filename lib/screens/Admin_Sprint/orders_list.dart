import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../animations/animator.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/orders.dart' show Orders;
import '../../widgets/Admin_Sprint/order_item.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/modal.dart';
import '../../widgets/progress_button.dart';

class OrdersList extends StatefulWidget {
  static const routeName = '/orders-list';

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  var isShow = false;
  Future<bool> _refreshProducts(
      {BuildContext context,
      Map<String, String> data = const {
        'invoiceId': '',
        'invoiceDate': '',
      }}) async {
    try {
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders(data);
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

  void getData(Map<String, String> data) {
    _refreshProducts(context: context, data: data);
  }

  void _showModalSheet(BuildContext buildContext) {
    showModalBottomSheet(
      context: buildContext,
      isScrollControlled: true,
      builder: (_) {
        return GestureDetector(
          child: Modal(getData),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('La liste des commandes'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.tune,
                color: Colors.white,
              ),
              onPressed: () {
                _showModalSheet(context);
              },
            )
          ],
        );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height -
        buildAppBar(context).preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
        appBar: buildAppBar(context),
        body: FutureBuilder(
          future: _refreshProducts(context: context),
          builder: (ctx, snapShot) =>
              snapShot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          _refreshProducts(context: context).then((value) {
                        if (value) setState(() {});
                      }),
                      child: Consumer<Orders>(
                        builder: (ctx, orders, _) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isShow
                              ? ProgressButtonDemo(
                                  () => _refreshProducts(context: context).then(
                                    (value) {
                                      if (!value) setState(() {});
                                    },
                                  ),
                                )
                              : orders.orders.length <= 0
                                  ? Center(
                                      child: Text(
                                        'Aucune résultat',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).errorColor,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                    )
                                  : Container(
                                    height: size,
                                      child: ListView.builder(
                                        itemBuilder: (ctx, i) => WidgetANimator(
                                          Column(
                                            children: <Widget>[
                                              OrderItem(
                                                orders.orders[i].id,
                                                orders.orders[i].numCmdClient,
                                                orders.orders[i].date,
                                                orders.orders[i].qtyOrd,
                                                orders.orders[i].qtySat,
                                                orders.orders[i].rate,
                                                orders.orders[i].ttc,
                                              ),
                                              Divider()
                                            ],
                                          ),
                                        ),
                                        itemCount: orders.orders.length,
                                      ),
                                    ),
                        ),
                      ),
                    ),
        ));
  }
}
