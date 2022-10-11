import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../helper/style.dart';
import '../../providers/admin.dart';
import '../../providers/auth.dart';
import '../../screens/Admin_Sprint/manage_admin_screen.dart';
import '../../screens/services_screen.dart';

class ItemSlidable extends StatelessWidget {
  final Customer customer;
  final Function refreshFn;
  final BuildContext ctx;

  ItemSlidable(this.customer, this.refreshFn, this.ctx);

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<Admin>(context).search;
    if (search.isEmpty) {
      return LayoutBuilder(builder: (context, constraints) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: customer.appUser
                    ? aqsGreenColor
                    : aqsGreenColor.withOpacity(0.7),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                    border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset("assets/images/client_avatar.png"),
                  ),
                ),
                title: Text(
                  customer.denomination,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Container(
                      width: constraints.maxWidth * 0.35,
                      child: AutoSizeText(
                        customer.appUser
                            ? customer.getStatus == "actif"
                                ? "Actif"
                                : customer.getStatus
                            : 'N\'est pas un utilisateur',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        maxFontSize: 14,
                      ),
                    ),
                  ],
                ),
                trailing: customer.appUser &&
                        customer.getStatus != "En instance"
                    ? Icon(Icons.swap_horiz, color: Colors.white, size: 30.0)
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Icon(Icons.arrow_forward,
                            color: Colors.white, size: 25.0),
                      ),
              ),
            ),
          ),
          actions: <Widget>[
            if (customer.appUser &&
                (customer.getStatus == "actif" ||
                    customer.getStatus == "Bloqué"))
              IconSlideAction(
                caption: 'Gérer',
                color: aqsGrayColor,
                icon: Icons.settings,
                onTap: () {
                  Provider.of<Auth>(context, listen: false)
                      .setCustomerId(customer.id);
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
                            curve: Curves.decelerate,
                          );
                          return FadeTransition(
                            //alignment: Alignment.bottomCenter,
                            //scale: animation,
                            child: child,
                            opacity: animation,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return ManagementAdminScreen();
                        },
                        settings: RouteSettings(arguments: {
                          "id": customer.id,
                          "status": customer.getStatus
                        })),
                  ).then((value) => refreshFn(context: ctx));
                },
              ),
          ],
          secondaryActions: <Widget>[
            // IconSlideAction(
            //   caption: 'Plus',
            //   color: aqsGrayColor,
            //   icon: Icons.more_horiz,
            //   onTap: () => null,
            // ),
            IconSlideAction(
              caption: 'Consulter',
              color: aqsMaroonColor,
              icon: Icons.search,
              onTap: () {
                Provider.of<Auth>(context, listen: false)
                    .setCustomerId(customer.id);
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
                          curve: Curves.decelerate,
                        );
                        return FadeTransition(
                          //alignment: Alignment.bottomCenter,
                          //scale: animation,
                          child: child,
                          opacity: animation,
                        );
                      },
                      pageBuilder: (context, animation, animationTime) {
                        return ServicesScreen();
                      },
                      settings:
                          RouteSettings(arguments: customer.denomination)),
                );
              },
            ),
          ],
        );
      });
    } else {
      if (customer.denomination.toLowerCase().contains(search)) {
        return LayoutBuilder(builder: (context, constraints) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: customer.appUser
                      ? aqsGreenColor
                      : aqsGreenColor.withOpacity(0.7),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset("assets/images/client_avatar.png"),
                    ),
                  ),
                  title: Text(
                    customer.denomination,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: Row(
                    children: <Widget>[
                      Container(
                        width: constraints.maxWidth * 0.35,
                        child: AutoSizeText(
                          customer.appUser
                              ? customer.getStatus == "actif"
                                  ? "Actif"
                                  : customer.getStatus
                              : 'N\'est pas un utilisateur',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: customer.appUser &&
                          customer.getStatus != "En instance"
                      ? Icon(Icons.swap_horiz, color: Colors.white, size: 30.0)
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(Icons.arrow_forward,
                              color: Colors.white, size: 25.0),
                        ),
                ),
              ),
            ),
            actions: <Widget>[
              if (customer.appUser &&
                  (customer.getStatus == "actif" ||
                      customer.getStatus == "Bloqué"))
                IconSlideAction(
                  caption: 'Gérer',
                  color: aqsGrayColor,
                  icon: Icons.settings,
                  onTap: () {
                    Provider.of<Auth>(context, listen: false)
                        .setCustomerId(customer.id);
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
                              curve: Curves.decelerate,
                            );
                            return FadeTransition(
                              //alignment: Alignment.bottomCenter,
                              //scale: animation,
                              child: child,
                              opacity: animation,
                            );
                          },
                          pageBuilder: (context, animation, animationTime) {
                            return ManagementAdminScreen();
                          },
                          settings: RouteSettings(arguments: {
                            "id": customer.id,
                            "status": customer.getStatus
                          })),
                    ).then((value) => refreshFn(context: ctx));
                  },
                ),
            ],
            secondaryActions: <Widget>[
              // IconSlideAction(
              //   caption: 'Plus',
              //   color: aqsGrayColor,
              //   icon: Icons.more_horiz,
              //   onTap: () => null,
              // ),
              IconSlideAction(
                caption: 'Consulter',
                color: aqsMaroonColor,
                icon: Icons.search,
                onTap: () {
                  Provider.of<Auth>(context, listen: false)
                      .setCustomerId(customer.id);
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
                          curve: Curves.decelerate,
                        );
                        return FadeTransition(
                          //alignment: Alignment.bottomCenter,
                          //scale: animation,
                          child: child,
                          opacity: animation,
                        );
                      },
                      pageBuilder: (context, animation, animationTime) {
                        return ServicesScreen();
                      },
                      settings: RouteSettings(arguments: customer.denomination),
                    ),
                  );
                },
              ),
            ],
          );
        });
      } else {
        return Container();
      }
    }
  }
}
