import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'pets.dart';
import '../constants/endpoints.dart';
import 'user.dart';

class VaccinationRecordItem {
  int id;
  int petId;
  String veterinary;
  String vaccine;
  String observation;
  bool reminders;
  String vaccinationDate;
  String createdAt;
  int createdBy;
  String modifiedAt;
  int modifiedBy;

  VaccinationRecordItem({
    this.id,
    this.petId,
    this.veterinary,
    this.vaccine,
    this.observation,
    this.reminders,
    this.vaccinationDate,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
  });
}

class VaccinationRecord with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  PetItem _petItem;
  final User user;
  List<VaccinationRecordItem> _items = [];

  VaccinationRecord(this.user, _items);

  List<VaccinationRecordItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  void setPetItem(PetItem petItem) {
    _petItem = petItem;
  }

  VaccinationRecordItem getLocalVaccinationRecordById(int id) {
    return _items.firstWhere((vax) => vax.id == id);
  }

  Future<void> fetchVaccinationRecords() async {
    try {
      _items = [];
      final response =
          await this._dio.get('${Endpoints.vaccinationRecord}/${_petItem.id}');
      final vaccinationRecords = response.data["list"];
      vaccinationRecords.forEach((vaccinationRecord) {
        _items.add(
          mapJsonToEntity(vaccinationRecord),
        );
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  VaccinationRecordItem mapJsonToEntity(dynamic json) {
    return VaccinationRecordItem(
      id: json["id"],
      petId: json["petId"],
      veterinary: json["vet"],
      vaccine: json["vaccine"],
      observation: json["observation"],
      reminders: json["reminders"],
      vaccinationDate: json["vaccinationDate"],
      createdAt: json["createdAt"],
      createdBy: user.userData.id,
      modifiedAt: json["modifiedAt"],
      modifiedBy: json["modifiedBy"],
    );
  }

  Future<void> save(VaccinationRecordItem vaccine) async {
    try {
      final response = await _dio.post(
        Endpoints.saveVaccinationRecord,
        data: {
          "id": vaccine.id,
          "petId": _petItem.id,
          "vet": vaccine.veterinary,
          "observation": vaccine.observation,
          "vaccine": vaccine.vaccine,
          "vaccinationDate": vaccine.vaccinationDate,
          "reminders" : vaccine.reminders,
          "createdAt": vaccine.createdAt,
          "createdBy": user.userData.id,
          "modifiedAt": vaccine.modifiedAt,
          "modifiedBy": vaccine.modifiedBy,
        },
      );
      final vaccineResponse = response.data["dto"];
      if (_items.contains(vaccine)) {
        _items[_items.indexWhere((element) => element.id == vaccine.id)] =
            mapJsonToEntity(vaccineResponse);
      } else {
        _items.add(mapJsonToEntity(vaccineResponse));
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> delete(VaccinationRecordItem vaccine) async {
    try {
      await _dio.delete(
        Endpoints.deleteVaccinationRecord,
        data: {
          "id": vaccine.id,
          "petId": _petItem.id,
          "vet": vaccine.veterinary,
          "observation": vaccine.observation,
          "vaccine": vaccine.vaccine,
          "vaccinationDate": vaccine.vaccinationDate,
          "reminders" : vaccine.reminders,
          "createdAt": vaccine.createdAt,
          "createdBy": user.userData.id,
          "modifiedAt": vaccine.modifiedAt,
          "modifiedBy": vaccine.modifiedBy,
        },
      );
      _items.remove(
        vaccine,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
