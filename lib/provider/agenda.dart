import 'package:flutter/material.dart';

class Agenda with ChangeNotifier {
  final int id;
  final String title;
  final String description;

  Agenda({
    this.id,
    this.title,
    this.description,
  });
}
