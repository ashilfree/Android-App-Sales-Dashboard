import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/admin.dart';
import '../../providers/auth.dart';
import '../../widgets/Admin_Sprint/client_management.dart';
import '../../widgets/errorDialog.dart';

class ManagementAdminScreen extends StatelessWidget {
  static const routeName = '/management-admin';

  Future<void> _refreshProducts({BuildContext context}) async {
    try {
      await Provider.of<Admin>(context, listen: false).fetchAndSetCustomerById(
          Provider.of<Auth>(context).selectedCustomerId);
    } on SocketException catch (e) {
      final err = ErrorHandler.err(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(err['errorMessage'], err['buttonTxt']);
          });
    } catch (error) {
      if (error.toString().contains('time_out_err')) {
        ErrorToast.showToast();
      } else {
        final err = ErrorHandler.err(error.toString());
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(err['errorMessage'], err['buttonTxt']);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder(
        future: _refreshProducts(context: context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ClientManagement(args["id"], args["status"]),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }
}
