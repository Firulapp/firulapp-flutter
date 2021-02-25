import 'package:flutter/material.dart';

class SuperUserData with ChangeNotifier {
  String _userName = 'Matias Fare';
  String _userMail = 'matiasfare59@gmail.com';

  get userName {
    return _userName;
  }

  get userMail {
    return _userMail;
  }

  set userName(String value) {
    this._userName = value;

    notifyListeners();
  }
}
