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
  final _storage = FlutterSecureStorage();
  final sessionKey = "SESSIONK";
  final userKey = "USERK";
  final deviceKey = "DEVICEK";
  UserSession _userSession;

  UserSession get userSession {
    return _userSession;
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
      // muestra barra de carga
      await this._dio.post(
        Endpoints.logout,
        data: {
          "id": _userSession.id,
          "deviceId": _userSession.deviceId,
          "userId": _userSession.userId,
        },
      );
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
