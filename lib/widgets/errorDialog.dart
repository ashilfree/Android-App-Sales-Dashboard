import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final String btnTxt;

  ErrorDialog(this.message, this.btnTxt);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Container(
        height: 172,
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.error_outline,
                      color: Theme.of(context).primaryColor,
                      size: 60,
                    ),
                  ),
                  Container(
                    height: 88,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                        left: 15,
                        right: 15,
                        bottom: 15,
                      ),
                      child: SingleChildScrollView(
                        child: AutoSizeText(
                          message,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff070707),
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                          ),
                          maxFontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Positioned(
              right: 8,
              bottom: 2,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  btnTxt,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
