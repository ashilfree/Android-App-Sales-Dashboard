import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Modal extends StatefulWidget {
  final Function onGetData;

  Modal(this.onGetData);

  @override
  _ModalState createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _selectedDay = DateTime.now();

  Map<String, String> _filterData = {
    'invoiceId': '',
    'invoiceDate': '',
  };

  void _submit() async {
    _formKey.currentState.save();
    widget.onGetData(_filterData);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2017),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDay = value;
        _filterData['invoiceDate'] =
            DateFormat('yyyy-MM-dd').format(_selectedDay);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Chercher Par :",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Numéro'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _filterData['invoiceId'] = value.toString();
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Date",
                            style: TextStyle(
                              color: Colors.black.withOpacity(.7),
                              fontSize: 16,
                            ),
                          ),
                          FlatButton(
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDay),
                              style: TextStyle(
                                color: Colors.black.withOpacity(.6),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: _presentDatePicker,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black.withOpacity(.6),
                            ),
                            iconSize: 25.0,
                            onPressed: _presentDatePicker,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        child: Text(
                          'Afficher',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: _submit,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        color: Theme.of(context).accentColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
