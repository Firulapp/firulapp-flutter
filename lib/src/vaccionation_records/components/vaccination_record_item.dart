import 'package:firulapp/components/dtos/event_item.dart';
import 'package:flutter/material.dart';

import '../../../provider/vaccination_record.dart' as vaxProvider;
import '../vaccination_records_form_screen.dart';

class VaccinationRecordItem extends StatelessWidget {
  final vaxProvider.VaccinationRecordItem _vaxRecords;
  const VaccinationRecordItem(
    this._vaxRecords, {
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
              "Consulta: ${_vaxRecords.vaccinationDate}",
              style: Theme.of(context).textTheme.headline6,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
            Text(
              "Veterinaria: ${_vaxRecords.veterinary}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Vacuna: ${_vaxRecords.vaccine}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          NewVaccinationRecordScreen.routeName,
          arguments: EventItem(
            eventId: _vaxRecords.id,
            date: DateTime.now(),
          ),
        );
      },
    );
  }
}
