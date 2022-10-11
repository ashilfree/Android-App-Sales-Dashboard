import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/style.dart';
import '../../providers/auth.dart';
import '../../widgets/Admin_Sprint/body_admin.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/logout_confirmation.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = '/admin';
  @override
  Widget build(BuildContext context) {
        double size = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - buildAppBar(context).preferredSize.height ;
    return Scaffold(
      appBar: buildAppBar(context),
      body: BodyAdmin(size: size),
      drawer: AppDrawer(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: aqsMaroonColor,
      title: Text('Dashboard'),
      actions: [
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
    );
  }
}
