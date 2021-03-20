import 'package:firulapp/provider/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../components/dialogs.dart';
import '../../../provider/session.dart';
import '../../sign_in/sign_in_screen.dart';
import '../../../constants/constants.dart';
import '../../profile/profile_screen.dart';

class HomeDrawer extends StatelessWidget {
/*  final UserData user;

  HomeDrawer(this.user);*/

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("asda"),
            accountEmail: Text("ds"),
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
              title: const Text('Cerrar Sesion'),
              onTap: () async {
                try {
                  await Provider.of<Session>(context, listen: false)
                      .logOut(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignInScreen.routeName, (_) => false);
                } catch (error) {
                  Dialogs.info(
                    context,
                    title: 'ERROR',
                    content: error.response.data["message"],
                  );
                  print(error);
                }
              }),
          Divider(
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
