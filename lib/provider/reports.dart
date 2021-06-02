import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constants/endpoints.dart';

class ReportItem {
  int id;
  int petId;
  int userId;
  String description;
  String mainStreet;
  String secondaryStreet;
  int city;
  double locationLongitude;
  double locationLatitude;
  String reference;
  String observations;
  String createdAt;
  int createdBy;
  String modifiedAt;
  int modifiedBy;
}

class Reports with ChangeNotifier {
  List<ReportItem> _reports = [];

  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));

  List<ReportItem> get reports {
    return [..._reports];
  }

  Future<void> fetchReports({
    double latitudeMin,
    double longitudeMin,
    double latitudeMax,
    double longitudeMax,
  }) async {
    final List<ReportItem> loadedReports = [];
    try {
      final response = await this._dio.get(
            '${Endpoints.lostAndFoundReports}' +
                '?latitudeMin=$latitudeMin&longitudeMin=$longitudeMin&' +
                'latitudeMax=$latitudeMax&longitudeMax=$longitudeMax',
          );
      final reportResponse = response.data["list"];
      print(response);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /*
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
  */
}
