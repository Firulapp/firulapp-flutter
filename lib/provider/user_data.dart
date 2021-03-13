import 'package:flutter/material.dart';

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
  final String city;
  final DateTime birthDate;
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

  UserData get userData {
    return _userData;
  }

  void addUser(UserData userData) {
    _userData = userData;
    notifyListeners();
  }
}
