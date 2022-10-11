import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helper/convert_helper.dart';
import 'invoice_modal_detail.dart';

class InvoiceItem extends StatelessWidget {
  final String id;
  final String dateTime;
  final String amount;

  InvoiceItem(this.id, this.dateTime, this.amount);

  void _showModalSheet(BuildContext buildContext) {
    showModalBottomSheet(
      context: buildContext,
      isScrollControlled: true,
      builder: (_) {
        return GestureDetector(
          child: InvoiceModalDetail(id),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("#,##0.00", "en_US");
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
                    child: Image.asset('assets/images/logo.png'),
                  ),
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
                      children: <Widget>[
                        Text(
                          'Etablie Le: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ConvertHelper.convertDateFromString(dateTime),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: constraints.maxWidth * 0.6,
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
                                '${oCcy.format(double.parse(amount))} DA',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        ButtonTheme(
                          minWidth: constraints.maxWidth * 0.2,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Theme.of(context).accentColor,
                            child: Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              _showModalSheet(context);
                            },
                          ),
                        ),
                      ],
                    ),
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
