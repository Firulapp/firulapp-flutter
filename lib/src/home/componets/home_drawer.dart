import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({Key key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Matias Fare'),
            accountEmail: Text('matiasfare59@gmail.com'),
            currentAccountPicture: Image.network(
                'https://www.sodep.com.py/images/matias-fare.png'),
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Ver Perfil'),
            onTap: () {
              // This line code will close drawer programatically....
              Navigator.pop(context);
            },
          ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar Sesion'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
