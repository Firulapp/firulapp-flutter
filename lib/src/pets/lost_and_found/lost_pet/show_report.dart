import 'dart:convert';
import 'dart:io';

import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/provider/breeds.dart';
import 'package:firulapp/provider/pets.dart';
import 'package:firulapp/provider/reports.dart';
import 'package:firulapp/provider/species.dart';
import 'package:firulapp/src/mixins/validator_mixins.dart';
import 'package:firulapp/src/pets/components/pets_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../size_config.dart';

class ShowReport extends StatefulWidget {
  static const routeName = "/lost_report";

  @override
  _ShowReportState createState() => _ShowReportState();
}

class _ShowReportState extends State<ShowReport> with ValidatorMixins {
  bool _status = true;
  Future _initialSpecies;
  Future _initialBreeds;
  PetItem newPet;
  PetItem _pet = new PetItem();
  ReportItem _report = new ReportItem();
  // valores dinamicos del formulario, se utilizaran para enviar el objeto al back
  int _speciesId;

  final FocusNode myFocusNode = FocusNode();
  Future<void> _getListSpecies() async {
    try {
      Provider.of<Species>(context, listen: false).getSpecies();
    } catch (e) {
      Dialogs.info(
        context,
        title: 'ERROR',
        content: e.toString(),
      );
    }
  }

  @override
  void initState() {
    _initialSpecies = _getListSpecies();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final providerBreeds = Provider.of<Breeds>(context, listen: false);
    _report = ModalRoute.of(context).settings.arguments as ReportItem;
    if (_report.reportType == "MASCOTA_PERDIDA") {
      _pet = Provider.of<Pets>(context).getLocalPetById(_report.petId);
    } else {
      _pet = Provider.of<Pets>(context).getLocalFoundPetById(_report.petId);
    }

    _initialBreeds = providerBreeds.getBreeds(_pet.speciesId);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final providerBreeds = Provider.of<Breeds>(context, listen: false);
    return new Scaffold(
        appBar: AppBar(
          title: Text("Agregar Mascota"),
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 35.0, right: 25.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: PetImage(
                    _selectImage,
                    _pet.picture,
                    _status,
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  'Datos del reporte',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildPetStateFormField(
                        label: "Estado",
                        tipo: TextInputType.text,
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildDetailFormField(
                        "Descripción sobre la pérdida",
                        "Ingrese el detalle sobre la pérdida de la mascota",
                        TextInputType.multiline,
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildMainStreetFormField(
                        "Calle principal",
                        "Ingrese la calle principal",
                        TextInputType.name,
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildSecondaryStreetFormField(
                        "Calle secundaria",
                        "Ingrese la calle secundaria",
                        TextInputType.name,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  'Datos de mascota',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildNameFormField(
                        label: "Nombre de mascota",
                        hint: "Ingrese un nombre",
                        tipo: TextInputType.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: FutureBuilder(
                            future: _initialSpecies,
                            builder: (_, dataSnapshot) {
                              if (dataSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text("Loading..."),
                                );
                              } else {
                                return Consumer<Species>(
                                  builder: (ctx, listSpecies, _) =>
                                      DropdownButtonFormField(
                                    hint: _speciesId == null
                                        ? Text('Elija una especie')
                                        : null,
                                    disabledHint: _pet.speciesId != null
                                        ? Text(listSpecies.items
                                            .firstWhere((item) =>
                                                item.id == _pet.speciesId)
                                            .name)
                                        : null,
                                    items: listSpecies.items
                                        .map((e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.name),
                                            ))
                                        .toList(),
                                    onChanged: !_status
                                        ? (v) => setState(() {
                                              if (_pet.speciesId != v) {
                                                _pet.breedId = null;
                                                _initialBreeds =
                                                    providerBreeds.getBreeds(v);
                                              }
                                              _pet.speciesId = v;
                                            })
                                        : null,
                                    value: _pet.speciesId,
                                    isExpanded: true,
                                  ),
                                );
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: FutureBuilder(
                          future: _initialBreeds,
                          builder: (_, dataSnapshot) {
                            if (dataSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text("Loading..."),
                              );
                            } else {
                              if (dataSnapshot.error != null) {
                                return Center(
                                  child: Text('Algo salio mal'),
                                );
                              } else {
                                return Consumer<Breeds>(
                                  builder: (ctx, listBreeds, _) =>
                                      DropdownButtonFormField(
                                    hint: _pet.breedId == null
                                        ? Text('Eliga una raza')
                                        : null,
                                    disabledHint: _pet.breedId != null
                                        ? Text(listBreeds.items
                                            .firstWhere((item) =>
                                                item.id == _pet.breedId)
                                            .name)
                                        : null,
                                    items: listBreeds.items
                                        .map((e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.name),
                                            ))
                                        .toList(),
                                    onChanged: !_status
                                        ? (v) => setState(() {
                                              _pet.breedId = v;
                                            })
                                        : null,
                                    value: _pet.breedId,
                                    isExpanded: true,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildDropdown(['PEQUEÑO', 'MEDIANO', 'GRANDE']),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildPrimaryColorFormField(
                        label: "Color primario",
                        hint: "Ingrese un color",
                        tipo: TextInputType.text,
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildSecondaryColorFormField(
                        label: "Color secundario",
                        hint: "Ingrese un color",
                        tipo: TextInputType.text,
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildDescriptionFormField(
                        label: "Descripción",
                        hint: "Ingrese una description",
                        tipo: TextInputType.multiline,
                      ),
                      _getActionButtons(),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  void _selectImage(File pickedImage) {
    _pet.picture = base64Encode(pickedImage.readAsBytesSync());
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                child: DefaultButton(
                  text: "Borrar",
                  color: Colors.white,
                  press: () async {
                    final response = await Dialogs.alert(
                      context,
                      "¿Estás seguro que desea eliminar?",
                      "Se borrará este reporte",
                      "Cancelar",
                      "Aceptar",
                    );
                    if (response) {
                      try {
                        await Provider.of<Reports>(
                          context,
                          listen: false,
                        ).delete(_report);
                        Navigator.pop(context);
                      } catch (error) {
                        Dialogs.info(
                          context,
                          title: 'ERROR',
                          content: error.response.data["message"],
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget buildPetStateFormField(
      {String label, String hint, TextInputType tipo}) {
    return InputText(
      label: label,
      hintText: hint,
      validator: validateTextNotNull,
      keyboardType: tipo,
      maxLines: 10,
      value: _report.reportType,
      onChanged: (newValue) => _report.reportType = newValue,
      enabled: !_status,
      autofocus: !_status,
    );
  }

  Widget buildNameFormField({String label, String hint, TextInputType tipo}) {
    return InputText(
      label: label,
      hintText: hint,
      validator: validateTextNotNull,
      keyboardType: tipo,
      maxLines: 10,
      value: _pet.name,
      onChanged: (newValue) => _pet.name = newValue,
      enabled: !_status,
      autofocus: !_status,
    );
  }

  Widget buildPrimaryColorFormField(
      {String label, String hint, TextInputType tipo}) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      value: _pet.primaryColor,
      onChanged: (newValue) => _pet.primaryColor = newValue,
      enabled: !_status,
      autofocus: !_status,
    );
  }

  Widget buildSecondaryColorFormField(
      {String label, String hint, TextInputType tipo}) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      value: _pet.secondaryColor,
      onChanged: (newValue) => _pet.secondaryColor = newValue,
      enabled: !_status,
      autofocus: !_status,
    );
  }

  Widget buildDescriptionFormField(
      {String label, String hint, TextInputType tipo}) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 100,
      value: _pet.description,
      onChanged: (newValue) => _pet.description = newValue,
      enabled: !_status,
      autofocus: !_status,
    );
  }

  Widget buildMainStreetFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      value: _report.mainStreet,
      onChanged: (newValue) => _report.mainStreet = newValue,
    );
  }

  Widget buildSecondaryStreetFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      value: _report.secondaryStreet,
      onChanged: (newValue) => _report.secondaryStreet = newValue,
    );
  }

  Widget buildDetailFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _report.description,
      maxLines: 10,
      onChanged: (newValue) => _report.description = newValue,
    );
  }

  DropdownButtonFormField buildDropdown(List<String> listsOptions) {
    List<DropdownMenuItem> _typeOptions = [];
    listsOptions.forEach((type) {
      _typeOptions.add(
        DropdownMenuItem(
          child: Text(type),
          value: type,
        ),
      );
    });
    return DropdownButtonFormField(
      items: _typeOptions,
      onChanged: !_status ? (v) => _pet.petSize = v : null,
      hint: const Text("Tamaño"),
      disabledHint: _pet.petSize != null
          ? Text(listsOptions.firstWhere((item) => item == _pet.petSize))
          : null,
      value: _pet.petSize,
      autofocus: !_status,
    );
  }
}
