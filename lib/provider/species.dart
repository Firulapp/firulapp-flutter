import 'package:firulapp/components/dropdown/listtile_item.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../constants/endpoints.dart';

class SpeciesItem {
  final int id;
  final String name;
  final String description;
  final bool status;

  SpeciesItem({
    this.id,
    this.name,
    this.description,
    this.status,
  });

  factory SpeciesItem.fromJson(Map<String, dynamic> json) {
    return SpeciesItem(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        status: json['status']);
  }
}

class Species with ChangeNotifier {
  List<SpeciesItem> _items = [];

  List<SpeciesItem> get items {
    return [..._items];
  }

  List<SpeciesItem> get enableSpecie {
    return _items.where((e) => e.status).toList();
  }

  SpeciesItem getLocalSpeciesItemById(int id) {
    return enableSpecie.firstWhere(
      (spe) => spe.id == id,
      orElse: () => null,
    );
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));

  Future<void> getSpecies() async {
    try {
      final response = await _dio.get(Endpoints.species);
      final List<SpeciesItem> loadedSpecies = [];
      if (_items.isEmpty) {
        response.data['list'].forEach((species) {
          loadedSpecies.add(SpeciesItem(
              id: species['id'],
              name: species['name'],
              description: species['description'],
              status: species['status']));
        });
        _items = loadedSpecies;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  List<ListTileItem> toGenericFormItem() {
    List<ListTileItem> genericItems = [];
    items.forEach((element) {
      genericItems.add(ListTileItem(element.id, element.name));
    });
    return genericItems;
  }
}
