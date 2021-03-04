import 'package:flutter/material.dart';

class SuperUserData with ChangeNotifier {
  String _userName = 'mfare';
  String _name = 'Matias';
  String _surname = 'Fare';
  String _mail = 'matiasfare59@gmail.com';
  String _document = '5719493';
  String _documentType = 'CI';
  String _city = 'Asunción';
  DateTime _birthDate = DateTime.now();
  FileImage _profilePicture = null;
  String _userType = 'APP';

  // Getters datos del usuario
  get userName => _userName;
  get name => _name;
  get surname => _surname;
  get mail => _mail;
  get document => _document;
  get documentType => _documentType;
  get city => _city;
  get birthDate => _birthDate;
  get profilePicture => _profilePicture;
  get userType => _userType;

  set userName(String value) {
    this._name = value;
    notifyListeners();
  }
}
