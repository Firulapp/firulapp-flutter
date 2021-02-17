import 'package:flutter/widgets.dart';
import 'package:firulapp/src/home/home.dart';

// We use name route
// All our routes will be available here

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  // SplashScreen.routeName: (context) => SplashScreen(),
  // SignInScreen.routeName: (context) => SignInScreen(),
  // ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  // LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  // SignUpScreen.routeName: (context) => SignUpScreen(),
  // CompleteProfisleScreen.routeName: (context) => CompleteProfileScreen(),
  // OtpScreen.routeName: (context) => OtpScreen(),
  // DetailsScreen.routeName: (context) => DetailsScreen(),
  // CartScreen.routeName: (context) => CartScreen(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
};
