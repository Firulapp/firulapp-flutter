import 'package:flutter/material.dart';

import './components/medical_record_item.dart';

class MedicalRecordsScreen extends StatelessWidget {
  static const routeName = "/medical_records";

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
            onPressed: () => print("poopoo"),
          ),
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MedicalRecordItem();
              },
              itemCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}
