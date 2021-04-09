import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../constants/endpoints.dart';

class MedicalRecordItem {
  final int id;
  final int petId;
  final String veterinary;
  final String treatment;
  final String observations;
  final String diagnostic;
  final bool treatmentReminder;
  final int petWeight;
  final int petHeight;
  final String consultedAt;
  final String createdAt;
  final int createdBy;
  final String modifiedAt;
  final int modifiedBy;

  MedicalRecordItem({
    this.id,
    this.petId,
    this.veterinary,
    this.treatment,
    this.observations,
    this.diagnostic,
    this.treatmentReminder,
    this.petWeight,
    this.petHeight,
    this.consultedAt,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
  });
}

class MedicalRecord with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  List<MedicalRecordItem> _items = [];

  List<MedicalRecordItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  Future<void> fetchMedicalRecords(int petId) async {
    try {
      final response = await this._dio.get('${Endpoints.medicalRecord}/$petId');
      final medicalRecords = response.data["list"];
      medicalRecords.forEach((medicalRecord) {
        _items.add(MedicalRecordItem(
          id: medicalRecord["id"],
          petId: medicalRecord["petId"],
          veterinary: medicalRecord["vet"],
          treatment: medicalRecord["treatment"],
          observations: medicalRecord["observations"],
          diagnostic: medicalRecord["diagnostic"],
          treatmentReminder: medicalRecord["treatmentReminder"],
          petWeight: medicalRecord["petWeight"],
          petHeight: medicalRecord["petHeight"],
          consultedAt: medicalRecord["consultedAt"],
          createdAt: medicalRecord["createdAt"],
          createdBy: medicalRecord["createdBy"],
          modifiedAt: medicalRecord["modifiedAt"],
          modifiedBy: medicalRecord["modifiedBy"],
        ));
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addMedicalRecord(MedicalRecordItem medialRecord) async {
    try {
      await _dio.post(
        Endpoints.saveMedicalRecord,
        data: medialRecord,
      );
      _items.add(medialRecord);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
