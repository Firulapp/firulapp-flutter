import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firulapp/provider/user.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/endpoints.dart';

class UserSession {
  final String id;
  final String userId;
  final String deviceId;

  UserSession({
    this.id,
    this.userId,
    this.deviceId,
  });
}

class Session extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool _userEnable = true;
  AuthResult authResult;
  final _storage = FlutterSecureStorage();
  final sessionKey = "SESSIONK";
  final userKey = "USERK";
  final deviceKey = "DEVICEK";
  UserSession _userSession;

  UserSession get userSession {
    return _userSession;
  }

  bool get userEnable {
    return _userEnable;
  }

  set userEnable(bool userEnable) {
    _userEnable = userEnable;
    notifyListeners();
  }

  bool get isAuth {
    return userSession != null;
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));

  Future<void> register({
    @required UserData userData,
  }) async {
    try {
      final response = await this._dio.post(
        Endpoints.signUp,
        data: {
          "id": null,
          "userId": null,
          "document": userData.document,
          "documentType": userData.documentType,
          "name": userData.name,
          "surname": userData.surname,
          "city": userData.city,
          "profilePicture": userData.profilePicture,
          "birthDate": userData.birthDate,
          "notifications": userData.notifications,
          "username": userData.userName,
          "email": userData.mail,
          "encryptedPassword": userData.encryptedPassword,
          "confirmPassword": userData.confirmPassword,
          "userType": userData.userType,
          "enabled": userData.enabled
        },
      );
      final user = response.data["dto"];
      _userSession = UserSession(
        id: user["id"].toString(),
        deviceId: user["deviceId"].toString(),
        userId: user["userId"].toString(),
      );
      authResult = await _auth.createUserWithEmailAndPassword(
        email: userData.mail,
        password: userData.confirmPassword,
      );
      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({
        'username': userData.userName,
        'email': userData.mail,
      });
      await setSession();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> registerOrganizacion({
    @required UserData userData,
    @required OrganizationData organizationData,
  }) async {
    try {
      final response = await this._dio.post(
        Endpoints.organizationSingUp,
        data: {
          "profileDto": {
            "id": null,
            "userId": null,
            "document": userData.document,
            "documentType": userData.documentType,
            "name": userData.name,
            "surname": userData.surname,
            "city": userData.city,
            "profilePicture": userData.profilePicture,
            "birthDate": userData.birthDate,
            "notifications": userData.notifications,
            "username": userData.userName,
            "email": userData.mail,
            "encryptedPassword": userData.encryptedPassword,
            "confirmPassword": userData.confirmPassword,
            "userType": userData.userType
          },
          "organizationDto": {
            "id": organizationData.id,
            "userId": organizationData.id,
            "type": organizationData.type,
            "organizationName": organizationData.organizationName,
            "description": organizationData.description,
            "status": organizationData.status,
          },
        },
      );
      final user = response.data["dto"];
      _userSession = UserSession(
        id: user["id"].toString(),
        deviceId: user["deviceId"].toString(),
        userId: user["userId"].toString(),
      );
      authResult = await _auth.createUserWithEmailAndPassword(
        email: userData.mail,
        password: userData.confirmPassword,
      );
      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({
        'username': userData.userName,
        'email': userData.mail,
      });
      await setSession();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login({
    @required String email,
    @required String password,
  }) async {
    try {
      final response = await this._dio.post(
        Endpoints.login,
        data: {
          "username": null,
          "email": email,
          "encryptedPassword": password,
          "enabled": true,
          "loguedIn": true
        },
      );
      final user = response.data["dto"];
      _userSession = UserSession(
        id: user["id"].toString(),
        deviceId: user["deviceId"].toString(),
        userId: user["userId"].toString(),
      );
      await setSession();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logOut() async {
    try {
      await this._dio.post(
        Endpoints.logout,
        data: {
          "id": _userSession.id,
          "deviceId": _userSession.deviceId,
          "userId": _userSession.userId,
        },
      );
      await FirebaseAuth.instance.signOut(); // log aout del chat
      //Elimina los datos del dispositivo y redirecciona a la pagina del login
      _userSession = null;
      await this._storage.deleteAll();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> setSession() async {
    await this._storage.write(key: sessionKey, value: _userSession.id);
    await this._storage.write(key: userKey, value: _userSession.userId);
    await this._storage.write(key: deviceKey, value: _userSession.deviceId);
  }

  Future<UserSession> getSession() async {
    final String sessionValue = await this._storage.read(key: sessionKey);
    final String userValue = await this._storage.read(key: userKey);
    final String deviceValue = await this._storage.read(key: deviceKey);

    if (userValue != null && sessionValue != null && deviceValue != null) {
      _userSession = UserSession(
        id: sessionValue,
        deviceId: deviceValue,
        userId: userValue,
      );
    } else {
      _userSession = null;
    }
    return _userSession;
  }
}
