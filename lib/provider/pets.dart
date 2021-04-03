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
  String secondaryColor;
  bool status;
  int speciesId;
  String picture;
  String description;
  String createdAt;
  int createdBy;
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
    this.secondaryColor,
    this.status,
    this.speciesId,
    this.picture,
    this.description,
    this.createdAt,
    this.createdBy,
  });
}

class Pets with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  PetItem _petItem;
  final User userData;

  Pets(this.userData, petItem);

  set petItem(PetItem petItem) {
    _petItem = petItem;
    notifyListeners();
  }

  get petItem => _petItem;

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
          "secondaryColor": _petItem.secondaryColor,
          "status": true,
          "picture": null, // fixed debe enviar string base64
          "description": _petItem.description,
          "createdAt": null, //DateTime.now().toIso8601String(),
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

  Future<void> getPetById() async {
    try {
      final response = await this._dio.get('${Endpoints.pet}/${_petItem.id}');
      final petResponse = response.data["dto"];
      var pet = PetItem(
        id: petResponse["id"],
        breedId: petResponse["breedId"],
        name: petResponse["name"],
        birthDate: petResponse["birthDate"],
        age: petResponse["age"],
        petSize: petResponse["petSize"],
        city: petResponse["city"],
        address: petResponse["address"],
        primaryColor: petResponse["primaryColor"],
        secondaryColor: petResponse["secondaryColor"],
        status: petResponse["status"],
        picture: petResponse["picture"],
        description: petResponse["description"],
        createdAt: petResponse["createdAt"],
        createdBy: petResponse["createdBy"],
      );
      petItem = pet;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
