import 'package:firulapp/provider/session.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './src/theme.dart';
import 'provider/user.dart';
import 'src/home/home.dart';
import 'src/pets/pets_scream.dart';
import 'src/profile/profile_screen.dart';
import 'src/profile_detail/profile_details.dart';
import 'src/sign_in/sign_in_screen.dart';
import 'src/sign_up/components/sign_up_details_form.dart';
import 'src/sign_up/sign_up_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Session(),
        ),
        ChangeNotifierProxyProvider<Session, User>(
          update: (context, session, user) => User(
            session.userSession,
            user == null ? {} : user.userData,
          ),
          create: (ctx) => User(
            UserSession(),
            UserData(),
          ),
        ),
      ],
      child: Consumer<Session>(builder: (ctx, session, child) {
        ifAuth(targetScreen) =>
            session.isAuth != null ? targetScreen : SignInScreen();
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Firulapp',
            theme: theme(),
            home: session.isAuth != null ? HomeScreen() : SignInScreen(),
            routes: {
              HomeScreen.routeName: (ctx) => ifAuth(HomeScreen()),
              SignInScreen.routeName: (ctx) => ifAuth(SignInScreen()),
              ProfileScreen.routeName: (ctx) => ifAuth(ProfileScreen()),
              ProfilePage.routeName: (ctx) => ifAuth(ProfilePage()),
              PetsScreen.routeName: (ctx) => ifAuth(PetsScreen()),
              SignUpScreen.routeName: (ctx) => SignUpScreen(),
              SignUpDetailsForm.routeName: (ctx) => SignUpDetailsForm(),
            });
      }),
    );
  }
}
