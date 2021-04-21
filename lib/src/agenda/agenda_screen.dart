import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class AgendaScreen extends StatefulWidget {
  static const routeName = "/agenda";

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  var _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda"),
      ),
      body: TableCalendar(
        calendarController: _calendarController,
      ),
    );
  }
}
