import 'package:flutter/material.dart';

import './components/medical_record_item.dart';
import 'medical_record_form_screen.dart';

class MedicalRecordsScreen extends StatelessWidget {
  static const routeName = "/medical_records";

  final List<Map> _medialRecords = const [
    {
      "date": "10/01/2021",
      "organization": 'Dr. Brown',
      "diagnostic": 'Dolor de pancita',
    },
    {
      "date": "15/01/2021",
      "organization": 'Dr. Brown',
      "diagnostic": 'Infección en el oído',
    },
    {
      "date": "18/01/2021",
      "organization": 'Dr. Brown',
      "diagnostic": 'Quemaduras de segundo grado en la pata frontal derecha',
    },
    {
      "date": "25/01/2021",
      "organization": 'Dr. Brown',
      "diagnostic": 'Constipación casi fatal',
    },
    {
      "date": "30/01/2021",
      "organization": 'Dr. Brown',
      "diagnostic": 'Depresión',
    },
    {
      "date": "10/02/2021",
      "organization": 'Dr. Brown',
      "diagnostic": 'Muerte',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fichas Médicas"),
      ),
      body: Column(
        children: [
          TextButton.icon(
            label: Text(
              'Agregar Ficha Médica',
              style: const TextStyle(fontSize: 20.0),
            ),
            icon: Icon(
              Icons.add,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, NewMedicalRecordScreen.routeName),
          ),
          Flexible(
            child: Container(
              color: Color(0XFFFFFAF6),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return MedicalRecordItem(_medialRecords[index]);
                },
                itemCount: _medialRecords.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
