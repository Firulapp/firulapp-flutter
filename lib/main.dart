import 'package:firulapp/provider/session.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './src/splash/splash_scren.dart';
import './routes.dart';
import './src/theme.dart';
import 'provider/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<Session, User>(
          update: (context, session, user) => User(
            session.userSession,
            user == null ? {} : user.userData,
          ),
          create: (_) => User(null, null),
        ),
        ChangeNotifierProvider(
          create: (_) => Session(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firulapp',
        theme: theme(),
        // home: SplashScreen(),
        // We use routeName so that we dont need to remember the name
        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }
}
