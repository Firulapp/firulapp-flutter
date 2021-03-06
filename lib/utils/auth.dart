import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import '../src/sign_in/sign_in_screen.dart';

class Auth {
  Auth._interna();
  static Auth _instance = Auth._interna();
  static Auth get instance => _instance;

  final _storage = FlutterSecureStorage();
  final emailKey = "EMAILK";
  final passwordKey = "PASSWORDK";

  Future<void> setSession(String userEmail, String userPassword) async {
    await this._storage.write(key: emailKey, value: userEmail);
    await this._storage.write(key: passwordKey, value: userPassword);
    print("SE GUARDARON LAS CREDENCIALES");
  }

  Future getSession() async {
    final String emailValue = await this._storage.read(key: emailKey);
    final String passwordValue = await this._storage.read(key: passwordKey);

    if (passwordValue != null && emailValue != null) {
      final session = {
        "email": emailValue,
        "encryptedPassword": passwordValue,
      };
      return session;
    }
    return null;
  }

  Future<void> logOut(BuildContext context) async {
    //Elimina los datos del dispositivo y redirecciona a la pagina del login
    await this._storage.deleteAll();
    Navigator.pushNamedAndRemoveUntil(
        context, SignInScreen.routeName, (_) => false);
  }
}
