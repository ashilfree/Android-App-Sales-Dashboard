import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/style.dart';
import '../../providers/admin.dart';

class HeaderWithSearchBox extends StatefulWidget {
  HeaderWithSearchBox({
    Key key,
    @required this.size,
  }) : super(key: key);

  final double size;

  @override
  _HeaderWithSearchBoxState createState() => _HeaderWithSearchBoxState();
}

class _HeaderWithSearchBoxState extends State<HeaderWithSearchBox>{
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: aqsDefaultPadding * 1.5),
      height: widget.size,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: aqsDefaultPadding,
                right: aqsDefaultPadding,
                bottom: 15 + aqsDefaultPadding),
            height: widget.size - 27,
            decoration: BoxDecoration(
              color: aqsMaroonColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Row(
              children: [
                // Text(
                //   "BONJOUR ${Provider.of<Auth>(context).denomination}",
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 18,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                /*Spacer(),
                Image.asset("assets/images/small_logo.png"),*/
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: aqsDefaultPadding),
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: aqsMaroonColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        Provider.of<Admin>(context, listen: false)
                            .setSearch(value);
                        setState(() {

                        });
                      },
                      style: TextStyle(color: aqsGrayColor, fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15),
                          hintText: "Chercher",
                          hintStyle:
                              TextStyle(color: aqsGrayColor, fontSize: 14),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                      controller: _controller,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _controller.text == ''?
                      Icons.search:Icons.clear,
                      size: 30,
                      color: aqsGrayColor,
                    ),
                    onPressed: () {
                      setState(() {
                      _controller.text = '';
                      });
                      Provider.of<Admin>(context, listen: false).setSearch('');
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
