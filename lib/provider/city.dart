import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
      final cityResponse = response.data["dto"];
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
}
