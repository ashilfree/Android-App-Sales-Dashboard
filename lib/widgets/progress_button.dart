import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class ProgressButtonDemo extends StatefulWidget {
  final Function callback;

  ProgressButtonDemo(this.callback);

  @override
  State<StatefulWidget> createState() => _ProgressButtonDemoState();
}

class _ProgressButtonDemoState extends State<ProgressButtonDemo>{
  ButtonState stateTextWithIcon = ButtonState.idle;
  Widget buildTextWithIcon() {
    return ProgressButton.icon(iconedButtons: {
      ButtonState.idle: IconedButton(
          text: "Actualiser",
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
          color: Colors.green.shade400)
    }, onPressed:onPressedIconWithText, state: stateTextWithIcon);
  }

  void onPressedIconWithText() {
    widget.callback();
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            stateTextWithIcon = ButtonState.idle;
          });
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildTextWithIcon(),
    );

  }
}