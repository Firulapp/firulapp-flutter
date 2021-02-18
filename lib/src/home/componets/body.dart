import 'package:firulapp/src/home/componets/home_buttons.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
// import 'categories.dart';
// import 'discount_banner.dart';
// import 'home_header.dart';
// import 'popular_product.dart';
// import 'special_offers.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: homeButtons(),
        ),
      ),
    );
  }
}
