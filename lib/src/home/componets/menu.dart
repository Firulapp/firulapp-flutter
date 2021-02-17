import 'package:flutter/material.dart';
// import 'package:shop_app/screens/cart/cart_screen.dart';

import '../../../size_config.dart';
// import 'icon_btn_with_counter.dart';
// import 'search_field.dart';

class HomeMenu extends StatefulWidget {
  HomeMenu({Key key}) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RaisedButton(onPressed: null),
        ],
      ),
    );
  }
}
