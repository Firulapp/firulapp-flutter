import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';

import '../../provider/user.dart';
import '../../provider/session.dart';
import '../home/home.dart';
import '../sign_in/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  static const routeName = "/splash";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {
    _check();
  }

  _check() async {
    final session = Provider.of<Session>(context, listen: false);
    await session.getSession();
    if (session.isAuth) {
      await Provider.of<User>(context, listen: false).getUser();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
