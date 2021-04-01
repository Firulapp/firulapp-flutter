import 'package:flutter/material.dart';

class MedicalRecordItem extends StatelessWidget {
  final Map _medicalRecords;
  const MedicalRecordItem(
    this._medicalRecords, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _medicalRecords["date"],
            style: Theme.of(context).textTheme.headline6,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            "Veterinaria: ${_medicalRecords["organization"]}",
            style: const TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Diagnóstico: ${_medicalRecords["diagnostic"]}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
