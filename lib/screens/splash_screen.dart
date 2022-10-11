import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(child: Image.asset('assets/images/ringaqs.gif'))
        ],

      ),),
    );
  }
}
