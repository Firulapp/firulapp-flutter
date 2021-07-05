import 'package:dio/dio.dart';
import 'package:firulapp/constants/endpoints.dart';
import 'package:firulapp/provider/user.dart';
import 'package:flutter/material.dart';

class AppointmentItem {
  final int id;
  final int serviceId;
  final int userId;
  final int petId;
  final String appointmentDate;
  final String status;
  final String createdAt;
  final int createdBy;
  final String modifiedAt;
  final int modifiedBy;

  AppointmentItem({
    this.id,
    this.serviceId,
    this.userId,
    this.petId,
    this.appointmentDate,
    this.status,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
  });
}

class Appointment with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  AppointmentItem _item = AppointmentItem();
  final User user;

  AppointmentItem get item {
    return _item;
  }

  Appointment(this.user, _items);

  Future<void> fetchAppointment(int serviceId, int petId) async {
    try {
      _item = AppointmentItem();
      final response = await this._dio.get(
          '${Endpoints.service}/$serviceId${Endpoints.user}/${user.userData.id}${Endpoints.pet}/$petId');
      final appointment = response.data["dto"];
      _item = appointment;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> saveAppointment(int serviceId, int petId) async {
    try {
      final response = await this._dio.post('${Endpoints.appointment}', data: {
        "id": item.id,
        "userId": user.userData.id,
        "serviceId": item.serviceId,
        "petId": item.petId,
        "appointmentDate": item.appointmentDate,
        "status": item.status,
        "createdAt": item.createdAt,
        "createdBy": user.userData.id,
        "modifiedAt": item.createdAt,
        "modifiedBy": user.userData.id,
      });
      final appointment = response.data["dto"];
      _item = appointment;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> cancelAppointment() async {
    try {
      final response = await this._dio.post(
          '${Endpoints.appointment}/${item.id}/${item.status}/${user.userData.id}');
      final appointment = response.data["dto"];
      _item = appointment;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  AppointmentItem mapJsonToEntity(dynamic json) {
    return AppointmentItem(
      id: json["id"],
      serviceId: json["serviceId"],
      userId: json["userId"],
      petId: json["petId"],
      appointmentDate: json["appointmentDate"],
      status: json["status"],
      createdAt: json["createdAt"],
      createdBy: json["createdBy"],
      modifiedAt: json["modifiedAt"],
      modifiedBy: json["modifiedBy"],
    );
  }
}
