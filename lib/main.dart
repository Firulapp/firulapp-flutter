import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './provider/session.dart';
import './src/theme.dart';
import './provider/user.dart';
import './routes.dart';
import 'src/home/home.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firulapp',
        theme: theme(),
        initialRoute: HomeScreen.routeName,
        routes: routes,
      ),
    );
  }
}
