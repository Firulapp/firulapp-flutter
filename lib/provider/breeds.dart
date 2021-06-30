import 'package:firulapp/components/dropdown/listtile_item.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../constants/endpoints.dart';

class BreedsItem {
  final int id;
  final String name;
  final String description;
  final bool status;

  BreedsItem({
    this.id,
    this.name,
    this.description,
    this.status,
  });

  factory BreedsItem.fromJson(Map<String, dynamic> json) {
    return BreedsItem(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        status: json['status']);
  }
}

class Breeds with ChangeNotifier {
  List<BreedsItem> _items = [];

  List<BreedsItem> get items => [..._items];

  List<BreedsItem> get enableSpecie {
    return _items.where((e) => e.status).toList();
  }

  BreedsItem getLocalBreedsItemById(int id) {
    return enableSpecie.firstWhere(
      (breed) => breed.id == id,
      orElse: () => null,
    );
  }

  set items(List<BreedsItem> list) {
    _items = list;
    notifyListeners();
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));

  Future<void> getBreeds(int idSpecies) async {
    var url = "";
    if (idSpecies != null) {
      url = "${Endpoints.breeds}/$idSpecies";
    } else {
      url = "${Endpoints.breeds}";
    }
    try {
      final response = await _dio.get("$url");
      final List<BreedsItem> loadedBreeds = [];
      response.data['list'].forEach((species) {
        loadedBreeds.add(BreedsItem(
            id: species['id'],
            name: species['name'],
            description: species['description'],
            status: species['status']));
      });
      _items = loadedBreeds;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  List<ListTileItem> toGenericFormItem() {
    List<ListTileItem> genericItems = [];
    _items.forEach((element) {
      genericItems.add(ListTileItem(element.id, element.name));
    });
    return genericItems;
  }
}
