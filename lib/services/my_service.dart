import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

import '../components/dialogs.dart';
import '../src/home/home.dart';
import '../utils/auth.dart';

class MyServices {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://7f5ab90c4daa.ngrok.io'));

  Future<void> register(
    BuildContext context, {
    @required String username,
    @required String email,
    @required String password,
  }) async {
    final ProgressDilog progressDilog = ProgressDilog(context);
    try {
      progressDilog.show(); // muestra barra de carga
      final Response response = await this._dio.post(
        '/api/user/register',
        //Dio utiliza por defecto el conten-tipe Json
        // options: Options(
        //     // headers: {
        //     //   'Content-Type': 'application/json',
        //     // },
        //     ),
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
      print(response);
      //guarda datos en el dispositivo
      await Auth.instance.setSession(email, password);
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
      final Response response = await this._dio.post(
        '/api/user/login',
        data: {
          "username": null,
          "email": email,
          "encryptedPassword": password,
          "enabled": true,
          "loguedIn": true
        },
      );
      print(response);
      print(DateTime.now());
      // GUARDA LAS CREDENCIALES EN STORAGE DEL DISPOSITIVO
      await Auth.instance.setSession(email, password);
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

  Future<void> logOut(
    BuildContext context, {
    @required String email,
    @required String password,
  }) async {
    final ProgressDilog progressDilog = ProgressDilog(context);
    try {
      progressDilog.show(); // muestra barra de carga
      final Response response = await this._dio.post(
        '/api/logout',
        data: {
          "id": 1,
          "userId": 1,
          "deviceId": 1,
          "startDate": "2021-02-26T17:59:36.449779",
          "endDate": "2021-02-26T17:59:36.449779",
          "modifiedAt": null,
          "modifiedBy": null
        },
      );
      print(response);
      print(DateTime.now());
      // GUARDA LAS CREDENCIALES EN STORAGE DEL DISPOSITIVO
      await Auth.instance.setSession(email, password);
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
}
