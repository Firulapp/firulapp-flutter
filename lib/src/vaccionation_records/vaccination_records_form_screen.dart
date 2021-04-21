import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../components/default_button.dart';
import '../../components/input_text.dart';
import '../../provider/vaccination_record.dart';
import '../../components/dialogs.dart';
import '../mixins/validator_mixins.dart';
import '../../size_config.dart';

class NewVaccinationRecordScreen extends StatefulWidget {
  static const routeName = "/new_vaccination_records";
  @override
  _NewVaccinationRecordScreenState createState() =>
      _NewVaccinationRecordScreenState();
}

class _NewVaccinationRecordScreenState extends State<NewVaccinationRecordScreen>
    with ValidatorMixins {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final df = new DateFormat('dd-MM-yyyy');
  VaccinationRecordItem _vaccinationRecord =
      new VaccinationRecordItem(reminders: false);
  DateTime _vaccinationRecordDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _vaccinationRecordDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _vaccinationRecordDate) {
      setState(() {
        _vaccinationRecordDate = pickedDate;
        _vaccinationRecord.vaccinationDate =
            _vaccinationRecordDate.toIso8601String();
      });
    }
  }

  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as int;
    if (id != null) {
      _vaccinationRecord = Provider.of<VaccinationRecord>(
        context,
        listen: false,
      ).getLocalVaccinationRecordById(id);
      _vaccinationRecordDate =
          DateTime.parse(_vaccinationRecord.vaccinationDate);
    } else {
      _vaccinationRecord.vaccinationDate =
          _vaccinationRecordDate.toIso8601String();
    }
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Vacunación"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeConfig.wp(4.5),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(_vaccinationRecordDate),
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.calendar_today_outlined),
                                  onPressed: () => _selectDate(context),
                                ),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(25)),
                            buildNameFormField(
                              "Nombre de la Vacuna",
                              "Ingrese el nombre de la vacuna",
                              TextInputType.name,
                            ),
                            SizedBox(height: getProportionateScreenHeight(25)),
                            buildVeterinaryFormField(
                              "Veterinaria",
                              "Ingrese el nombre de la veterinaria",
                              TextInputType.name,
                            ),
                            SizedBox(height: getProportionateScreenHeight(25)),
                            buildObservationsFormField(
                              "Observaciones",
                              "Ingrese observaciones sobre el diagnostico",
                              TextInputType.multiline,
                            ),
                            SizedBox(height: getProportionateScreenHeight(25)),
                            Row(
                              children: [
                                CupertinoSwitch(
                                  value: _vaccinationRecord.reminders == null
                                      ? false
                                      : _vaccinationRecord.reminders,
                                  onChanged: (value) {
                                    setState(() {
                                      _vaccinationRecord.reminders = value;
                                    });
                                  },
                                ),
                                Text(
                                  "Recordatorio",
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(25)),
                            DefaultButton(
                              text: "Guardar",
                              color: kPrimaryColor,
                              press: () async {
                                final isOK = _formKey.currentState.validate();
                                if (isOK) {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await Provider.of<VaccinationRecord>(
                                      context,
                                      listen: false,
                                    ).save(_vaccinationRecord);
                                    Navigator.pop(context);
                                  } catch (error) {
                                    Dialogs.info(
                                      context,
                                      title: 'ERROR',
                                      content: error.response.data["message"],
                                    );
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                            ),
                            id != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(25)),
                                      DefaultButton(
                                        text: "Borrar",
                                        color: Colors.white,
                                        press: () async {
                                          final response = await Dialogs.alert(
                                            context,
                                            "¿Estás seguro que desea eliminar?",
                                            "Se borrará el registro de esta vacuna",
                                            "Cancelar",
                                            "Aceptar",
                                          );
                                          if (response) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            try {
                                              await Provider.of<
                                                  VaccinationRecord>(
                                                context,
                                                listen: false,
                                              ).delete(_vaccinationRecord);
                                              Navigator.pop(context);
                                            } catch (error) {
                                              Dialogs.info(
                                                context,
                                                title: 'ERROR',
                                                content: error
                                                    .response.data["message"],
                                              );
                                            }
                                          }
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(25),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: getProportionateScreenHeight(25),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildNameFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _vaccinationRecord.vaccine,
      onChanged: (newValue) => _vaccinationRecord.vaccine = newValue,
    );
  }

  Widget buildVeterinaryFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _vaccinationRecord.veterinary,
      onChanged: (newValue) => _vaccinationRecord.veterinary = newValue,
    );
  }

  Widget buildObservationsFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      value: _vaccinationRecord.observation,
      onChanged: (newValue) => _vaccinationRecord.observation = newValue,
    );
  }
}
