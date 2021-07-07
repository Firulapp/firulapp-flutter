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
  String status;
  int speciesId;
  String picture;
  String description;
  String createdAt;
  int createdBy;

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

  String get staus => status;

  //https://carlosamillan.medium.com/parseando-json-complejo-en-flutter-18d46c0eb045
  factory PetItem.fromJson(Map<String, dynamic> parsedJson) {
    return PetItem(
      id: parsedJson["id"],
      userId: parsedJson["userId"],
      speciesId: parsedJson["speciesId"],
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

enum PetStatus {
  ADOPTAR,
  APADRINAR,
  APADRINADA,
  ADOPTADA,
  PERDIDA,
  ENCONTRADA,
  NORMAL
}

class Pets with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  PetItem _petItem;
  final User userData;
  List<PetItem> _items = [];
  List<PetItem> _petsByStatus = [];
  List<PetItem> _foundPets = [];
  List<PetItem> _lostPets = [];
  List<PetItem> _allPets = []; //usado para filtrar mascotas

  Pets(this.userData, petItem);

  set petItem(PetItem petItem) {
    _petItem = petItem;
    notifyListeners();
  }

  set items(List<PetItem> list) {
    _items = list;
    notifyListeners();
  }

  set petsByStatus(List<PetItem> list) {
    _petsByStatus = list;
    notifyListeners();
  }

  List<PetItem> get petsByStatus => [..._petsByStatus];

  // devuelve todas las mascotas
  List<PetItem> get items => [..._items];

  PetItem getLocalPetById(int id) {
    return _items.firstWhere((pet) => pet.id == id);
  }

  PetItem getLocalPetInAdoptionById(int id) {
    return _petsByStatus.firstWhere((pet) => pet.id == id);
  }

  PetItem getLocalFoundPetById(int id) {
    return _foundPets.firstWhere((pet) => pet.id == id);
  }

  PetItem getLocalLostPetById(int id) {
    return _lostPets.firstWhere((pet) => pet.id == id);
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
          "address": null,
          "primaryColor": _petItem.primaryColor,
          "secondaryColor": _petItem.secondaryColor,
          "status": _petItem.status,
          "picture": _petItem.picture,
          "description": _petItem.description,
          "createdAt": _petItem.createdAt != null ? _petItem.createdAt : null,
          "createdBy": userData.userData.id,
          "modifiedAt": _petItem.createdAt != null ? _petItem.createdAt : null,
          "modifiedBy": userData.userData.id,
        },
      );
      if (_items.indexWhere((element) => element.id == _petItem.id) != -1) {
        _items[_items.indexWhere((element) => element.id == _petItem.id)] =
            PetItem.fromJson(response.data["dto"]);
      } else {
        _items.add(PetItem.fromJson(response.data["dto"]));
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> getPetById(int optionalId) async {
    int id = optionalId == null ? _petItem.id : optionalId;
    try {
      final response = await this._dio.get('${Endpoints.pet}/$id');
      final petResponse = response.data["dto"];
      var pet = PetItem(
        id: petResponse["id"],
        userId: petResponse["userId"],
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
      if (!response.data['list'].isEmpty) {
        response.data['list'].forEach((pet) {
          _allPets.add(PetItem.fromJson(pet));
          if (pet["status"] != "ENCONTRADA") {
            loadedPets.add(PetItem.fromJson(pet));
          }
        });
        items = loadedPets;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchPetListByStatus({String status = "ADOPTAR"}) async {
    try {
      final response = await this._dio.get('${Endpoints.petByStatus}/$status');
      final List<PetItem> loadedPets = [];
      response.data['list'].forEach((pet) {
        loadedPets.add(PetItem.fromJson(pet));
      });
      petsByStatus = loadedPets;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future fetchLostPetList() async {
    try {
      final response = await this._dio.get('${Endpoints.petByStatus}/PERDIDA');
      final List<PetItem> loadedPets = [];
      response.data['list'].forEach((pet) {
        loadedPets.add(PetItem.fromJson(pet));
      });
      _lostPets = loadedPets;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future fetchFoundPetList() async {
    try {
      final response =
          await this._dio.get('${Endpoints.petByStatus}/ENCONTRADA');
      final List<PetItem> loadedPets = [];
      response.data['list'].forEach((pet) {
        loadedPets.add(PetItem.fromJson(pet));
      });
      _foundPets = loadedPets;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future deletePet(PetItem pet) async {
    try {
      await this._dio.delete(
        Endpoints.petDelete,
        data: {
          "id": pet.id != null ? pet.id : null,
          "userId": userData.userData.id,
          "speciesId": pet.speciesId,
          "breedId": pet.breedId,
          "name": pet.name,
          "birthDate": pet.birthDate,
          "age": pet.age,
          "petSize": pet.petSize,
          "city": userData.userData.city,
          "address": null, //TODO: direccion del usuario
          "primaryColor": pet.primaryColor,
          "secondaryColor": pet.secondaryColor,
          "status": pet.status,
          "picture": pet.picture,
          "description": pet.description,
          "createdAt": pet.createdAt != null ? pet.createdAt : null,
          "createdBy": userData.userData.id,
          "modifiedAt": pet.createdAt != null ? pet.createdAt : null,
          "modifiedBy": userData.userData.id,
        },
      );
      _items.remove(getLocalPetById(pet.id));
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
  }

  Future<void> tranferPet(String userName, int petId) async {
    try {
      final response = await this
          ._dio
          .post('${Endpoints.transferPet}/$petId/user/$userName');
      if (response.data["success"]) {
        items = [];
        fetchPetList();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> requestAdoption(int petId) async {
    print(userData.userData.id);
    print(petId);
    try {
      await this
          ._dio
          .post('${Endpoints.pet}/$petId/adopt/${userData.userData.id}');
    } catch (e) {
      throw e;
    }
  }

  Future<void> requestFostering(int petId, String amount) async {
    print(userData.userData.id);
    print(petId);
    try {
      await this._dio.post(
          '${Endpoints.pet}/$petId/foster/${userData.userData.id}/amount/$amount');
    } catch (e) {
      throw e;
    }
  }
}

extension PetsExtension on PetStatus {
  String get value {
    switch (this) {
      case PetStatus.ADOPTADA:
        return 'ADOPTADA';
      case PetStatus.ADOPTAR:
        return 'ADOPTAR';
      case PetStatus.APADRINADA:
        return 'APADRINADA';
      case PetStatus.APADRINAR:
        return 'APADRINAR';
      case PetStatus.ENCONTRADA:
        return 'ENCONTRADA';
      case PetStatus.PERDIDA:
        return 'PERDIDA';
      default:
        return null;
    }
  }
}
