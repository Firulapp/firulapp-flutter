import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constants/endpoints.dart';
import 'user.dart';

class PetItem with ChangeNotifier {
  int id;
  int userId;
  int breedId;
  String name;
  String birthDate;
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
    this.userId,
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

  //https://carlosamillan.medium.com/parseando-json-complejo-en-flutter-18d46c0eb045
  factory PetItem.fromJson(Map<String, dynamic> parsedJson) {
    return PetItem(
      id: parsedJson["id"],
      breedId: parsedJson["breedId"],
      name: parsedJson["name"],
      birthDate: parsedJson["birthDate"],
      age: parsedJson["age"],
      petSize: parsedJson["petSize"],
      city: parsedJson["city"],
      address: parsedJson["address"],
      primaryColor: parsedJson["primaryColor"],
      secondaryColor: parsedJson["secondaryColor"],
      status: parsedJson["status"],
      picture: parsedJson["picture"],
      description: parsedJson["description"],
      createdAt: parsedJson["createdAt"],
      createdBy: parsedJson["createdBy"],
    );
  }
}

class Pets with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  PetItem _petItem;
  final User userData;
  List<PetItem> _items = [];

  Pets(this.userData, petItem);

  set petItem(PetItem petItem) {
    _petItem = petItem;
    notifyListeners();
  }

  // Devuelve solo las mascotas con status True
  List<PetItem> get enablePets => _items.where((e) => e.status).toList();
  // devuelve todas las mascotas
  List<PetItem> get items => [..._items];

  PetItem getLocalPetById(int id) {
    return _items.firstWhere((pet) => pet.id == id);
  }

  get petItem => _petItem;

  Future savePet() async {
    try {
      final response = await this._dio.post(
        Endpoints.petSave,
        data: {
          "id": _petItem.id != null ? _petItem.id : null,
          "userId": userData.userData.id,
          "speciesId": _petItem.speciesId,
          "breedId": _petItem.breedId,
          "name": _petItem.name,
          "birthDate": _petItem.birthDate,
          "age": _petItem.age,
          "petSize": _petItem.petSize,
          "city": userData.userData.city,
          "address": null, // fixed obtener este dato del usuario
          "primaryColor": _petItem.primaryColor,
          "secondaryColor": _petItem.secondaryColor,
          "status": _petItem.status,
          "picture": _petItem.picture, // fixed debe enviar string base64
          "description": _petItem.description,
          "createdAt": _petItem.createdAt != null ? _petItem.createdAt : null,
          "createdBy": userData.userData.id,
          "modifiedAt": null,
          "modifiedBy": null
        },
      );
      print(response.data["dto"]);
      notifyListeners();
    } catch (error) {
      print(error.toString());
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

  Future<void> fetchPetList() async {
    try {
      final response =
          await this._dio.get('${Endpoints.pet}/user/${userData.userData.id}');
      final List<PetItem> loadedPets = [];
      if (_items.isEmpty) {
        response.data['list'].forEach((pet) {
          loadedPets.add(PetItem(
            id: pet["id"],
            breedId: pet["breedId"],
            name: pet["name"],
            birthDate: pet["birthDate"],
            age: pet["age"],
            petSize: pet["petSize"],
            city: pet["city"],
            address: pet["address"],
            primaryColor: pet["primaryColor"],
            secondaryColor: pet["secondaryColor"],
            status: pet["status"],
            picture: pet["picture"],
            description: pet["description"],
            createdAt: pet["createdAt"],
            createdBy: pet["createdBy"],
          ));
        });
        _items = loadedPets;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }
}
