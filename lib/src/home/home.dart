import 'package:after_layout/after_layout.dart';
import 'package:firulapp/size_config.dart';
import 'package:firulapp/src/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/session.dart';
import '../../provider/user.dart';
import 'componets/body.dart';
import 'componets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  @override
  void afterFirstLayout(BuildContext context) {
    _check();
  }

  _check() async {
    setState(() {
      _isLoading = true;
    });
    final session = Provider.of<Session>(context, listen: false);
    await session.getSession();
    if (session.isAuth) {
      await Provider.of<User>(context, listen: false).getUser();
    } else {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ],
            ),
            endDrawer: HomeDrawer());
  }
}
