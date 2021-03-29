import 'package:flutter/material.dart';

import 'home_buttons.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: HomeButtons(),
      ),
    );
  }
}
