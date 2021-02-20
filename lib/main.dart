import 'package:firulapp/routes.dart';
//import 'package:firulapp/src/home/home.dart';
import 'package:firulapp/src/sign_in/sign_in_screen.dart';
import 'package:firulapp/src/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firulapp',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: SignInScreen.routeName,
      routes: routes,
    );
  }
}
