import 'package:flutter/material.dart';
// import 'componets/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white30,
      ),
      endDrawer: Drawer(
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
      ),
      //bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
