import 'package:flutter/material.dart';

class EventItem {
  final int eventId;
  final DateTime date;
  final TimeOfDay time;

  EventItem({
    this.time,
    this.eventId,
    this.date,
  });
}
