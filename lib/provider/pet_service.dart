import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import '../constants/endpoints.dart';
import './user.dart';

class PetServiceItem {
  int id;
  int userId;
  int category;
  int speciesId;
  String title;
  String address;
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
    this.price,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
  });
}

class PetService with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  List<PetServiceItem> _items = [];
  List<PetServiceItem> _ownItems = [];
  List<int> _speciesIds = [];
  final User user;
  int _serviceType;

  PetService(this.user, _items);

  List<int> get speciesIds {
    return [..._speciesIds];
  }

  void setSpeciesId(int id) {
    _speciesIds = [];
    _speciesIds.add(id);
  }

  int get serviceType {
    return _serviceType;
  }

  List<PetServiceItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  List<PetServiceItem> get ownItems {
    return [..._ownItems];
  }

  int get ownItemCount {
    return _ownItems.length;
  }

  void setServiceType(int serviceType) {
    _serviceType = serviceType;
  }

  PetServiceItem getLocalOwnServiceById(int serviceId) {
    return ownItems.firstWhere((serv) => serv.id == serviceId);
  }

  PetServiceItem getLocalServiceById(int serviceId) {
    return items.firstWhere((serv) => serv.id == serviceId);
  }

  Future<void> fetchServicesByType() async {
    try {
      _items = [];
      final response = await this._dio.post(
        '${Endpoints.fetchServiceByTypeAndSpecies}',
        data: {
          "serviceTypeId": _serviceType,
          "speciesId": _speciesIds,
        },
      );
      final servicesResponse = response.data["list"];
      servicesResponse.forEach((element) {
        var service = element["serviceDto"];
        if (service["userId"] != user.userData.id) {
          final petServiceItem = mapJsonToEntity(service);
          petServiceItem.speciesId = element["species"][0];
          _items.add(petServiceItem);
        }
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchServicesByUser() async {
    try {
      _ownItems = [];
      final response = await this
          ._dio
          .get('${Endpoints.fetchServiceByUser}/${user.userData.id}');
      final servicesResponse = response.data["list"];
      servicesResponse.forEach((element) {
        var service = element["serviceDto"];
        final petServiceItem = mapJsonToEntity(service);
        petServiceItem.speciesId = element["species"][0];
        _ownItems.add(petServiceItem);
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> save(PetServiceItem petService, int speciesId) async {
    try {
      final response = await _dio.post(
        Endpoints.saveService,
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
          "species": [speciesId],
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

  PetServiceItem mapJsonToEntity(dynamic json) {
    return PetServiceItem(
      id: json["id"],
      userId: json["userId"],
      category: json["serviceTypeId"],
      price: json["price"],
      address: json["address"],
      title: json["title"],
      description: json["description"],
      email: json["mailContact"],
      createdAt: json["createdAt"],
      createdBy: user.userData.id,
      modifiedAt: json["modifiedAt"],
      modifiedBy: user.userData.id,
    );
  }
}
