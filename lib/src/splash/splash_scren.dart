import 'package:after_layout/after_layout.dart';
import 'package:firulapp/src/home/home.dart';
import 'package:firulapp/src/sign_in/sign_in_screen.dart';
import 'package:firulapp/utils/auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  static String routeName = "/splash";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {
    _check();
  }

  _check() async {
    final session = await Auth.instance.getSession();
    if (session != null) {
      print("login before");
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
