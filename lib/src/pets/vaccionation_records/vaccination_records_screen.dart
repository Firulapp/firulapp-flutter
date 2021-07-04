import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/dtos/event_item.dart';
import './vaccination_records_form_screen.dart';
import '../../../provider/pets.dart';
import '../../../constants/constants.dart';
import '../../../provider/vaccination_record.dart' as vaxProvider;
import '../../../size_config.dart';
import './components/vaccination_record_item.dart';

class VaccinationRecordsScreen extends StatefulWidget {
  static const routeName = "/vaccination_records";

  @override
  _VaccinationRecordsScreenState createState() =>
      _VaccinationRecordsScreenState();
}

class _VaccinationRecordsScreenState extends State<VaccinationRecordsScreen> {
  Future _vaccinationRecordsFuture;
  Future _obtainVaccinationRecordsFuturee() {
    return Provider.of<vaxProvider.VaccinationRecord>(context, listen: false)
        .fetchVaccinationRecords();
  }

  @override
  void initState() {
    _vaccinationRecordsFuture = _obtainVaccinationRecordsFuturee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    final pet = ModalRoute.of(context).settings.arguments as PetItem;
    return Scaffold(
      appBar: AppBar(
        title: Text("Libreta de Vacunación de ${pet.name}"),
      ),
      body: Column(
        children: [
          TextButton.icon(
            label: Text(
              'Agregar Libreta de Vacunación',
              style: const TextStyle(fontSize: 20.0),
            ),
            icon: Icon(
              Icons.add,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              NewVaccinationRecordScreen.routeName,
              arguments: EventItem(
                date: DateTime.now(),
              ),
            ),
          ),
          Flexible(
            child: Container(
              color: Constants.lightBackgroundColor,
              child: FutureBuilder(
                future: _vaccinationRecordsFuture,
                builder: (_, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (dataSnapshot.error != null) {
                      return Center(
                        child: Text('Algo salio mal'),
                      );
                    } else {
                      return Consumer<vaxProvider.VaccinationRecord>(
                        builder: (ctx, vaxRecord, child) {
                          if (vaxRecord.itemCount != 0) {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return VaccinationRecordItem(
                                  vaxRecord.items[index],
                                );
                              },
                              itemCount: vaxRecord.itemCount,
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
                                    'Sin Vacunas :(',
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
