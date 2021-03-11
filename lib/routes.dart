import 'package:flutter/widgets.dart';

import 'src/sign_in/sign_in_screen.dart';
import 'src/home/home.dart';
import 'src/profile/profile_screen.dart';
import 'src/profile_detail/profile_details.dart';
import 'src/pets/pets_scream.dart';
import 'src/sign_up/sign_up_screen.dart';
import 'src/splash/splash_scren.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  ProfilePage.routeName: (context) => ProfilePage(),
  PetsScreen.routeName: (context) => PetsScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SplashScreen.routeName: (context) => SplashScreen(),
};
