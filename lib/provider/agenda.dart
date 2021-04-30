import 'package:dio/dio.dart';
import 'package:firulapp/constants/endpoints.dart';
import 'package:firulapp/provider/pets.dart';
import 'package:firulapp/provider/user.dart';
import 'package:flutter/material.dart';

class AgendaItem {
  final int id;
  final int userId;
  final int activityId;
  final int petId;
  final int petMedicalRecordId;
  final int petVaccinationRecordId;
  final String details;
  final String activityDate;
  final String activityTime;

  AgendaItem({
    this.id,
    this.userId,
    this.activityId,
    this.petId,
    this.petMedicalRecordId,
    this.petVaccinationRecordId,
    this.details,
    this.activityDate,
    this.activityTime,
  });
}

class Agenda with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  PetItem _petItem;
  final User user;
  List<AgendaItem> _items = [];

  Agenda(this.user, _items);

  List<AgendaItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  void setPetItem(PetItem petItem) {
    _petItem = petItem;
  }
}
