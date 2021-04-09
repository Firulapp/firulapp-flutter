import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import './pets.dart';
import '../constants/endpoints.dart';
import 'user.dart';

class MedicalRecordItem {
  int id;
  int petId;
  String veterinary;
  String treatment;
  String observations;
  String diagnostic;
  bool treatmentReminder;
  int petWeight;
  int petHeight;
  String consultedAt;
  String createdAt;
  int createdBy;
  String modifiedAt;
  int modifiedBy;

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
  PetItem _petItem;
  final User user;
  List<MedicalRecordItem> _items = [];

  MedicalRecord(this.user, _items);

  List<MedicalRecordItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  void setPetItem(PetItem petItem) {
    _petItem = petItem;
  }

  MedicalRecordItem getLocalMedicalRecordById(int id) {
    return _items.firstWhere((med) => med.id == id);
  }

  Future<void> fetchMedicalRecords() async {
    try {
      final response =
          await this._dio.get('${Endpoints.medicalRecord}/${_petItem.id}');
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
          createdBy: user.userData.id,
          modifiedAt: medicalRecord["modifiedAt"],
          modifiedBy: medicalRecord["modifiedBy"],
        ));
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addMedicalRecord(MedicalRecordItem medicalRecord) async {
    try {
      await _dio.post(
        Endpoints.saveMedicalRecord,
        data: {
          "id": medicalRecord.id,
          "petId": _petItem.id,
          "vet": medicalRecord.veterinary,
          "treatment": medicalRecord.treatment,
          "observations": medicalRecord.observations,
          "diagnostic": medicalRecord.diagnostic,
          "treatmentReminder": medicalRecord.treatmentReminder,
          "petWeight": medicalRecord.petWeight,
          "petHeight": medicalRecord.petHeight,
          "consultedAt": medicalRecord.consultedAt,
          "createdAt": medicalRecord.createdAt,
          "createdBy": user.userData.id,
          "modifiedAt": medicalRecord.modifiedAt,
          "modifiedBy": medicalRecord.modifiedBy,
        },
      );
      _items.add(medicalRecord);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
