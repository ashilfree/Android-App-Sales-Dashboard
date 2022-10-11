import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'helper/style.dart';
import 'providers/admin.dart';
import 'providers/auth.dart';
import 'providers/collection.dart';
import 'providers/deliveries.dart';
import 'providers/invoice.dart';
import 'providers/invoices.dart';
import 'providers/order.dart';
import 'providers/orders.dart';
import 'providers/quantity.dart';
import 'providers/remainder_orders.dart';
import 'providers/sold.dart';
import 'providers/ticket.dart';
import 'providers/turnover.dart';
import 'screens/Admin_Sprint/admin_screen.dart';
import 'screens/Admin_Sprint/invoices_list.dart';
import 'screens/Admin_Sprint/manage_admin_screen.dart';
import 'screens/Admin_Sprint/orders_list.dart';
import 'screens/Admin_Sprint/sold_screen.dart';
import 'screens/Admin_Sprint/ticket_screen.dart';
import 'screens/aqs_splash_screen.dart';
import 'screens/services_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Admin>(
          update: (ctx, auth, _) =>
              Admin(auth.userId, auth.token, auth.createdAt),
        ),
        ChangeNotifierProxyProvider<Auth, Invoices>(
          update: (ctx, auth, _) => Invoices(
              auth.userId, auth.selectedCustomerId, auth.token, auth.createdAt),
        ),
        ChangeNotifierProxyProvider<Auth, Invoice>(
          update: (ctx, auth, _) =>
              Invoice(auth.selectedCustomerId, auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, _) => Orders(
              auth.userId, auth.selectedCustomerId, auth.token, auth.createdAt),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (ctx, auth, _) => Order(auth.selectedCustomerId, auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Sold>(
          update: (ctx, auth, _) => Sold(
              auth.userId, auth.selectedCustomerId, auth.token, auth.createdAt),
        ),
        ChangeNotifierProxyProvider<Auth, Ticket>(
          update: (ctx, auth, _) => Ticket(auth.selectedCustomerId, auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Deliveries>(
          update: (ctx, auth, _) =>
              Deliveries(auth.userId, auth.token, auth.createdAt),
        ),
        ChangeNotifierProxyProvider<Auth, Turnover>(
          update: (ctx, auth, _) =>
              Turnover(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Collection>(
          update: (ctx, auth, _) =>
              Collection(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Quantity>(
          update: (ctx, auth, _) =>
              Quantity(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, RemainderOrder>(
          update: (ctx, auth, _) =>
              RemainderOrder(auth.token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (key, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AQS Client Space',
          theme: ThemeData(
            primarySwatch: maroonAqs,
            accentColor: greenAqs,
            errorColor: grayAqs,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routes: {
            '/': (_) => auth.isAuth
                ? auth.status == Status.ADMIN
                    ? AdminScreen()
                    : ServicesScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AqsSplashScreen()),
            ServicesScreen.routeName: (_) => ServicesScreen(),
            InvoicesList.routeName: (_) => InvoicesList(),
            OrdersList.routeName: (_) => OrdersList(),
            SoldScreen.routeName: (_) => SoldScreen(),
            TicketScreen.routeName: (_) => TicketScreen(),
            AdminScreen.routeName: (_) => AdminScreen(),
            ManagementAdminScreen.routeName: (_) => ManagementAdminScreen(),
          },
        ),
      ),
    );
  }
}
