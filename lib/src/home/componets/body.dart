import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'menu.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            //HomeMenu(),
          ],
        ),
      ),
    );
  }
}
