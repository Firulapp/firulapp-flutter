import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../components/dropdown/listtile_item.dart';
import '../constants/endpoints.dart';

class CityItem {
  final int id;
  final String name;

  CityItem({this.id, this.name});
}

class City with ChangeNotifier {
  List<CityItem> _cities = [];

  List<CityItem> get cities {
    return [..._cities];
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));

  Future<void> fetchCities() async {
    final List<CityItem> loadedCities = [];
    try {
      final response = await this._dio.get(
            Endpoints.city,
          );
      final cityResponse = response.data["list"];
      cityResponse.forEach((cityData) {
        loadedCities.add(CityItem(
          id: cityData["id"],
          name: cityData["name"],
        ));
      });
      _cities = loadedCities.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  CityItem getLocalCityItemById(int id) {
    return cities.firstWhere(
      (breed) => breed.id == id,
      orElse: () => null,
    );
  }

  List<ListTileItem> toGenericFormItem() {
    List<ListTileItem> genericItems = [];
    cities.forEach((element) {
      genericItems.add(ListTileItem(element.id, element.name));
    });
    return genericItems;
  }
}
