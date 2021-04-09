import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/medical_record.dart' as medProvider;
import './components/medical_record_item.dart';
import 'medical_record_form_screen.dart';

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
            onPressed: () =>
                Navigator.pushNamed(context, NewMedicalRecordScreen.routeName),
          ),
          Flexible(
            child: Container(
              color: Color(0XFFFFFAF6),
              child: Consumer<medProvider.MedicalRecord>(
                builder: (ctx, medicalRecord, child) => ListView.builder(
                  itemBuilder: (context, index) {
                    return MedicalRecordItem(medicalRecord.items[index]);
                  },
                  itemCount: medicalRecord.itemCount,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
