import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../animations/animator.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/invoices.dart' show Invoices;
import '../../widgets/Admin_Sprint/invoice_item.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/modal.dart';
import '../../widgets/progress_button.dart';

class InvoicesList extends StatefulWidget {
  static const routeName = '/invoices-list';

  @override
  _InvoicesListState createState() => _InvoicesListState();
}

class _InvoicesListState extends State<InvoicesList> {
  var isShow = false;
  Future<bool> _refreshProducts(
      {BuildContext context,
      Map<String, String> data = const {
        'invoiceId': '',
        'invoiceDate': '',
      }}) async {
    try {
      await Provider.of<Invoices>(context, listen: false)
          .fetchAndSetInvoices(data);
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
      if (error.toString().contains('time_out_err')) {
        ErrorToast.showToast();
        isShow = true;
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
        child: Text('La liste des factures'),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.tune,
            color: Colors.white,
          ),
          onPressed: isShow
              ? null
              : () {
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
                    child: Consumer<Invoices>(
                      builder: (ctx, invoices, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isShow
                            ? ProgressButtonDemo(
                                () => _refreshProducts(context: context).then(
                                  (value) {
                                    if (!value) setState(() {});
                                  },
                                ),
                              )
                            : invoices.invoices.length <= 0
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
                                            InvoiceItem(
                                              invoices.invoices[i].id,
                                              invoices.invoices[i].dateTime,
                                              invoices.invoices[i].amount,
                                            ),
                                            Divider()
                                          ],
                                        ),
                                      ),
                                      itemCount: invoices.invoices.length,
                                    ),
                                  ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
