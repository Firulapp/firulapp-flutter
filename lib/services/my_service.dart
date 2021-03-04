import 'package:dio/dio.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/src/home/home.dart';
import 'package:firulapp/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class MyServices {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://2eaf2c9cc35b.ngrok.io'));

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
}
