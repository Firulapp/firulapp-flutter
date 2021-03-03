import 'package:dio/dio.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/src/home/home.dart';
import 'package:firulapp/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class MyServices {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://6625d8c30326.ngrok.io'));

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
        '/api/v1/register',
        //Dio utiliza por defecto el conten-tipe Json
        // options: Options(
        //     // headers: {
        //     //   'Content-Type': 'application/json',
        //     // },
        //     ),
        data: {
          "username": username,
          "email": email,
          "password": password,
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
        print(error.response.statusCode);
        print(error.response.data);
        Dialogs.info(
          context,
          title: "ERROR",
          content: error.response.statusCode == 409
              ? 'Email Duplicado '
              : error.message,
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
        String message = error.message;
        if (error.response.statusCode == 404) {
          message = "No existe el Usuario";
        } else if (error.response.statusCode == 403) {
          message = "Contraseña Invalida";
        }
        print(error.response.statusCode);
        print(error.response);
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
