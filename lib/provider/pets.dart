import 'package:flutter/material.dart';

class PetItem with ChangeNotifier {
  String _name;
  String _photoUrl =
      'https://ar.zoetis.com/_locale-assets/mcm-portal-assets/publishingimages/especie/caninos_perro_img.png';
  int _speciesId;
  int _race = 1;
  int _age;
  // Getters datos de la mascota
  get name => _name;
  get photoUrl => _photoUrl;
  get speciesId => _speciesId;
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

  set speciesId(int value) {
    this._speciesId = value;
    notifyListeners();
  }

  set race(int value) {
    this._race = value;
    notifyListeners();
  }

  set age(int value) {
    this._age = value;
    notifyListeners();
  }
}
