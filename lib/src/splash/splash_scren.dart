import 'package:firulapp/src/home/home.dart';
import 'package:firulapp/src/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = "/splash";
  final bool isAuth;
  SplashScreen(this.isAuth);

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    if (isAuth) {
      return HomeScreen();
    } else {
      return SignInScreen();
    }
  }
}
