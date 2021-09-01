import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firulapp/provider/user.dart' as u;
import 'package:firulapp/src/chat/chat_screen.dart';
import 'package:firulapp/src/chat/chat_lists.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../../../components/dialogs.dart';
import '../../../provider/session.dart';
import '../../sign_in/sign_in_screen.dart';
import '../../../constants/constants.dart';
import '../../profile/profile_screen.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  File _storedImage;
  Future _initialImage;

  @override
  void initState() {
    _initialImage = _initiateStoredImage();
    super.initState();
  }

  Future _initiateStoredImage() async {
    Uint8List bytes = base64Decode(
        Provider.of<u.User>(context, listen: false).userData.profilePicture);
    final tempPath = await syspaths.getTemporaryDirectory();
    _storedImage = File('${tempPath.path}/profile.png');
    await _storedImage.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    FileImage(_storedImage).evict();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<u.User>(context).userData;
    var _name = user == null ? "" : user.name;
    var _surname = user == null
        ? ""
        : user.surname == null
            ? ""
            : user.surname;
    var _mail = user == null ? "" : user.mail;
    return Drawer(
      elevation: 10.0,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("$_name $_surname"),
            accountEmail: Text("$_mail"),
            currentAccountPicture: FutureBuilder(
                future: _initialImage,
                builder: (_, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/default-avatar.png"),
                    );
                  } else {
                    return CircleAvatar(
                      backgroundImage: _storedImage != null
                          ? FileImage(_storedImage)
                          : AssetImage("assets/images/default-avatar.png"),
                    );
                  }
                }),
            decoration: BoxDecoration(color: Constants.kSecondaryColor),
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
            leading: Icon(Icons.chat),
            title: Text('Chat'),
            onTap: () {
              // This line code will close drawer programatically....
              Navigator.pop(context);
              // Navigator.pushNamed(context, ChatScreen.routeName);
              Navigator.pushNamed(context, ChatList.routeName,
                  arguments: user.userName);
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
                  await Provider.of<Session>(context, listen: false).logOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignInScreen.routeName, (_) => false);
                } on PlatformException catch (err) {
                  var message = '';

                  if (err.message != null) {
                    message = err.message;
                  }
                  Dialogs.info(
                    context,
                    title: 'ERROR',
                    content: message,
                  );
                } catch (error) {
                  print(error);
                  String message = "Ocurrio un error inesperado";
                  Dialogs.info(
                    context,
                    title: 'ERROR',
                    content: message,
                  );
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
