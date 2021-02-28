import 'package:flutter/material.dart';

class SuperUserData with ChangeNotifier {
  String _userName = 'Matias Fare';
  String _userMail = 'matiasfare59@gmail.com';

  // Getters datos del usuario
  get userName => _userName;
  get userMail => _userMail;

  set userName(String value) {
    this._userName = value;

    notifyListeners();
  }
}
