import 'package:firulapp/provider/activity.dart';
import 'package:firulapp/provider/agenda.dart';
import 'package:firulapp/provider/medical_record.dart';
import 'package:firulapp/provider/pets.dart';
import 'package:firulapp/provider/vaccination_record.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

import '../pets/vaccionation_records/vaccination_records_form_screen.dart';
import '../../constants/constants.dart';
import './components/event_item.dart';
import '../pets/medical_records/medical_record_form_screen.dart';
import '../pets/activity/activity_form_screen.dart';
import 'components/agenda_event_item.dart';
import '../pets/utils/pet_option.dart';
import 'package:firulapp/components/dtos/event_item.dart' as eventDTO;

class AgendaScreen extends StatefulWidget {
  static const routeName = "/agenda";

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  var _calendarController;
  List<dynamic> _selectedEvents = [];
  Future _petsFuture;
  Future _eventsFuture;

  Future _obtainEventsFuture() {
    return Provider.of<Agenda>(context, listen: false).fetchEvents();
  }

  @override
  void initState() {
    super.initState();
    _petsFuture = Provider.of<Pets>(context, listen: false).fetchPetList();
    _eventsFuture = _obtainEventsFuture();
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                _showPetListDialog(_calendarController.selectedDay),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.kPrimaryColor,
        child: Icon(Icons.add),
        onPressed: () => _showPetListDialog(_calendarController.selectedDay),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FutureBuilder(
            future: _eventsFuture,
            builder: (context, snapshot) {
              return Consumer<Agenda>(
                builder: (context, agenda, _) => TableCalendar(
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Mes',
                    CalendarFormat.week: 'Semana',
                    CalendarFormat.twoWeeks: '2 Semanas',
                  },
                  events: agenda.items,
                  initialCalendarFormat: CalendarFormat.month,
                  calendarController: _calendarController,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    canEventMarkersOverflow: true,
                    todayColor: Constants.kPrimaryLightColor,
                    selectedColor: Constants.kPrimaryColor,
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
              );
            },
          ),
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return AgendaEventItem(
                  event: _selectedEvents[index],
                  onTap: (pet) async {
                    if (_selectedEvents[index]["petVaccinationRecordId"] !=
                        null) {
                      Provider.of<VaccinationRecord>(
                        context,
                        listen: false,
                      ).setPetItem(pet);
                      await Provider.of<VaccinationRecord>(context,
                              listen: false)
                          .fetchVaccinationRecords();
                      await Navigator.of(context).pushNamed(
                        NewVaccinationRecordScreen.routeName,
                        arguments: eventDTO.EventItem(
                          eventId: _selectedEvents[index]
                              ["petVaccinationRecordId"],
                          date: DateTime.now(),
                        ),
                      );
                    } else if (_selectedEvents[index]["activityId"] != null) {
                      Provider.of<Activity>(
                        context,
                        listen: false,
                      ).setPetItem(pet);
                      await Provider.of<Activity>(context, listen: false)
                          .fetchActivities();
                      await Navigator.of(context).pushNamed(
                        ActivityFormScreen.routeName,
                        arguments: eventDTO.EventItem(
                          eventId: _selectedEvents[index]["activityId"],
                          date: DateTime.now(),
                        ),
                      );
                    } else {
                      Provider.of<MedicalRecord>(
                        context,
                        listen: false,
                      ).setPetItem(pet);
                      await Provider.of<MedicalRecord>(context, listen: false)
                          .fetchMedicalRecords();
                      await Navigator.of(context).pushNamed(
                        NewMedicalRecordScreen.routeName,
                        arguments: eventDTO.EventItem(
                          eventId: _selectedEvents[index]["petMedicalRecordId"],
                          date: DateTime.now(),
                        ),
                      );
                    }
                  },
                );
              },
              itemCount: _selectedEvents.length,
            ),
          ),
        ],
      ),
    );
  }

  _showAddDialog(PetItem petSelected, DateTime selectedDate) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        title: Text(
          "Elegir Evento",
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              children: [
                EventItem(
                  title: "Consulta Médica",
                  icon: "assets/icons/medical-check.svg",
                  pet: petSelected,
                  onTap: (petSelected) {
                    Provider.of<MedicalRecord>(
                      context,
                      listen: false,
                    ).setPetItem(petSelected);
                    Navigator.pushNamed(
                      context,
                      NewMedicalRecordScreen.routeName,
                      arguments: eventDTO.EventItem(
                        date: selectedDate,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                EventItem(
                  title: "Vacuna",
                  icon: "assets/icons/syringe.svg",
                  pet: petSelected,
                  onTap: (pet) {
                    Provider.of<VaccinationRecord>(
                      context,
                      listen: false,
                    ).setPetItem(pet);
                    Navigator.pushNamed(
                      context,
                      NewVaccinationRecordScreen.routeName,
                      arguments: eventDTO.EventItem(
                        date: selectedDate,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                EventItem(
                  title: "Actividad",
                  icon: "assets/icons/play-with-pet.svg",
                  pet: petSelected,
                  onTap: (pet) {
                    Provider.of<Activity>(
                      context,
                      listen: false,
                    ).setPetItem(pet);
                    Navigator.pushNamed(
                      context,
                      ActivityFormScreen.routeName,
                      arguments: eventDTO.EventItem(
                        date: selectedDate,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPetListDialog(DateTime selectedDate) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        title: Text(
          "Elegir Mascota",
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 400,
          child: FutureBuilder(
            future: _petsFuture,
            builder: (_, dataSnapshot) {
              return Consumer<Pets>(
                builder: (context, providerData, _) => SingleChildScrollView(
                  child: Column(
                    children: providerData.items
                        .map(
                          (pet) => PetOption(
                            petItem: pet,
                            onTap: (petSelected) {
                              _showAddDialog(petSelected, selectedDate);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
