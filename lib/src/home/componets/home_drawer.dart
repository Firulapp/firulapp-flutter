import 'package:firulapp/provider/session.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../profile/profile_screen.dart';
import '../../../provider/super_user_data.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({Key key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<SuperUserData>(context);
    final name = userData.name;
    final surname = userData.surname;

    return Drawer(
      elevation: 10.0,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("$name $surname"),
            accountEmail: Text(userData.mail),
            currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
              "assets/images/Profile Image.png",
            )),
            decoration: BoxDecoration(color: kSecondaryColor),
            //Lista de Otros Usuarios
            otherAccountsPictures: <Widget>[
              Image.network(
                'https://pbs.twimg.com/profile_images/983164640833261568/i2Px1IsE.jpg',
              ),
              Image.network(
                  'https://www.sodep.com.py/images/jazmin-villagra.png')
            ],
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Ver Perfil'),
            onTap: () {
              // This line code will close drawer programatically....
              Navigator.pop(context);
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
          ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar Sesion'),
            onTap: () =>
                Provider.of<Session>(context, listen: false).logOut(context),
          ),
          Divider(
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
