import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../helper/style.dart';
import '../../providers/admin.dart';
import 'item_slidable.dart';

class SlideList extends StatefulWidget {
  final double size;
  final Function fn;
  final BuildContext ctx;

  SlideList(this.fn, this.size, this.ctx);

  @override
  _SlideListState createState() => _SlideListState();
}

class _SlideListState extends State<SlideList> {
  bool closeTopContainer = false;
  double topContainer = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      double value = scrollController.offset / 168.1;

      setState(() {
        topContainer = value;
        closeTopContainer = scrollController.offset > 50;
      });
    });
    fab = FloatingActionButton(
      onPressed: () {
        scrollController.animateTo(
          0.0,
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
        );
      },
      child: Icon(Icons.arrow_upward),
      backgroundColor: aqsMaroonColor,
    );
    // fab = IconButton(
    //   icon: Icon(
    //     Icons.arrow_upward,
    //     color: Colors.white,
    //   ),
    //   onPressed: () {
    //     scrollController.animateTo(
    //       0.0,
    //       curve: Curves.ease,
    //       duration: Duration(milliseconds: 500),
    //     );
    //   },
    // );

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if ((scrollMark - scrollController.position.pixels) > 50.0) {
          setState(() {
            reversing = true;
          });
        }
      } else {
        scrollMark = scrollController.position.pixels;
        setState(() {
          reversing = false;
        });
      }
    });
    super.initState();
  }

  ScrollController scrollController;
  bool reversing = false;
  double scrollMark;
  Widget fab;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      child: Stack(children: [
          Consumer<Admin>(
      builder: (ctx, admin, _) => admin.customers.length <= 0
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Aucune résultat',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).errorColor,
                  fontFamily: 'OpenSans',
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: widget.fn,
              )
            ],
          )
          : Container(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (ctx, i) {
                  return ItemSlidable(admin.customers[i], widget.fn, context);
                },
                itemCount: admin.customers.length,
              ),
            ),
          ),
          if (reversing && scrollController.position.pixels > 0.0)
      Positioned(
        bottom: 10,
        right: 15,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: aqsMaroonColor),
          child: fab,
        ),
      ),
        ]),
    );
  }
}
