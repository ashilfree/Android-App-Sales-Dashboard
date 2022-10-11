import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class CategoriesScroller extends StatefulWidget {
  final Function firstFn;
  final Function lastFn;
  final DateTime fds;
  final DateTime lds;
  CategoriesScroller(this.firstFn, this.lastFn, this.fds, this.lds);

  @override
  _CategoriesScrollerState createState() => _CategoriesScrollerState();
}

class _CategoriesScrollerState extends State<CategoriesScroller> {
  var _createdDate;
  var _firstDateSelected;
  var _lastDateSelected;
  @override
  void initState() {
    _createdDate = Provider.of<Auth>(context, listen: false).createdAt;
    _firstDateSelected = widget.fds;
    _lastDateSelected = widget.lds;
    super.initState();
  }

  void _firstDatePicker() {
    showDatePicker(
            context: context,
            initialDate: _firstDateSelected,
            firstDate: _createdDate,
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _firstDateSelected = value;
      });
      widget.firstFn(value);
    });
  }

  void _lastDatePicker() {
    showDatePicker(
            context: context,
            initialDate: _lastDateSelected,
            firstDate: _createdDate,
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _lastDateSelected = value;
      });
      widget.lastFn(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return Container(
      height: categoryHeight,
      child: Center(
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "De :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                FlatButton(
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_firstDateSelected),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: _firstDatePicker,
                ),
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  iconSize: 20.0,
                  onPressed: _firstDatePicker,
                ),
                SizedBox(width: 20),
                Text(
                  "À :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                FlatButton(
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_lastDateSelected),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: _lastDatePicker,
                ),
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  iconSize: 20.0,
                  onPressed: _lastDatePicker,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
