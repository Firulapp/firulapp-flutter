import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constants/endpoints.dart';
import 'session.dart';
import 'user.dart';

class PetItem with ChangeNotifier {
  int id;
  int breedId;
  String name;
  DateTime birthDate;
  int age;
  String petSize;
  int city;
  String address;
  String primaryColor;
  String secundaryColor;
  int speciesId;
  String picture;
  String description;
  DateTime createdAt;
  //DateTime createdBy; //userId

  PetItem({
    this.id,
    this.breedId,
    this.name,
    this.birthDate,
    this.age,
    this.petSize,
    this.city,
    this.address,
    this.primaryColor,
    this.secundaryColor,
    this.speciesId,
    this.picture,
    this.description,
  });
}

class Pets with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  PetItem _petItem;
  final User userData;

  Pets(this.userData, petItem);

  set setPet(PetItem petItem) {
    _petItem = petItem;
    notifyListeners();
  }

  get getPet => _petItem;

  Future savePet() async {
    try {
      final response = await this._dio.post(
        Endpoints.petSave,
        data: {
          "id": null,
          "userId": userData.userData.id,
          "speciesId": _petItem.speciesId,
          "breedId": _petItem.breedId,
          "name": _petItem.name,
          "birthDate": _petItem.birthDate.toIso8601String(),
          "age": _petItem.age,
          "petSize": _petItem.petSize,
          "city": userData.userData.city,
          "address": null, // fixed obtener este dato del usuario
          "primaryColor": _petItem.primaryColor,
          "secondaryColor": _petItem.secundaryColor,
          "status": true,
          "picture": null, // fixed debe enviar string base64
          "description": _petItem.description,
          "createdAt": DateTime.now().toIso8601String(),
          "createdBy": userData.userData.id,
          "modifiedAt": null,
          "modifiedBy": null
        },
      );
      print(response.data["dto"]);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
