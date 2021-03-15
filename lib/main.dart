import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './src/splash/splash_scren.dart';
import './routes.dart';
import './src/theme.dart';
import './provider/user_data.dart';
import './provider/species.dart';
import './provider/session.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => User(),
        ),
        ChangeNotifierProvider(
          create: (_) => Session(),
        ),
        ChangeNotifierProvider(
          create: (_) => Species(),
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
