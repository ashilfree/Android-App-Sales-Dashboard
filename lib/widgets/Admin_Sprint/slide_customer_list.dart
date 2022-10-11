import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../models/error_handler.dart';
import '../../models/error_toast.dart';
import '../../providers/admin.dart';
import '../../widgets/Admin_Sprint/Slide_list.dart';
import '../errorDialog.dart';

class SlideCustomerList extends StatefulWidget {
  final double size;

  SlideCustomerList(this.size);

  @override
  _SlideCustomerListState createState() => _SlideCustomerListState();
}

class _SlideCustomerListState extends State<SlideCustomerList> {
  SlidableController slidableController;

  @protected
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
  }

  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;
  ScrollController scrollController;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  Future<bool> _refreshCustomerList({BuildContext context}) async {
    try {
      await Provider.of<Admin>(context, listen: false)
          .fetchAndSetCustomerList();
      return false;
    } on SocketException catch (e) {
      final err = ErrorHandler.err(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(err['errorMessage'], err['buttonTxt']);
          });
      return true;
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
      return true;
    }
  }

  void restart() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshCustomerList(context: context),
      builder: (ctx, snapShot) =>
          snapShot.connectionState == ConnectionState.waiting
              ? Container(
                  height: widget.size,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SlideList(restart, widget.size, context),
    );
  }
}
