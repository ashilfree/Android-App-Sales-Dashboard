import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgetAdminPassword extends StatelessWidget {
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print(' could not launch $command');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Theme.of(context).primaryColor,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: Stack(
                  alignment: Alignment.topCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              new AutoSizeText(
                                'Mot de passe oublié ?',
                                maxLines: 1,
                                maxFontSize: 19,
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xff070707),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              new AutoSizeText(
                                'Pour récupérer votre mot de passe, merci de contacter le Département Base de Données & Développement.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff070707),
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // FlatButton(
                              //   textColor: Theme.of(context).accentColor,
                              //   onPressed: () {
                              //     customLaunch(
                              //         'mailto:local.sales@aqs.dz?subject=Récupération de mot de passe');
                              //   },
                              //   child: AutoSizeText(
                              //     "local.sales@aqs.dz",
                              //     maxFontSize: 16.0,
                              //     style: TextStyle(
                              //       fontSize: 16.0,
                              //       fontFamily: 'OpenSans',
                              //       fontWeight: FontWeight.w600,
                              //       decoration: TextDecoration.underline,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
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
            });
      },
      child: Text(
        "Mot de passe oublié ?",
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
