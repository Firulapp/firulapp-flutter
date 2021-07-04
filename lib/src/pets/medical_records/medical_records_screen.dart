import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/dtos/event_item.dart';
import '../../../provider/pets.dart';
import '../../../constants/constants.dart';
import '../../../provider/medical_record.dart' as medProvider;
import '../../../size_config.dart';
import './components/medical_record_item.dart';
import './medical_record_form_screen.dart';

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
    final SizeConfig sizeConfig = SizeConfig();
    final pet = ModalRoute.of(context).settings.arguments as PetItem;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ficha Médica de ${pet.name}"),
      ),
      body: Column(
        children: [
          TextButton.icon(
            label: Text(
              'Agregar Consulta Médica',
              style: const TextStyle(fontSize: 20.0),
            ),
            icon: Icon(
              Icons.add,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              NewMedicalRecordScreen.routeName,
              arguments: EventItem(
                date: DateTime.now(),
              ),
            ),
          ),
          Flexible(
            child: Container(
              color: Constants.lightBackgroundColor,
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
                        builder: (ctx, medicalRecord, child) {
                          if (medicalRecord.itemCount != 0) {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return MedicalRecordItem(
                                  medicalRecord.items[index],
                                );
                              },
                              itemCount: medicalRecord.itemCount,
                            );
                          } else {
                            return Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/empty.png",
                                        ),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Sin Consultas Médicas :(',
                                    style: TextStyle(
                                      fontSize: sizeConfig.hp(4),
                                      color: Constants.kPrimaryColor,
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        },
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
