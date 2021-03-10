import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../components/dialogs.dart';
import '../src/home/home.dart';
import '../src/sign_in/sign_in_screen.dart';

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

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://f9860de4a333.ngrok.io'));

  Future<void> register(
    BuildContext context, {
    @required String username,
    @required String email,
    @required String password,
  }) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final response = await this._dio.post(
        '/api/user/register',
        data: {
          "id": null,
          "userId": null,
          "document": "5719493",
          "documentType": "CI",
          "name": username,
          "surname": username,
          "city": "Asunción",
          "profilePicture": null,
          "birthDate": "1998-06-27T00:00:00.000Z",
          "notifications": true,
          "username": username,
          "email": email,
          "encryptedPassword": password,
          "confirmPassword": password,
          "userType": "APP"
        },
      );
      //guarda datos en el dispositivo
      final user = response.data["dto"];
      _userSession = UserSession(
        id: user["id"].toString(),
        deviceId: user["deviceId"].toString(),
        userId: user["userId"].toString(),
      );
      await setSession();
      progressDialog.dismiss();
      // redirecciona al home eliminando paginas previas
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (_) => false);
    } catch (error) {
      progressDialog.dismiss();
      if (error is DioError) {
        final errorCode = error.response.statusCode.toString();
        final message = error.message;
        Dialogs.info(
          context,
          title: errorCode,
          content: message,
        );
      } else {
        print(error);
      }
    }
  }

  Future<void> login(
    BuildContext context, {
    @required String email,
    @required String password,
  }) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show(); // muestra barra de carga
      final response = await this._dio.post(
        '/api/user/login',
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
      progressDialog.dismiss();
      notifyListeners();
      // redirecciona al home eliminando paginas previas
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.routeName,
        (_) => false,
      );
    } catch (error) {
      progressDialog.dismiss();
      print(error);
      if (error is DioError) {
        String message = error.response.data['message'];
        print(error.response.data);
        Dialogs.info(
          context,
          title: 'ERROR',
          content: message,
        );
      } else {
        Dialogs.info(
          context,
          title: 'ERROR',
          content: "Error al loguearse",
        );
      }
    }
  }

  Future<void> logOut(BuildContext context) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show(); // muestra barra de carga
      await this._dio.post(
        '/api/user/logout',
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
      Navigator.pushNamedAndRemoveUntil(
          context, SignInScreen.routeName, (_) => false);
    } catch (error) {
      progressDialog.dismiss();
      if (error is DioError) {
        String message = error.response.data['message'];
        print(error.response.data);
        Dialogs.info(
          context,
          title: 'ERROR',
          content: message,
        );
      } else {
        Dialogs.info(
          context,
          title: 'ERROR',
          content: "Error al desloguearse",
        );
        print(error);
      }
    }
  }

  Future<void> setSession() async {
    await this._storage.write(key: sessionKey, value: _userSession.id);
    await this._storage.write(key: userKey, value: _userSession.userId);
    await this._storage.write(key: deviceKey, value: _userSession.deviceId);
  }

  Future getSession() async {
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
  }
}
