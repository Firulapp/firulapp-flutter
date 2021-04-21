import 'package:firulapp/constants/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

import './components/event_item.dart';
import '../medical_records/medical_record_form_screen.dart';

class AgendaScreen extends StatefulWidget {
  static const routeName = "/agenda";

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  var _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TableCalendar(
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mes',
              CalendarFormat.week: 'Semana',
              CalendarFormat.twoWeeks: '2 Semanas',
            },
            events: _events,
            initialCalendarFormat: CalendarFormat.month,
            calendarController: _calendarController,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              canEventMarkersOverflow: true,
              todayColor: kPrimaryLightColor,
              selectedColor: kPrimaryColor,
              todayStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onDaySelected: (date, events, holidays) {
              setState(() {
                _selectedEvents = events;
              });
            },
          ),
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: SvgPicture.asset(
                        "assets/icons/medical-check.svg",
                        color: kPrimaryColor,
                        width: 35,
                      ),
                      title: Text(_selectedEvents[index].title),
                      subtitle: Text(_selectedEvents[index].description),
                    ),
                  ),
                );
              },
              itemCount: _selectedEvents.length,
            ),
          ),
        ],
      ),
    );
  }

  _showAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Elegir Evento",
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 400,
          child: Column(
            children: [
              EventItem(
                "Consulta Médica",
                "assets/icons/medical-check.svg",
                NewMedicalRecordScreen.routeName,
              ),
              EventItem(
                "Vacuna",
                "assets/icons/syringe.svg",
                NewMedicalRecordScreen.routeName,
              ),
              EventItem(
                "Actividad",
                "assets/icons/play-with-pet.svg",
                NewMedicalRecordScreen.routeName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Agenda {
  final int id;
  final String title;
  final String description;

  Agenda({
    this.id,
    this.title,
    this.description,
  });
}
