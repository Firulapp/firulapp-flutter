import 'package:firulapp/src/home/home.dart';
import 'package:firulapp/src/splash/splash_scren.dart';
import 'package:provider/provider.dart';
import './routes.dart';
import './src/theme.dart';
import 'package:flutter/material.dart';
import 'provider/super_user_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SuperUserData())],
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
