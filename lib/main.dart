import 'package:firulapp/provider/breeds.dart';
import 'package:firulapp/provider/pets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './provider/city.dart';
import './provider/session.dart';
import './src/theme.dart';
import './provider/user.dart';
import './routes.dart';
import './provider/species.dart';
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
        ChangeNotifierProvider(
          create: (_) => City(),
        ),
        ChangeNotifierProxyProvider<Session, User>(
          update: (context, session, user) => User(
            user == null ? {} : user.userData,
            session.userSession,
          ),
          create: (ctx) => User(
            UserData(),
            UserSession(),
          ),
        ),
        ChangeNotifierProxyProvider<User, Pets>(
          update: (context, user, pet) => Pets(
            user,
            pet == null ? {} : pet.userData,
          ),
          create: (ctx) => Pets(
            User(
              UserData(),
              UserSession(),
            ),
            PetItem(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Species(),
        ),
        ChangeNotifierProvider(
          create: (_) => Breeds(),
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
