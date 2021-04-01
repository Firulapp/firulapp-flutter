import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewMedicalRecordScreen extends StatefulWidget {
  static const routeName = "/new_medical_records";
  @override
  _NewMedicalRecordScreenState createState() => _NewMedicalRecordScreenState();
}

class _NewMedicalRecordScreenState extends State<NewMedicalRecordScreen> {
  DateTime _medicalRecordDate;
  final df = new DateFormat('dd/MM/yyyy');

  void _showdatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((dateSelected) {
      if (dateSelected != null) {
        setState(() {
          _medicalRecordDate = dateSelected;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Ficha Médica"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    df.format(_medicalRecordDate),
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.calendar_today_outlined),
                      onPressed: _showdatePicker),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
