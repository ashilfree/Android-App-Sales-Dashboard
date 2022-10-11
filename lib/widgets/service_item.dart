import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  final String routeName;
  final String title;
  final IconData iconData;

  ServiceItem(this.routeName, this.iconData, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(routeName),
            child: Card(
              color: Color(0xff1F804C),
              elevation: 5,
              child: GridTile(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 4, color: Colors.white)),
                  child: Icon(
                    iconData,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          title,
          style: TextStyle(color: Color(0xff1F804C), fontSize: 17),
        )
      ],
    );
  }
}
