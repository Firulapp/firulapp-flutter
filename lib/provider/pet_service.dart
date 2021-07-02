import 'package:dio/dio.dart';
import 'package:firulapp/constants/endpoints.dart';
import 'package:firulapp/provider/species.dart';
import 'package:firulapp/provider/user.dart';
import 'package:flutter/foundation.dart';

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

  Future<void> save(PetServiceItem petService) async {
    try {
      final response = await _dio.post(
        Endpoints.saveMedicalRecord,
        data: {
          "serviceDto": {
            "id": petService.id,
            "userId": user.userData.id,
            "serviceTypeId": petService.category,
            "title": petService.title,
            "description": petService.description,
            "price": petService.price,
            "createdAt": petService.createdAt,
            "createdBy": user.userData.id,
            "modifiedAt": petService.createdAt,
            "modifiedBy": user.userData.id,
          },
          "species": _speciesIds
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
}

class CategoryItem {
  final String id;
  final String title;
  final String icon;

  const CategoryItem({this.id, this.title, this.icon});

  static const DUMMY_CATEGORIES = const [
    CategoryItem(
      id: '1',
      title: 'Baño',
      icon: 'assets/icons/dog-shower.svg',
    ),
    CategoryItem(
      id: '2',
      title: 'Paseo',
      icon: 'assets/icons/dog-walking.svg',
    ),
    CategoryItem(
      id: '3',
      title: 'Tienda',
      icon: 'assets/icons/pet-shop.svg',
    ),
    CategoryItem(
      id: '4',
      title: 'Entrenamiento',
      icon: 'assets/icons/dog-train.svg',
    ),
    CategoryItem(
      id: '5',
      title: 'Veterinaria',
      icon: 'assets/icons/vet.svg',
    ),
    CategoryItem(
      id: '0',
      title: 'Mis Servicios',
      icon: 'assets/icons/businessman.svg',
    ),
  ];
}
