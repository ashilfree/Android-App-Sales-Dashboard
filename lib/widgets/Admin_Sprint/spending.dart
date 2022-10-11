import 'package:flutter/material.dart';

class Spending extends StatelessWidget {
  final String name;
  final String amount;
  Spending({
    Key key,
    @required this.name,
    @required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 4.0,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 15.0, bottom: 0.0, right: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            //borderRadius: BorderRadius.circular(40.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    Column(
                      children: <Widget>[
                        Container(
                          width: constraints.maxWidth * 0.8,
                          height: constraints.maxHeight * 0.3,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "$amount",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          width: constraints.maxWidth * 0.8,
                          height: constraints.maxHeight * 0.23,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
