import 'package:firulapp/size_config.dart';
import 'package:flutter/material.dart';

import 'componets/body.dart';
import 'componets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Body(),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              //Permite customizar icon de Boton endDrawer
              icon: Icon(Icons.menu_open, color: Colors.black),
              onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: HomeDrawer(),
    );
  }
}
