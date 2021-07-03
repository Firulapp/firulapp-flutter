import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import '../constants/endpoints.dart';
import './user.dart';

class PetServiceItem {
  String id;
  int userId;
  int category;
  String title;
  String address;
  bool status;
  String description;
  String email;
  double price;
  String createdAt;
  int createdBy;
  String modifiedAt;
  int modifiedBy;

  PetServiceItem({
    this.id,
    this.userId,
    this.category,
    this.title,
    this.address,
    this.description,
    this.email,
    this.status,
    this.price,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
  });
}

class PetService with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  List<PetServiceItem> _items;
  List<int> _speciesIds;
  final User user;

  PetService(this.user, _items);

  List<int> get speciesIds {
    return [..._speciesIds];
  }

  List<PetServiceItem> get items {
    return [..._items];
  }

  Future<void> fetchServices() async {
    try {
      _items = [];
      final response = await this._dio.get('${Endpoints.service}');
      final services = response.data["list"];
      services.forEach((service) {
        _items.add(
          mapJsonToEntity(service),
        );
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> save(PetServiceItem petService, int speciesId) async {
    try {
      final response = await _dio.post(
        Endpoints.service,
        data: {
          "serviceDto": {
            "id": petService.id,
            "userId": user.userData.id,
            "serviceTypeId": petService.category,
            "title": petService.title,
            "description": petService.description,
            "price": petService.price,
            "address": petService.address,
            "mailContact": user.userData.mail,
            "createdAt": petService.createdAt,
            "createdBy": user.userData.id,
            "modifiedAt": petService.createdAt,
            "modifiedBy": user.userData.id,
          },
          //TODO: Cambiar valor al confirmar que conecta con el back
          "species": null,
          // "species": List.of(_speciesIds),
        },
      );
      final petServiceResponse = response.data["dto"];
      if (_items.contains(petService)) {
        _items[_items.indexWhere((element) => element.id == petService.id)] =
            mapJsonToEntity(petServiceResponse);
      } else {
        _items.add(mapJsonToEntity(petServiceResponse));
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

/*  void updateSpeciesFilter(List<SpeciesItem> species) {
    _speciesIds = [];
    species.forEach((element) {
      _speciesIds.add(element.id);
    });
    notifyListeners();
  }*/

  PetServiceItem mapJsonToEntity(dynamic json) {
    return PetServiceItem(
      id: json["id"],
      userId: json["userId"],
      address: json["address"],
      category: json["serviceTypeId"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      email: json["email"],
      createdAt: json["createdAt"],
      createdBy: user.userData.id,
      modifiedAt: json["modifiedAt"],
      modifiedBy: user.userData.id,
    );
  }

  PetServiceItem getLocalPetServiceById(String serviceId) {
    return _items.firstWhere((serv) => serv.id == serviceId);
  }
}
