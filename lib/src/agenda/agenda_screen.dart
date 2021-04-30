import 'package:firulapp/provider/pets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

import '../vaccionation_records/vaccination_records_form_screen.dart';
import '../../constants/constants.dart';
import '../../provider/agenda.dart';
import './components/event_item.dart';
import '../medical_records/medical_record_form_screen.dart';
import './activity_form_screen.dart';
import 'components/pet_option.dart';

class AgendaScreen extends StatefulWidget {
  static const routeName = "/agenda";

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  var _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  Future _petsFuture;

  @override
  void initState() {
    super.initState();
    _petsFuture = Provider.of<Pets>(context, listen: false).fetchPetList();
    var date = DateTime.now();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = _events[date] == null ? [] : _events[date];
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.add),
        onPressed: _showPetListDialog,
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
                      leading: _selectedEvents[index].title == 'Vacuna'
                          ? SvgPicture.asset(
                              "assets/icons/syringe.svg",
                              color: kPrimaryColor,
                              width: 35,
                            )
                          : _selectedEvents[index].title == 'Actividad'
                              ? SvgPicture.asset(
                                  "assets/icons/play-with-pet.svg",
                                  color: kPrimaryColor,
                                  width: 35,
                                )
                              : SvgPicture.asset(
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
                  "Consulta Médica",
                  "assets/icons/medical-check.svg",
                  NewMedicalRecordScreen.routeName,
                ),
                const SizedBox(
                  height: 8,
                ),
                EventItem(
                  "Vacuna",
                  "assets/icons/syringe.svg",
                  NewVaccinationRecordScreen.routeName,
                ),
                const SizedBox(
                  height: 8,
                ),
                EventItem(
                  "Actividad",
                  "assets/icons/play-with-pet.svg",
                  ActivityFormScreen.routeName,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPetListDialog() async {
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
                          (pet) => PetOption(pet),
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
