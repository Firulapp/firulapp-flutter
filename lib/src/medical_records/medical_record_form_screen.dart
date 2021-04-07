import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../mixins/validator_mixins.dart';
import '../../size_config.dart';

class NewMedicalRecordScreen extends StatefulWidget {
  static const routeName = "/new_medical_records";
  @override
  _NewMedicalRecordScreenState createState() => _NewMedicalRecordScreenState();
}

class _NewMedicalRecordScreenState extends State<NewMedicalRecordScreen>
    with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  final df = new DateFormat('dd-MM-yyyy');
  DateTime _medicalRecordDate = DateTime.now();
  String _observations = '';
  String _veterinary = '';
  String _diagnostic = '';
  String _treatment = '';
  bool _reminder = false;
  int _weight = 0;
  int _height = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _medicalRecordDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _medicalRecordDate) {
      setState(() {
        _medicalRecordDate = pickedDate;
      });
    }
  }

  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    if (id != null) {
      _observations = "dasdasd";
      _veterinary = "dasdasd";
      _diagnostic = "dasdasd";
      _treatment = "dasdasd";
      _reminder = false;
      _weight = 12;
      _height = 7;
    }
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Ficha Médica"),
      ),
      body: ListView(
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
                      Row(
                        children: [
                          Text(
                            DateFormat.yMMMd().format(_medicalRecordDate),
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
                      buildVeterinaryFormField(
                        "Veterinaria",
                        "Ingrese el nombre de la veterinaria",
                        TextInputType.name,
                      ),
                      SizedBox(height: getProportionateScreenHeight(25)),
                      buildDiagnosticFormField(
                        "Diagnóstico",
                        "Ingrese el diagnóstico de la mascota",
                        TextInputType.multiline,
                      ),
                      SizedBox(height: getProportionateScreenHeight(25)),
                      buildTreatmentFormField(
                        "Tratamiento",
                        "Ingrese el tratamiento a seguir",
                        TextInputType.multiline,
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
                          Container(
                            width: getProportionateScreenWidth(150),
                            child: buildWeightFormField(
                              "Peso",
                              TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: getProportionateScreenWidth(150),
                            child: buildHeightFormField(
                              "Altura",
                              TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(25)),
                      Row(
                        children: [
                          CupertinoSwitch(
                            value: _reminder,
                            onChanged: (value) {
                              setState(() {
                                _reminder = value;
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
                        press: () {
                          final isOK = _formKey.currentState.validate();
                          if (isOK) {
                            Navigator.pop(context);
                          }
                        },
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

  Widget buildVeterinaryFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _veterinary,
      onChanged: (newValue) => _veterinary = newValue,
    );
  }

  Widget buildDiagnosticFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      validator: validateTextNotNull,
      value: _diagnostic,
      onChanged: (newValue) => _diagnostic = newValue,
    );
  }

  Widget buildTreatmentFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      validator: validateTextNotNull,
      value: _treatment,
      onChanged: (newValue) => _treatment = newValue,
    );
  }

  Widget buildObservationsFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      validator: validateTextNotNull,
      value: _observations,
      onChanged: (newValue) => _observations = newValue,
    );
  }

  Widget buildWeightFormField(String label, TextInputType tipo) {
    return InputText(
      label: label,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _weight.toString(),
      onChanged: (newValue) => _weight = int.parse(newValue),
    );
  }

  Widget buildHeightFormField(String label, TextInputType tipo) {
    return InputText(
      label: label,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _height.toString(),
      onChanged: (newValue) => _height = int.parse(newValue),
    );
  }
}
