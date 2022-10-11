import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

import '../models/error_handler.dart';
import '../models/error_toast.dart';
import '../providers/admin.dart';
import 'errorDialog.dart';

class ProgressButtonManager extends StatefulWidget {
  final String id;

  ProgressButtonManager(this.id);

  @override
  State<StatefulWidget> createState() => _ProgressButtonManagerState();
}

class _ProgressButtonManagerState extends State<ProgressButtonManager> {
  ButtonState stateTextWithIcon = ButtonState.idle;

  Widget buildTextWithIcon() {
    return ProgressButton.icon(iconedButtons: {
      ButtonState.idle: IconedButton(
          text: "Réinitialiser\nmot de passe",
          icon: Icon(Icons.refresh, color: Colors.white),
          color: Theme.of(context).accentColor),
      ButtonState.loading:
          IconedButton(text: "Veuillez patienter", color: Colors.white),
      ButtonState.fail: IconedButton(
          text: "Erreur",
          icon: Icon(Icons.cancel, color: Colors.white),
          color: Colors.red.shade300),
      ButtonState.success: IconedButton(
          text: "Succès",
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          color: Colors.green.shade400),
    }, onPressed: onPressedIconWithText, state: stateTextWithIcon);
  }

  void onPressedIconWithText() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Réinitialiser Mot de passe"),
        content:
            Text("Voulez-vous réinitialiser le mot de passe de ce client?"),
        actions: [
          RaisedButton(
            color: Colors.red,
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("Oui"),
          ),
          RaisedButton(
            color: Color(0xff4A5459),
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Non"),
          )
        ],
      ),
      barrierDismissible: true,
    ).then((value) {
      print(value);
      if (value) {
        switch (stateTextWithIcon) {
          case ButtonState.idle:
            stateTextWithIcon = ButtonState.loading;
            Future.delayed(Duration(seconds: 3), () async {
              try {
                await Provider.of<Admin>(context, listen: false)
                    .resetClientPassword(widget.id)
                    .then((value) {
                  if (value) {
                    setState(() {
                      stateTextWithIcon = ButtonState.success;
                    });
                  } else {
                    setState(() {
                      stateTextWithIcon = ButtonState.fail;
                    });
                  }
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
                        return ErrorDialog(
                            err['errorMessage'], err['buttonTxt']);
                      });
                }
              }
            });
            break;
          case ButtonState.loading:
            break;
          case ButtonState.success:
            // TODO: Handle this case.
            break;
          case ButtonState.fail:
            // TODO: Handle this case.
            break;
        }
        setState(() {
          stateTextWithIcon = stateTextWithIcon;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildTextWithIcon(),
    );
  }
}
