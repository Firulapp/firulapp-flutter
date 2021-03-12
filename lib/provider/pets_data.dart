import 'package:flutter/material.dart';

class PetsData with ChangeNotifier {
  String _name = 'Firulains';
  String _photoUrl =
      'https://ar.zoetis.com/_locale-assets/mcm-portal-assets/publishingimages/especie/caninos_perro_img.png';
  String _speci = 'Perro';
  String _race = 'Labrador';
  String _age = '2 meses';

  // Getters datos del usuario
  get name => _name;
  get photoUrl => _photoUrl;
  get speci => _speci;
  get race => _race;
  get age => _age;

  set name(String value) {
    this._name = value;
    notifyListeners();
  }

  set photoUrl(String value) {
    this._photoUrl = value;
    notifyListeners();
  }

  set speci(String value) {
    this._speci = value;
    notifyListeners();
  }

  set race(String value) {
    this._race = value;
    notifyListeners();
  }

  set age(String value) {
    this._age = value;
    notifyListeners();
  }
}
