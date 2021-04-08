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

  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));

  Future<void> getBreeds() async {
    try {
      final response = await _dio.get(Endpoints.breeds);
      final List<BreedsItem> loadedBreeds = [];
      if (_items.isEmpty) {
        response.data['list'].forEach((species) {
          loadedBreeds.add(BreedsItem(
              id: species['id'],
              name: species['name'],
              description: species['description'],
              status: species['status']));
        });
        _items = loadedBreeds;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }
}
