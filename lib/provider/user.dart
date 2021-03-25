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
  final String userName;
  final String encryptedPassword;
  final String confirmPassword;
  final String mail;
  final String name;
  final String surname;
  final String document;
  final String documentType;
  final int city;
  final String birthDate;
  final FileImage profilePicture;
  final String userType = 'APP';
  final bool enabled = true;
  final bool notifications;

  UserData({
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
}
