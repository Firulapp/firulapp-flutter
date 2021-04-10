import 'package:firulapp/provider/pets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../provider/medical_record.dart' as medProvider;
import './components/medical_record_item.dart';
import 'medical_record_form_screen.dart';

class MedicalRecordsScreen extends StatefulWidget {
  static const routeName = "/medical_records";

  @override
  _MedicalRecordsScreenState createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  Future _medicalRecordsFuture;
  Future _obtainMedicalRecordsFuturee() {
    return Provider.of<medProvider.MedicalRecord>(context, listen: false)
        .fetchMedicalRecords();
  }

  @override
  void initState() {
    _medicalRecordsFuture = _obtainMedicalRecordsFuturee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pet = ModalRoute.of(context).settings.arguments as PetItem;
    return Scaffold(
      appBar: AppBar(
        title: Text("Fichas Médicas de ${pet.name}"),
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
              color: lightBackgroundColor,
              child: FutureBuilder(
                future: _medicalRecordsFuture,
                builder: (_, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (dataSnapshot.error != null) {
                      return Center(
                        child: Text('Algo salio mal'),
                      );
                    } else {
                      return Consumer<medProvider.MedicalRecord>(
                        builder: (ctx, medicalRecord, child) =>
                            ListView.builder(
                          itemBuilder: (context, index) {
                            return MedicalRecordItem(
                              medicalRecord.items[index],
                            );
                          },
                          itemCount: medicalRecord.itemCount,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
