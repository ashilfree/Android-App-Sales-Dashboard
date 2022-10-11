import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print(' could not launch $command');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            'assets/images/AqsClient_logo.png',
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: new Text(
                          'AQS Client Space',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff070707),
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: new Text(
                          'Version 2.1.1',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff070707),
                            fontFamily: 'Quicksand',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Center(
                        child: FlatButton(
                          textColor: Theme.of(context).accentColor,
                          onPressed: () {
                            customLaunch('https://aqs.dz');
                          },
                          child: AutoSizeText(
                            "Allez Au Site Web Officiel",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            maxFontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: AutoSizeText(
              "Copyright 2020 DSI - BDD & DEV DEPT",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff070707),
                fontWeight: FontWeight.w500,
                fontFamily: 'Quicksand',
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              maxFontSize: 14,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ClipOval(
              child: Material(
                child: InkWell(
                  splashColor: Color(0xff4A5459),
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(
                        Icons.cancel,
                        color: Color(0xff4A5459),
                      )),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
