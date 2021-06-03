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
  String status; //ABIERTO, CERRADO
  String type; // MASCOTA_PERDIDA, MASCOTA_ENCONTRADA
  double locationLongitude;
  double locationLatitude;
  String reference;
  String observations;
  String createdAt;
  int createdBy;
  String modifiedAt;
  int modifiedBy;

  ReportItem({
    this.id,
    this.petId,
    this.userId,
    this.description,
    this.mainStreet,
    this.secondaryStreet,
    this.city,
    this.status,
    this.type,
    this.locationLongitude,
    this.locationLatitude,
    this.reference,
    this.observations,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
  });
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

  saveReport(ReportItem report) {}
}
