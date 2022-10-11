import 'package:flutter/material.dart';

import '../Admin_Sprint/slide_customer_list.dart';
import 'header_with_searchbox.dart';

class BodyAdmin extends StatelessWidget {
  double size;
  BodyAdmin({this.size});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderWithSearchBox(size: size * 0.2),
          SizedBox(
            height: 10,
          ),
          SlideCustomerList((size * 0.79) - 10),
        ],
      ),
    );
  }
}
