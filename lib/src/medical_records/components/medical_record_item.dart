import 'package:firulapp/components/dtos/event_item.dart';
import 'package:flutter/material.dart';

import '../../../provider/medical_record.dart' as medProvider;
import '../medical_record_form_screen.dart';

class MedicalRecordItem extends StatelessWidget {
  final medProvider.MedicalRecordItem _medicalRecords;
  const MedicalRecordItem(
    this._medicalRecords, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
            Text(
              "Consulta: ${_medicalRecords.consultedAt}",
              style: Theme.of(context).textTheme.headline6,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
            Text(
              "Veterinaria: ${_medicalRecords.veterinary}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Diagnóstico: ${_medicalRecords.diagnostic}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          NewMedicalRecordScreen.routeName,
          arguments: EventItem(
            eventId: _medicalRecords.id,
            date: DateTime.now(),
          ),
        );
      },
    );
  }
}
