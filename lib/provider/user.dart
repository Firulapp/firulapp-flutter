import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constants/endpoints.dart';
import './session.dart';

class UserCredentials {
  final String encryptedPassword;
  final String confirmPassword;
  final String mail;

  UserCredentials({
    this.encryptedPassword,
    this.confirmPassword,
    this.mail,
  });
}

class UserData {
  int id;
  int userId;
  String userName;
  String encryptedPassword;
  String confirmPassword;
  String mail;
  String name;
  String surname;
  String document;
  String documentType;
  int city;
  String birthDate;
  FileImage profilePicture;
  String userType = 'APP';
  bool enabled = true;
  bool notifications;

  UserData({
    this.id,
    this.userId,
    this.userName,
    this.encryptedPassword,
    this.confirmPassword,
    this.mail,
    this.name,
    this.surname,
    this.document,
    this.documentType,
    this.city,
    this.profilePicture,
    this.notifications,
    this.birthDate,
  });
}

class User with ChangeNotifier {
  UserData _userData;
  final UserSession session;

  User(this.session, _userData);

  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));

  UserData get userData {
    return _userData;
  }

  List<String> getDocumentTypeOptions() {
    return ['CI', 'RUC', 'Pasaporte'];
  }

  void addUser(UserData userData) {
    _userData = userData;
    notifyListeners();
  }

  Future<void> getUser() async {
    try {
      final response =
          await this._dio.get('${Endpoints.user}/${session.userId}');
      final userResponse = response.data["dto"];
      var userData = UserData(
        id: userResponse["id"],
        userId: userResponse["userId"],
        name: userResponse["name"],
        surname: userResponse["surname"],
        city: userResponse["city"],
        document: userResponse["document"],
        documentType: userResponse["documentType"],
        profilePicture: userResponse["profilePicture"],
        birthDate: userResponse["birthDate"],
        notifications: userResponse["notifications"],
        userName: userResponse["username"],
        mail: userResponse["email"],
      );
      addUser(userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> saveUser() async {
    try {
      await this._dio.post(
        '${Endpoints.update}',
        data: {
          "id": userData.id,
          "userId": userData.userId,
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
          "enabled": true
        },
      );
    } catch (error) {
      throw error;
    }
  }
}
