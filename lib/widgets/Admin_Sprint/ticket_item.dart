import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/convert_helper.dart';
import '../../providers/ticket.dart';

class TicketItem extends StatelessWidget {
  final String noTicket;

  TicketItem(this.noTicket);

  @override
  Widget build(BuildContext context) {
    final ticket = Provider.of<Ticket>(context).ticket;
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        margin: EdgeInsets.all(20),
        elevation: 1,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text('ALGERIAN QATARI STEEL SPA'),
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.025,
                ),
                Container(
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Text(
                        'Zone Industrielle Bellara - El Milia - BP 629 Jijel'),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FittedBox(
                      child: Text('N°: ${ticket.number}'),
                    ),
                    FittedBox(
                      child: Text('N° Ticket: $noTicket'),
                    ),
                  ],
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.035,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Date: ${ConvertHelper.convertDateFromString(ticket.date)}'),
                    Text('Heure: ${ticket.tareTime}'),
                  ],
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.035,
                ),
                Text('Mat Camion: ${ticket.plateNumber}'),
                SizedBox(
                  height: constraints.maxHeight * 0.035,
                ),
                Text('Mat Remorque: ${ticket.trailerPlateNumber}'),
                SizedBox(
                  height: constraints.maxHeight * 0.035,
                ),
                FittedBox(child: Text('Client: ${ticket.denomination}')),
                SizedBox(
                  height: constraints.maxHeight * 0.035,
                ),
                FittedBox(child: Text('Produit: ${ticket.productRef}')),
                SizedBox(
                  height: constraints.maxHeight * 0.035,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Tare: ${ticket.tare} TO'),
                    Text('Heure: ${ticket.tareTime}'),
                  ],
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.035,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Brut: ${ticket.brut} TO'),
                    Text('Heure: ${ticket.brutTime}'),
                  ],
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.035,
                ),
                Text('Net: ${ticket.net} TO'),
                SizedBox(
                  height: constraints.maxHeight * 0.035,
                ),
                Text('Chauffeur: ${ticket.driverName}'),
              ],
            ),
          ),
        ),
      );
    });
  }
}
