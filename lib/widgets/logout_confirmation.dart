import 'package:flutter/material.dart';

class LogoutConfirmation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Déconnecter"),
      content: Text("Voulez-vous vraiment vous déconnecter?"),
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
    );
  }
}
