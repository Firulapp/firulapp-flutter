import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../components/dialogs.dart';
import '../src/home/home.dart';
import '../src/sign_in/sign_in_screen.dart';

class MyServices extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  final emailKey = "EMAILK";
  final passwordKey = "PASSWORDK";

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:9000'));

  Future<void> register(
    BuildContext context, {
    @required String username,
    @required String email,
    @required String password,
  }) async {
    final ProgressDilog progressDilog = ProgressDilog(context);
    try {
      progressDilog.show();
      await this._dio.post(
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
      await setSession(email, password);
      progressDilog.dismiss();
      // redirecciona al home eliminando paginas previas
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (_) => false);
    } catch (error) {
      progressDilog.dismiss();
      print(error);
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
    final ProgressDilog progressDilog = ProgressDilog(context);
    try {
      progressDilog.show(); // muestra barra de carga
      await this._dio.post(
        '/api/user/login',
        data: {
          "username": null,
          "email": email,
          "encryptedPassword": password,
          "enabled": true,
          "loguedIn": true
        },
      );
      // GUARDA LAS CREDENCIALES EN STORAGE DEL DISPOSITIVO
      await setSession(email, password);
      progressDilog.dismiss();
      // redirecciona al home eliminando paginas previas
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.routeName,
        (_) => false,
      );
    } catch (error) {
      progressDilog.dismiss();
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
        print(error);
      }
    }
  }

  Future<void> logOut(BuildContext context) async {
    final ProgressDilog progressDilog = ProgressDilog(context);
    try {
      progressDilog.show(); // muestra barra de carga
      await this._dio.post(
        '/api/logout',
        data: {"id": 1, "userId": 1, "deviceId": 1},
      );
      //Elimina los datos del dispositivo y redirecciona a la pagina del login
      await this._storage.deleteAll();
      Navigator.pushNamedAndRemoveUntil(
          context, SignInScreen.routeName, (_) => false);
      progressDilog.dismiss();
    } catch (error) {
      progressDilog.dismiss();
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
        print(error);
      }
    }
  }

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
}
