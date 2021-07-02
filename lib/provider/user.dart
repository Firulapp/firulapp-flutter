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
  String phoneNumber;
  String document;
  String documentType;
  int city;
  String birthDate;
  String profilePicture;
  String userType = 'APP'; //ADMIN, APP, ORGANIZACION
  bool enabled;
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
    this.phoneNumber,
    this.documentType,
    this.city,
    this.profilePicture,
    this.notifications,
    this.birthDate,
    this.userType,
    this.enabled,
  });
}

class OrganizationData {
  int id;
  int userId;
  String type; // VETERINARIA, UNIPERSONAL, ONG, ENTIDAD_PUBLICA, TIENDA, OTRO
  String organizationName;
  String ruc;
  String email;
  String description;
  bool status;
  String createdAt;
  String createdBy;
  String modifiedAt;
  String modifiedBy;

  OrganizationData({
    this.id,
    this.userId,
    this.type,
    this.organizationName,
    this.ruc,
    this.email,
    this.description,
    this.status,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
  });
}

class User with ChangeNotifier {
  UserData _userData;
  OrganizationData _organizationData;
  final UserSession session;

  User(_userData, this.session);

  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));

  UserData get userData {
    return _userData;
  }

  OrganizationData get organizationData {
    return _organizationData;
  }

  List<String> getDocumentTypeOptions() {
    return ['CI', 'RUC', 'Pasaporte'];
  }

  List<String> getOrganizationTypeOptions() {
    return [
      'VETERINARIA',
      'UNIPERSONAL',
      'ONG',
      'ENTIDAD_PUBLICA',
      'TIENDA',
      'OTRO'
    ];
  }

  void addUser(UserData userData) {
    _userData = userData;
    notifyListeners();
  }

  void addOrganization(OrganizationData organizationData) {
    _organizationData = organizationData;
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
        userType: userResponse["userType"],
        birthDate: userResponse["birthDate"],
        notifications: userResponse["notifications"],
        userName: userResponse["username"],
        mail: userResponse["email"],
        enabled: userResponse["enabled"],
      );
      addUser(userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> saveUser() async {
    try {
      await this._dio.post(
        '${Endpoints.updateUser}',
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
      addUser(userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> saveUserOrganizacion() async {
    try {
      await this._dio.post(
        '${Endpoints.updateUser}',
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
      addUser(userData);
    } catch (error) {
      throw error;
    }
  }
}
