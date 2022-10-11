import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailItem extends StatelessWidget {
  final String product;
  final String quantity;
  final String price;
  final String amount;
  final String tva;

  OrderDetailItem({
    @required this.product,
    @required this.quantity,
    @required this.price,
    @required this.amount,
    @required this.tva,
  });

  @override
  Widget build(BuildContext context) {
    final oCcy = new NumberFormat("#,##0.00", "en_US");
    return Card(
      elevation: 1,
      color: Color.fromRGBO(74, 84, 89, .1),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('PRODUIT'),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                width: 1,
                color: Colors.white,
              )),
              child: Text(
                product,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Unité'),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.black26,
                      )),
                      child: Text('TO'),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Quantité'),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.black26,
                      )),
                      child: Text(quantity),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Prix Unitaire'),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.black26,
                      )),
                      child: Text('${oCcy.format(double.parse(price))} DA'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('TVA'),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.black26,
                      )),
                      child: Text('$tva%'),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  color: Color.fromRGBO(74, 84, 89, 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('TOTAL HT'),
                      Text(
                        '${oCcy.format(double.parse(amount))} DA',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
