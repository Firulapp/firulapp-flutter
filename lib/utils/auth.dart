import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart' show required;

class Auth {
  Auth._interna();
  static Auth _instance = Auth._interna();
  static Auth get instance => _instance;

  final _storage = FlutterSecureStorage();
  final emailKey = "EMAILK";
  final passwordKey = "PASSWORDK";
  // guarda de manera segura el json
  // Future<void> setSession(Map<String, dynamic> data) async {
  //   final Session session = Session(
  //     token: data['token'],
  //     expiresIn: data['expiresIn'],
  //     createAt: DateTime.now(),
  //   );

  //   final String value = jsonEncode(session.toJson());
  //   await this._storage.write(key: key, value: value);
  // }

  Future<void> setSession(String userEmail, String userPassword) async {
    //final String value = jsonEncode(session.toJson());
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

  // Future<Session> getSession() async {
  //   final String  = await this._storage.read(key: key);
  //   if (value != null) {
  //     final Map<String, dynamic> json = jsonDecode(value);
  //     final session = Session.fromJson(json);
  //     return session;
  //   }
  //   return null;
  // }
}

// class Session {
//   final String token;
//   final int expiresIn;
//   final DateTime createAt;

//   Session({
//     @required this.token,
//     @required this.expiresIn,
//     @required this.createAt,
//   });

//   static Session fromJson(Map<String, dynamic> json) {
//     return Session(
//       token: json['token'],
//       expiresIn: json['expiresIn'],
//       createAt: DateTime.parse(json['createAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'token': this.token,
//       'expiresIn': this.expiresIn,
//       'createAt': this.createAt.toString(),
//     };
//   }
// }
