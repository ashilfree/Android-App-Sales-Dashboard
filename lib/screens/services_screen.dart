import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../providers/auth.dart';
import '../providers/collection.dart';
import '../providers/deliveries.dart';
import '../providers/invoices.dart';
import '../providers/orders.dart';
import '../providers/quantity.dart';
import '../providers/sold.dart';
import '../providers/turnover.dart';
import '../screens/Client_Sprint/delivery_status_screen.dart';
import '../screens/Client_Sprint/order_status_screen.dart';
import '../screens/Client_Sprint/payment_status_screen.dart';
import '../screens/Client_Sprint/wallet_screen.dart';
import '../screens/Super_Admin_Sprint/collection_screen.dart';
import '../screens/Super_Admin_Sprint/quantity_screen.dart';
import '../screens/Super_Admin_Sprint/remainder_orders_screen.dart';
import '../screens/Super_Admin_Sprint/turnover_screen.dart';
import '../widgets/about_app.dart';
import '../widgets/app_drawer.dart';
import '../widgets/logout_confirmation.dart';
import 'Admin_Sprint/invoices_list.dart';
import 'Admin_Sprint/orders_list.dart';
import 'Admin_Sprint/sold_screen.dart';
import 'Admin_Sprint/ticket_screen.dart';
import 'Client_Sprint/billing_status_screen.dart';

class ServicesScreen extends StatefulWidget {
  static const routeName = '/services';

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    Timer(
      Duration(milliseconds: 200),
      () => _animationController.forward(),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    var denomination;
    if (auth.status == Status.ADMIN)
      denomination = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 1,
          title:
              (auth.status == Status.USER || auth.status == Status.SUPERADMIN)
                  ? Center(
                      child: Text('Accueil'),
                    )
                  : Transform(
                      transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                      child: AutoSizeText(
                        denomination,
                        style: TextStyle(fontSize: 16),
                        maxLines: 1,
                        maxFontSize: 18,
                      ),
                    ),
          actions: <Widget>[
            if (auth.status == Status.USER || auth.status == Status.SUPERADMIN)
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => LogoutConfirmation(),
                    barrierDismissible: true,
                  ).then((value) {
                    if (value) {
                      Navigator.of(context).pushReplacementNamed('/');
                      Provider.of<Auth>(context, listen: false).logout();
                    }
                  });
                },
              )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AqsScreen(animationController: _animationController),
            ),
          ],
        ),
        drawer: (auth.status == Status.USER || auth.status == Status.SUPERADMIN)
            ? AppDrawer()
            : null,
      );
  }
}

void customLaunch(command) async {
  if (await canLaunch(command)) {
    await launch(command);
  } else {
    print(' could not launch $command');
  }
}

class AqsScreen extends StatelessWidget {
  final AnimationController animationController;
  AqsScreen({
    @required this.animationController,
  });
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Column(
      children: <Widget>[
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -1),
            end: Offset.zero,
          ).animate(animationController),
          child: FadeTransition(
            opacity: animationController,
            child: Container(
              decoration: BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20.0,
                ),
                child: Container(
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top) *
                      0.15,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Logo_AQS_3.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Flexible(
            //padding: EdgeInsets.all(30),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
                if (auth.status == Status.SUPERADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1, -1),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "CA",
                        icon: ImageIcon(
                          AssetImage('assets/images/ca.png'),
                          size: 75,
                          color: Colors.white,
                        ),
                        col: Colors.brown,
                        onTapFunction: () {
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
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return TurnoverScreen();
                                }),
                          ).then((value) => Provider.of<Turnover>(context, listen: false).resetDate());
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.SUPERADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, -1),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Quanité",
                        icon: ImageIcon(
                          AssetImage('assets/images/quantity.png'),
                          size: 75,
                          color: Colors.white,
                        ),
                        col: Colors.brown,
                        onTapFunction: () {
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
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return QuantityScreen();
                                }),
                          ).then((value) => Provider.of<Quantity>(context, listen: false).resetDate());
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.SUPERADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Encaissement",
                        icon: ImageIcon(
                            AssetImage('assets/images/encaissement.png'),
                            size: 75,
                            color: Colors.white),
                        col: Colors.brown,
                        onTapFunction: () {
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
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return CollectionScreen();
                                }),
                          ).then((value) => Provider.of<Collection>(context, listen: false).resetDate());
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.SUPERADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Reliquat",
                        icon: ImageIcon(
                          AssetImage('assets/images/reliquat.png'),
                          size: 75,
                          color: Colors.white,
                        ),
                        col: Colors.yellow,
                        onTapFunction: () {
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
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return RemainderOrdersScreen();
                                }),
                          );
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.ADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1, -1),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Facture",
                        icon: ImageIcon(
                          AssetImage('assets/images/facture.png'),
                          size: 75,
                          color: Colors.greenAccent[200],
                        ),
                        col: Colors.brown,
                        onTapFunction: () {
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
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return InvoicesList();
                                }),
                          );
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.ADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, -1),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Commande",
                        icon: ImageIcon(
                          AssetImage('assets/images/order.png'),
                          size: 75,
                          color: Colors.white,
                        ),
                        col: Colors.brown,
                        onTapFunction: () {
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
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return OrdersList();
                                }),
                          );
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.ADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Ticket",
                        icon: ImageIcon(
                          AssetImage('assets/images/ticket.png'),
                          size: 75,
                          color: Colors.green[200],
                        ),
                        col: Colors.brown,
                        onTapFunction: () {
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
                                    //alignment: Alignment.bottomCenter,
                                    //scale: animation,
                                    child: child,
                                    opacity: animation,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return TicketScreen();
                                }),
                          );
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.ADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Solde",
                        icon: ImageIcon(
                          AssetImage('assets/images/sold.png'),
                          size: 75,
                          color: Colors.amber,
                        ),
                        col: Colors.yellow,
                        onTapFunction: () {
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
                                    //alignment: Alignment.bottomCenter,
                                    //scale: animation,
                                    child: child,
                                    opacity: animation,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return SoldScreen();
                                }),
                          );
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.USER)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, -1),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Commandes",
                        icon: ImageIcon(
                          AssetImage('assets/images/order.png'),
                          size: 75,
                          color: Colors.lightGreen[100],
                        ),
                        col: Colors.brown,
                        onTapFunction: () {
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
                                    //alignment: Alignment.bottomCenter,
                                    //scale: animation,
                                    child: child,
                                    opacity: animation,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return OrderStatusScreen();
                                }),
                          ).then((_) => {
                                Provider.of<Orders>(context, listen: false)
                                    .resetDate()
                              });
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.USER)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1, -1),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Facturation",
                        icon: ImageIcon(
                          AssetImage('assets/images/facture.png'),
                          size: 75,
                          color: Colors.white.withOpacity(.9),
                        ),
                        col: Colors.brown,
                        onTapFunction: () {
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
                                    //alignment: Alignment.bottomCenter,
                                    //scale: animation,
                                    child: child,
                                    opacity: animation,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return BillingStatusScreen();
                                }),
                          ).then((_) => {
                                Provider.of<Invoices>(context, listen: false)
                                    .resetDate()
                              });
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.USER)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Livraison",
                        icon: ImageIcon(
                          AssetImage('assets/images/delivery.png'),
                          size: 75,
                          color: Colors.black.withOpacity(.55),
                        ),
                        col: Colors.brown,
                        onTapFunction: () {
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
                                    //alignment: Alignment.bottomCenter,
                                    //scale: animation,
                                    child: child,
                                    opacity: animation,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return DeliveryStatusScreen();
                                }),
                          ).then((_) => {
                                Provider.of<Deliveries>(context, listen: false)
                                    .resetDate()
                              });
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.USER)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Paiement",
                        icon: ImageIcon(
                          AssetImage('assets/images/sold.png'),
                          size: 75,
                          color: Colors.amber[300],
                        ),
                        col: Colors.yellow,
                        onTapFunction: () {
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
                                    //alignment: Alignment.bottomCenter,
                                    //scale: animation,
                                    child: child,
                                    opacity: animation,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return PaymentStatusScreen();
                                }),
                          ).then((_) => {
                                Provider.of<Sold>(context, listen: false)
                                    .resetDate()
                              });
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.USER)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Solde",
                        icon: ImageIcon(
                          AssetImage('assets/images/wallet_icon.png'),
                          size: 75,
                          color: Colors.blueGrey[900],
                        ),
                        col: Colors.yellow,
                        onTapFunction: () {
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
                                    //alignment: Alignment.bottomCenter,
                                    //scale: animation,
                                    child: child,
                                    opacity: animation,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return WalletScreen();
                                }),
                          );
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.ADMIN ||
                    auth.status == Status.SUPERADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "A Propos",
                        icon: ImageIcon(
                          AssetImage('assets/images/aboutus.png'),
                          size: 75,
                          color: Colors.white,
                        ),
                        col: Colors.yellow,
                        onTapFunction: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AboutApp();
                              });
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.ADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Retour",
                        icon: ImageIcon(
                          AssetImage('assets/images/return.png'),
                          size: 75,
                          color: Colors.red[400],
                        ),
                        col: Colors.yellow,
                        onTapFunction: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                if (auth.status == Status.USER ||
                    auth.status == Status.SUPERADMIN)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: FadeTransition(
                      opacity: animationController,
                      child: AqsMenu(
                        title: "Déconnecter",
                        icon: ImageIcon(
                          AssetImage('assets/images/logout.png'),
                          size: 75,
                          color: Colors.red[400],
                        ),
                        col: Colors.yellow,
                        onTapFunction: () {
                          showDialog(
                            context: context,
                            builder: (_) => LogoutConfirmation(),
                            barrierDismissible: true,
                          ).then((value) {
                            if (value) {
                              Navigator.of(context).pushReplacementNamed('/');
                              Provider.of<Auth>(context, listen: false)
                                  .logout();
                            }
                          });
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AqsMenu extends StatelessWidget {
  AqsMenu({this.title, this.icon, this.col, this.onTapFunction});
  final String title;
  final ImageIcon icon;
  final MaterialColor col;
  final Function onTapFunction;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal,
      elevation: 1,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: onTapFunction,
        splashColor: Theme.of(context).accentColor.withOpacity(1),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(7),
                child: icon,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 3,
                ),
                child: Text(
                  title,
                  style: new TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
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
