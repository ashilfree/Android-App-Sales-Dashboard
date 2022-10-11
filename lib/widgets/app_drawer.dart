import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/error_handler.dart';
import '../models/error_toast.dart';
import '../providers/auth.dart';
import '../screens/Client_Sprint/billing_status_screen.dart';
import '../screens/Client_Sprint/delivery_status_screen.dart';
import '../screens/Client_Sprint/order_status_screen.dart';
import '../screens/Client_Sprint/payment_status_screen.dart';
import '../screens/Client_Sprint/wallet_screen.dart';
import '../screens/Super_Admin_Sprint/collection_screen.dart';
import '../screens/Super_Admin_Sprint/quantity_screen.dart';
import '../screens/Super_Admin_Sprint/remainder_orders_screen.dart';
import '../screens/Super_Admin_Sprint/turnover_screen.dart';
import '../screens/services_screen.dart';
import '../widgets/about_app.dart';
import '../widgets/errorDialog.dart';
import 'logout_confirmation.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Veuillez patienter...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Row(
        children: <Widget>[
          CircularProgressIndicator(),
        ],
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
    );
    String getInitials(initword) {
      List<String> names = initword.split(" ");
      String initials = "";
      int numWords = 2;

      if (numWords < names.length) {
        numWords = names.length;
      }
      for (var i = 0; i < numWords; i++) {
        initials += '${names[i][0]}';
      }
      return initials;
    }

    return SafeArea(
          child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: FittedBox(
                  child: new Text(
                    auth.denomination,
                    style: new TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              accountEmail: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: FittedBox(
                          child: new Text(
                            auth.email,
                            style: new TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      if (auth.status == Status.USER)
                        IconButton(
                          icon: Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more, color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                        ),
                    ],
                  ),
                  if (_expanded)
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 4,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('aa'),
                              Text('bb'),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black26,
                child: FittedBox(
                  child: Text(
                    //(auth.status == Status.USER)
                    //  ?
                    getInitials(auth.denomination)
                    //: 'DGA'
                    ,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              decoration: new BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
            ),
            if (auth.status != Status.ADMIN)
              ListTile(
                leading: Icon(
                  Icons.home,
                  size: 30,
                  color: Colors.black,
                ),
                title: Text('Accueil'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(
                          milliseconds: 200,
                        ),
                        transitionsBuilder:
                            (context, animation, animationTime, child) {
                          animation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          );
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return ServicesScreen();
                        }),
                  );
                },
              ),
            if (auth.status != Status.ADMIN) Divider(),
            if (auth.status != Status.ADMIN)
              ListTile(
                leading: ImageIcon(
                  AssetImage((auth.status == Status.USER)
                      ? 'assets/images/order.png'
                      : 'assets/images/ca.png'),
                  size: 30,
                  color: Colors.black,
                ),
                title: Text((auth.status == Status.USER)
                    ? 'Etat de commande'
                    : 'Chiffre d\'affaire'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(
                          milliseconds: 200,
                        ),
                        transitionsBuilder:
                            (context, animation, animationTime, child) {
                          animation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          );
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return (auth.status == Status.USER)
                              ? OrderStatusScreen()
                              : TurnoverScreen();
                        }),
                  );
                },
              ),
            if (auth.status != Status.ADMIN) Divider(),
            if (auth.status != Status.ADMIN)
              ListTile(
                leading: ImageIcon(
                  AssetImage((auth.status == Status.USER)
                      ? 'assets/images/facture.png'
                      : 'assets/images/quantity.png'),
                  size: 30,
                  color: Colors.black,
                ),
                title: Text((auth.status == Status.USER)
                    ? 'Etat de facturation'
                    : 'Quantité'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(
                          milliseconds: 200,
                        ),
                        transitionsBuilder:
                            (context, animation, animationTime, child) {
                          animation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          );
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return (auth.status == Status.USER)
                              ? BillingStatusScreen()
                              : QuantityScreen();
                        }),
                  );
                },
              ),
            if (auth.status != Status.ADMIN) Divider(),
            if (auth.status != Status.ADMIN)
              ListTile(
                leading: ImageIcon(
                  AssetImage((auth.status == Status.USER)
                      ? 'assets/images/delivery.png'
                      : 'assets/images/encaissement.png'),
                  size: 30,
                  color: Colors.black,
                ),
                title: Text((auth.status == Status.USER)
                    ? 'Etat de livraison'
                    : 'Encaissement'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(
                          milliseconds: 200,
                        ),
                        transitionsBuilder:
                            (context, animation, animationTime, child) {
                          animation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          );
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return (auth.status == Status.USER)
                              ? DeliveryStatusScreen()
                              : CollectionScreen();
                        }),
                  );
                },
              ),
            if (auth.status != Status.ADMIN) Divider(),
            if (auth.status != Status.ADMIN)
              ListTile(
                leading: ImageIcon(
                  AssetImage((auth.status == Status.USER)
                      ? 'assets/images/sold.png'
                      : 'assets/images/reliquat.png'),
                  size: 30,
                  color: Colors.black,
                ),
                title: Text((auth.status == Status.USER)
                    ? 'Etat de paiement'
                    : 'Reliquat'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(
                          milliseconds: 200,
                        ),
                        transitionsBuilder:
                            (context, animation, animationTime, child) {
                          animation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          );
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return (auth.status == Status.USER)
                              ? PaymentStatusScreen()
                              : RemainderOrdersScreen();
                        }),
                  );
                },
              ),
            if (auth.status != Status.ADMIN) Divider(),
            if (auth.status == Status.USER)
              ListTile(
                leading: ImageIcon(
                  AssetImage('assets/images/wallet_icon.png'),
                  size: 30,
                  color: Colors.black,
                ),
                title: Text('Solde'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(
                          milliseconds: 200,
                        ),
                        transitionsBuilder:
                            (context, animation, animationTime, child) {
                          animation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          );
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return WalletScreen();
                        }),
                  );
                },
              ),
            if (auth.status == Status.USER) Divider(),
            //if (auth.status == Status.USER)
            ListTile(
              leading: Icon(
                Icons.vpn_key,
                size: 30,
                color: Colors.black,
              ),
              title: Text('Modifier mot de passe'),
              onTap: () {
                pr.show().then((_) async {
                  try {
                    await Provider.of<Auth>(context, listen: false)
                        .resetPassword()
                        .then((value) async {
                      if (value) {
                        pr.hide();
                        await showDialog(
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
                                      height: 240,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(right: 15),
                                              child: Icon(
                                                Icons.check_circle_outline,
                                                color:
                                                    Theme.of(context).accentColor,
                                                size: 60,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 105,
                                              child: Column(
                                                children: <Widget>[
                                                  new AutoSizeText(
                                                    'Un lien de modification de mot de passe vous a été envoyé.',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff070707),
                                                      fontFamily: 'Quicksand',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    maxFontSize: 18,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  new AutoSizeText(
                                                    'Veuillez consulter votre boite email.',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff070707),
                                                      fontFamily: 'Quicksand',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    maxFontSize: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
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
                                              pr.hide();
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
                      } else {
                        pr.hide();
                        await showDialog(
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
                                      height: 280,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(right: 15),
                                              child: Icon(
                                                Icons.error_outline,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 60,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 150,
                                              child: Column(
                                                children: <Widget>[
                                                  new AutoSizeText(
                                                    'Un lien de modification de mot de passe a déjà été envoyé.',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff070707),
                                                      fontFamily: 'Quicksand',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    maxFontSize: 18,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  new AutoSizeText(
                                                    'Veuillez consulter votre boite email. Sinon, Veuillez réessayer plus tard.',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff070707),
                                                      fontFamily: 'Quicksand',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    maxFontSize: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
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
                                              pr.hide();
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
                      }
                    });
                  } on SocketException catch (e) {
                    final err = ErrorHandler.err(e.toString());
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorDialog(
                              err['errorMessage'], err['buttonTxt']);
                        });
                  } catch (error) {
                    if (error.toString().contains('time_out_err')) {
                      pr.hide();
                      ErrorToast.showToast();
                    } else {
                      final err = ErrorHandler.err(error.toString());
                      pr.hide();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorDialog(
                                err['errorMessage'], err['buttonTxt']);
                          });
                    }
                  }
                });
                // .then((_) {
                //   pr.hide();
                //   Navigator.of(context).pop();
                // });
              },
            ),
            //if (auth.status == Status.USER)
            Divider(),
            //if (auth.status == Status.USER)
            ListTile(
              leading: ImageIcon(
                AssetImage('assets/images/aboutus.png'),
                size: 30,
                color: Colors.black,
              ),
              title: Text('A Propos'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AboutApp();
                    });
              },
            ),
            //if (auth.status == Status.USER)
            Divider(),
            if (auth.status == Status.USER)
              ListTile(
                leading: ImageIcon(
                  AssetImage('assets/images/warning.png'),
                  size: 30,
                  color: Colors.black,
                ),
                title: Text('Signaler un problème'),
                onTap: () {
                  customLaunch('mailto:local.sales@aqs.dz?subject=Un problème');
                },
              ),
            if (auth.status == Status.USER) Divider(),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                size: 30,
                color: Colors.black,
              ),
              title: Text('Déconnecter'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => LogoutConfirmation(),
                  barrierDismissible: true,
                ).then((value) {
                  if (value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    Provider.of<Auth>(context, listen: false).logout();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
