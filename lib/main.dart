import 'package:firulapp/provider/activity.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './provider/agenda.dart';
import './provider/breeds.dart';
import './provider/pets.dart';
import './routes.dart';
import './src/theme.dart';
import './src/home/home.dart';
import './provider/user.dart';
import './provider/city.dart';
import './provider/session.dart';
import './provider/species.dart';
import './provider/medical_record.dart';
import './provider/vaccination_record.dart';

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
        ChangeNotifierProxyProvider<User, MedicalRecord>(
          update: (context, user, med) => MedicalRecord(
            user,
            med == null ? {} : med.items,
          ),
          create: (ctx) => MedicalRecord(
            User(
              UserData(),
              UserSession(),
            ),
            [],
          ),
        ),
        ChangeNotifierProxyProvider<User, VaccinationRecord>(
          update: (context, user, med) => VaccinationRecord(
            user,
            med == null ? {} : med.items,
          ),
          create: (ctx) => VaccinationRecord(
            User(
              UserData(),
              UserSession(),
            ),
            [],
          ),
        ),
        ChangeNotifierProxyProvider<User, Activity>(
          update: (context, user, act) => Activity(
            user,
            act == null ? {} : act.items,
          ),
          create: (ctx) => Activity(
            User(
              UserData(),
              UserSession(),
            ),
            [],
          ),
        ),
        ChangeNotifierProxyProvider<User, Agenda>(
          update: (context, user, agenda) => Agenda(
            user,
            agenda == null ? {} : agenda.items,
          ),
          create: (ctx) => Agenda(
            User(
              UserData(),
              UserSession(),
            ),
            [],
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
        theme: CustomTheme.theme(),
        initialRoute: HomeScreen.routeName,
        routes: Routes.routes,
      ),
    );
  }
}
