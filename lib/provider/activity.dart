import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import './pets.dart';
import '../constants/endpoints.dart';
import 'user.dart';

class ActivityItem {
  final int id;
  final int petId;
  final String activityDate;
  final String activityTime;
  final String detail;
  final String createdAt;
  final int createdBy;
  final String modifiedAt;
  final int modifiedBy;

  ActivityItem({
    this.id,
    this.petId,
    this.activityDate,
    this.activityTime,
    this.detail,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
  });
}

class Activty with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
  List<ActivityItem> _items = [];
  PetItem _petItem;
  final User user;

  Activty(this.user, _items);

  List<ActivityItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  void setPetItem(PetItem petItem) {
    _petItem = petItem;
  }

  ActivityItem getLocalMedicalRecordById(int id) {
    return _items.firstWhere((med) => med.id == id);
  }

  Future<void> fetchActivities() async {
    try {
      _items = [];
      final response =
          await this._dio.get('${Endpoints.petActivityByPet}/${_petItem.id}');
      final activities = response.data["list"];
      activities.forEach((activity) {
        _items.add(
          mapJsonToEntity(activity),
        );
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> saveActivity(ActivityItem activity) async {
    try {
      final response = await _dio.post(
        Endpoints.savePetActivity,
        data: {
          "id": activity.id,
          "petId": _petItem.id,
          "activityDate": activity.activityDate,
          "activityTime": activity.activityTime,
          "detail": activity.detail,
          "createdAt": activity.createdAt,
          "createdBy": user.userData.id,
          "modifiedAt": activity.createdAt,
          "modifiedBy": user.userData.id,
        },
      );
      final activityResponse = response.data["dto"];
      if (_items.contains(activity)) {
        _items[_items.indexWhere((element) => element.id == activity.id)] =
            mapJsonToEntity(activityResponse);
      } else {
        _items.add(mapJsonToEntity(activityResponse));
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> delete(ActivityItem activity) async {
    try {
      await _dio.delete(
        Endpoints.deletePetActivity,
        data: {
          "id": activity.id,
          "petId": _petItem.id,
          "activityDate": activity.activityDate,
          "activityTime": activity.activityTime,
          "detail": activity.detail,
          "createdAt": activity.createdAt,
          "createdBy": user.userData.id,
          "modifiedAt": activity.createdAt,
          "modifiedBy": user.userData.id,
        },
      );
      _items.remove(
        activity,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  ActivityItem mapJsonToEntity(dynamic json) {
    return ActivityItem(
      id: json["id"],
      petId: json["petId"],
      activityDate: json["activityDate"],
      activityTime: json["activityTime"],
      detail: json["detail"],
      createdAt: json["createdAt"],
      createdBy: user.userData.id,
      modifiedAt: json["modifiedAt"],
      modifiedBy: user.userData.id,
    );
  }
}
