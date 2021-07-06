import 'package:dio/dio.dart';
import 'package:firulapp/constants/endpoints.dart';
import 'package:firulapp/provider/user.dart';
import 'package:flutter/material.dart';

/*
* Estructura que el backend responde, no se usa, porque el calendario solo
* funciona con tipo de dato 'dynamic', se deja para futuro fix
*/
class AgendaItem {
  final int userId;
  final int clientId;
  final int petId;
  final int activityId;
  final int petMedicalRecordId;
  final int petVaccinationRecordId;
  final int serviceId;
  final int appointmentId;
  final String details;
  final String activityDate;
  final String activityTime;
  //TODO: atributo status para cambiar el color del widget appointment
  AgendaItem({
    this.userId,
    this.clientId,
    this.petId,
    this.activityId,
    this.petMedicalRecordId,
    this.petVaccinationRecordId,
    this.serviceId,
    this.appointmentId,
    this.details,
    this.activityDate,
    this.activityTime,
  });
}

class Agenda with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  final User user;
  Map<DateTime, List<dynamic>> _items = {};

  Agenda(this.user, _items);

  Map<DateTime, List<dynamic>> get items {
    return _items;
  }

  int get itemCount {
    return _items.length;
  }

  /*
  * _items es una lista ordenada de AgendaItem, recorremos la lista y 
  * creamos un Map por fecha
  */
  Future<void> fetchEvents() async {
    List<dynamic> agendaItems = [];
    _items = {};
    try {
      final response =
          await this._dio.get('${Endpoints.userAgenda}/${user.session.userId}');
      final events = response.data["list"];
      if (events.length == 0) {
        return;
      }
      var auxDate = events[0]["activityDate"];
      var firstTime = true;
      events.forEach((item) {
        if (auxDate != item["activityDate"] && !firstTime) {
          _items.addAll({
            DateTime.parse(auxDate): agendaItems,
          });
          agendaItems = [];
          auxDate = item["activityDate"];
        }
        agendaItems.add(item);
        firstTime = false;
      });
      _items.addAll({
        DateTime.parse(auxDate): agendaItems,
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
