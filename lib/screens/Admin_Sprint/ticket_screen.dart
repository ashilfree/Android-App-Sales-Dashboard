import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/ticket.dart' show Ticket;
import '../../widgets/Admin_Sprint/ticket_item.dart';
import '../../widgets/errorDialog.dart';

enum TicketMode { search, show }

class TicketScreen extends StatelessWidget {
  static const routeName = '/ticket';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Ticket de pesée'),
          ),
        ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
          ),
          AuthCard(),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TicketMode _ticketMode = TicketMode.search;
  Map<String, String> _ticketData = {'noTicket': ''};
  var _isLoading = false;

  // void _showErrorDialog(String message) {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) {
  //         return AlertDialog(
  //           title: Text('an Error'),
  //           content: Text(message),
  //           actions: <Widget>[
  //             FlatButton(
  //                 onPressed: () {
  //                   Navigator.of(ctx).pop();
  //                 },
  //                 child: Text('Ok'))
  //           ],
  //         );
  //       });
  // }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Ticket>(context, listen: false)
          .fetchAndSetTicket(_ticketData['noTicket']);
      setState(() {
        _ticketMode = TicketMode.show;
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
    setState(() {
      _isLoading = false;
    });
  }

  // void _switchTicketMode() {
  //   if (_ticketMode == TicketMode.search) {
  //     setState(() {
  //       _ticketMode = TicketMode.show;
  //     });
  //   } else {
  //     setState(() {
  //       _ticketMode = TicketMode.search;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: _ticketMode == TicketMode.search
          ? Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8.0,
              child: Container(
                height: 260,
                constraints: BoxConstraints(minHeight: 260),
                width: deviceSize.width * 0.75,
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Numéro de ticket'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Entrer un numero!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _ticketData['noTicket'] = value;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (_isLoading)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          else
                            RaisedButton(
                              child: Text('Afficher', style: TextStyle(fontSize: 16,),),
                              onPressed: _submit,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              color: Theme.of(context).accentColor,
                              textColor: Theme.of(context)
                                  .primaryTextTheme
                                  .button
                                  .color,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : TicketItem(_ticketData['noTicket']),
    );
  }
}
