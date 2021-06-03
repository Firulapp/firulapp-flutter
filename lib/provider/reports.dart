import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constants/endpoints.dart';
import './user.dart';

class GeographicPoints {
  final String longitude;
  final String latitude;

  GeographicPoints(this.longitude, this.latitude);
}

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
  String locationLongitude;
  String locationLatitude;
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
  List<ReportItem> _items = [];
  final User user;

  Reports(this.user, _reports);

  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));

  List<ReportItem> get items {
    return [..._items];
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

  Future<void> saveReport(ReportItem report) async {
    try {
      await _dio.post(
        Endpoints.reportLostPet,
        data: {
          "id": null,
          "petId": report.petId,
          "userId": user.userData.id,
          "description": report.description,
          "mainStreet": report.mainStreet,
          "secondaryStreet": report.secondaryStreet,
          "city": report.city,
          "status": "ABIERTO",
          "type": "MASCOTA_PERDIDA",
          "locationLongitude": report.locationLongitude,
          "locationLatitude": report.locationLatitude,
          "reference": report.reference,
          "observations": report.observations,
          "createdAt": report.createdAt,
          "createdBy": user.userData.id,
          "modifiedAt": report.modifiedAt,
          "modifiedBy": user.userData.id,
        },
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  ReportItem mapJsonToEntity(dynamic json) {
    return ReportItem(
      id: json["id"],
      petId: json["petId"],
      city: json["city"],
      description: json["description"],
      locationLatitude: json["locationLatitude"],
      locationLongitude: json["locationLongitude"],
      mainStreet: json["mainStreet"],
      observations: json["observations"],
      reference: json["reference"],
      secondaryStreet: json["secondaryStreet"],
      status: json["status"],
      type: json["type"],
      userId: user.userData.id,
      createdAt: json["createdAt"],
      createdBy: user.userData.id,
      modifiedAt: json["modifiedAt"],
      modifiedBy: json["modifiedBy"],
    );
  }
}
