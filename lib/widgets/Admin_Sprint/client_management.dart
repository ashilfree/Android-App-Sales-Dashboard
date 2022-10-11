import 'dart:io';

import '../../helper/convert_helper.dart';
import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/admin.dart';
import '../errorDialog.dart';
import '../progress_button_manager.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientManagement extends StatefulWidget {
  final String id;
  final String status;

  ClientManagement(this.id, this.status);

  @override
  _ClientManagementState createState() => _ClientManagementState();
}

class _ClientManagementState extends State<ClientManagement> {
  String getInitials(initword) {
    List<String> names = initword.split(" ");
    String initials = "";
    int numWords = 1;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

  bool isSwitched;
  String status;

  bool checkStatus(String status) {
    if (status == "actif") {
      isSwitched = false;
    } else {
      isSwitched = true;
    }
    return isSwitched;
  }

  @override
  void initState() {
    status = widget.status;
    print(status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Consumer<Admin>(
            builder: (ctx, admin, _) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      status == "actif"
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Color(0xff1F804C),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0, left: 12, right: 12),
                                child: Text(
                                  "Actif",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Color(
                                  0xff4A5459,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0, left: 12, right: 12),
                                child: Text(
                                  "Bloqué",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Card(
                      elevation: 0,
                      child: CircleAvatar(
                        backgroundColor: Color(0xff4A5459),
                        radius: 31,
                        child: FittedBox(
                          child: Text(
                            getInitials(admin.customer.denomination),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: AutoSizeText(
                            admin.customer.denomination,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 3,
                            maxFontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: AutoSizeText(
                            admin.customer.address,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                            maxLines: 3,
                            maxFontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          width: 120,
                          child: FittedBox(
                            child: Text(
                              admin.customer.email,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    left: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Color(0xff4A5459),
                          border: Border.all(
                            width: 0.6,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      "Register de commerce: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      admin.customer.commRegister,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      "N.I.F: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      admin.customer.nif,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      "N.I.S: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      admin.customer.nis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      "Article: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      admin.customer.articleNo,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: FittedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Utilisateur depuis: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                "${ConvertHelper.convertDateFromString(admin.customer.createdAt)} à ${ConvertHelper.convertTimeFromString(admin.customer.createdAt)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Bloquer / Débloquer",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Switch(
                                  value: checkStatus(status),
                                  onChanged: (value) async {
                                    setState(() {
                                      isSwitched = value;
                                      if (isSwitched == true) {
                                        status = "blocked";
                                      } else {
                                        status = "actif";
                                      }
                                    });
                                    try {
                                      await Provider.of<Admin>(context,
                                              listen: false)
                                          .changeClientStatus(widget.id, status)
                                          .then((value) {
                                        if (!value) {
                                          setState(() {
                                            isSwitched = !isSwitched;
                                            if (isSwitched == true) {
                                              status = "blocked";
                                            } else {
                                              status = "actif";
                                            }
                                          });
                                          ErrorToast.showToast(
                                              message:
                                                  'Une erreur est survenue. Veuillez réessayer.');
                                        }
                                      });
                                    } on SocketException catch (e) {
                                      final err =
                                          ErrorHandler.err(e.toString());
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ErrorDialog(
                                                err['errorMessage'],
                                                err['buttonTxt']);
                                          });
                                    } catch (error) {
                                      if (error
                                          .toString()
                                          .contains('time_out_err')) {
                                        ErrorToast.showToast();
                                      } else {
                                        final err =
                                            ErrorHandler.err(error.toString());
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ErrorDialog(
                                                  err['errorMessage'],
                                                  err['buttonTxt']);
                                            });
                                      }
                                    }
                                  },
                                  activeTrackColor:
                                      Color(0xff882546).withOpacity(0.7),
                                  activeColor: Color(0xff882546),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [ProgressButtonManager(widget.id)],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
