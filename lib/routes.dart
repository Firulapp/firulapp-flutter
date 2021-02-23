import './src/sign_in/sign_in_screen.dart';
import 'package:flutter/widgets.dart';
import './src/home/home.dart';
import './src/profile/profile_screen.dart';

// We use name route
// All our routes will be available here

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
