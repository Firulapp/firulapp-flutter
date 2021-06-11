import 'package:dio/dio.dart';
import 'package:firulapp/provider/pets.dart';
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
  String reportType; // MASCOTA_PERDIDA, MASCOTA_ENCONTRADA
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
    this.reportType,
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

class FoundPetReport {
  ReportItem report;
  PetItem pet;

  FoundPetReport({
    this.report,
    this.pet,
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
    try {
      _items = [];
      final response = await this._dio.get(
            '${Endpoints.lostAndFoundReports}' +
                '?latitudeMin=$latitudeMin&longitudeMin=$longitudeMin&' +
                'latitudeMax=$latitudeMax&longitudeMax=$longitudeMax',
          );
      final reportResponse = response.data["list"];
      reportResponse.forEach((report) {
        _items.add(
          mapJsonToEntity(report),
        );
      });
      notifyListeners();
      print(response);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> saveLostReport(ReportItem report) async {
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
          "reportType": "MASCOTA_ENCONTRADA",
          "locationLongitude": report.locationLongitude,
          "locationLatitude": report.locationLatitude,
          "reference": "",
          "observations": "",
          "createdAt": report.createdAt,
          "createdBy": user.userData.id,
          "modifiedAt": report.modifiedAt,
          "modifiedBy": user.userData.id,
        },
      );
      fetchReports(
        latitudeMax: 250.0,
        latitudeMin: -250.0,
        longitudeMin: -250.0,
        longitudeMax: 250.0,
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
      reportType: json["reportType"],
      userId: user.userData.id,
      createdAt: json["createdAt"],
      createdBy: user.userData.id,
      modifiedAt: json["modifiedAt"],
      modifiedBy: json["modifiedBy"],
    );
  }

  Future<void> saveFoundReport(FoundPetReport foundReport) async {
    try {
      await _dio.post(
        Endpoints.reportFoundPet,
        data: {
          "report": {
            "id": null,
            "userId": user.userData.id,
            "description": foundReport.report.description,
            "mainStreet": foundReport.report.mainStreet,
            "secondaryStreet": foundReport.report.secondaryStreet,
            "city": foundReport.report.city,
            "status": "ABIERTO",
            "reportType": "MASCOTA_ENCONTRADA",
            "locationLongitude": foundReport.report.locationLongitude,
            "locationLatitude": foundReport.report.locationLatitude,
            "reference": "",
            "observations": "",
            "createdAt": foundReport.report.createdAt,
            "createdBy": user.userData.id,
            "modifiedAt": foundReport.report.modifiedAt,
            "modifiedBy": user.userData.id,
          },
          "pet": {
            "id": null,
            "userId": user.userData.id,
            "speciesId": foundReport.pet.speciesId,
            "breedId": foundReport.pet.breedId,
            "name": foundReport.pet.name,
            "birthDate": null,
            "age": null,
            "petSize": foundReport.pet.petSize,
            "city": null,
            "address": null,
            "primaryColor": foundReport.pet.primaryColor,
            "secondaryColor": foundReport.pet.secondaryColor,
            "status": "ENCONTRADA",
            "picture": foundReport.pet.picture,
            "description": foundReport.pet.description,
            "createdAt": foundReport.pet.createdAt != null
                ? foundReport.pet.createdAt
                : null,
            "createdBy": user.userData.id,
            "modifiedAt": foundReport.pet.createdAt != null
                ? foundReport.pet.createdAt
                : null,
            "modifiedBy": user.userData.id,
          },
        },
      );
      fetchReports(
        latitudeMax: 250.0,
        latitudeMin: -250.0,
        longitudeMin: -250.0,
        longitudeMax: 250.0,
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> delete(ReportItem report) async {
    try {
      await _dio.post(
        Endpoints.closeReport,
        data: {
          "id": report.id,
          "userId": user.userData.id,
          "petId": report.petId,
          "description": report.description,
          "mainStreet": report.mainStreet,
          "secondaryStreet": report.secondaryStreet,
          "city": report.city,
          "status": "ABIERTO",
          "reportType": report.reportType,
          "locationLongitude": report.locationLongitude,
          "locationLatitude": report.locationLatitude,
          "reference": "",
          "observations": "",
          "createdAt": report.createdAt,
          "createdBy": user.userData.id,
          "modifiedAt": report.modifiedAt,
          "modifiedBy": user.userData.id,
        },
      );
      fetchReports(
        latitudeMax: 250.0,
        latitudeMin: -250.0,
        longitudeMin: -250.0,
        longitudeMax: 250.0,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
