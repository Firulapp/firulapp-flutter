import 'package:firulapp/src/home/componets/home_buttons.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: HomeButtons(),
        ),
      ),
    );
  }
}
