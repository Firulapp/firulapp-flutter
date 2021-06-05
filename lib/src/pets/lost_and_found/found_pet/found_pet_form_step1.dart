import 'dart:convert';
import 'dart:io';

import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/breeds.dart';
import 'package:firulapp/provider/pets.dart';
import 'package:firulapp/provider/reports.dart';
import 'package:firulapp/provider/species.dart';
import 'package:firulapp/src/mixins/validator_mixins.dart';
import 'package:firulapp/src/pets/components/pets_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../size_config.dart';

class FoundPetFormStep1 extends StatefulWidget {
  static const routeName = "/found_pet_form/step1";

  @override
  _FoundPetFormStep1State createState() => _FoundPetFormStep1State();
}

class _FoundPetFormStep1State extends State<FoundPetFormStep1>
    with ValidatorMixins {
  ReportItem _report = new ReportItem();
  Future _initialSpecies;
  Future _initialBreeds;
  PetItem _pet = new PetItem();
  int _speciesId;

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

  void _selectImage(File pickedImage) {
    _pet.picture = base64Encode(pickedImage.readAsBytesSync());
  }

  @override
  Widget build(BuildContext context) {
    final providerBreeds = Provider.of<Breeds>(context, listen: false);
    final point = ModalRoute.of(context).settings.arguments as GeographicPoints;
    _report.locationLatitude = double.parse(point.latitude);
    _report.locationLongitude = double.parse(point.longitude);
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportar Mascota Encontrada, Paso 1"),
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
                child: Column(
                  children: [
                    Container(
                      child: PetImage(
                        _selectImage,
                        _pet.picture,
                        false,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.getProportionateScreenHeight(25),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FutureBuilder(
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
                                  onChanged: (v) => setState(
                                    () {
                                      if (_pet.speciesId != v) {
                                        _pet.breedId = null;
                                        _initialBreeds =
                                            providerBreeds.getBreeds(v);
                                      }
                                      _pet.speciesId = v;
                                    },
                                  ),
                                  value: _pet.speciesId,
                                  isExpanded: true,
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: SizeConfig.getProportionateScreenHeight(25),
                        ),
                        FutureBuilder(
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
                                    onChanged: (v) => setState(
                                      () {
                                        _pet.breedId = v;
                                      },
                                    ),
                                    value: _pet.breedId,
                                    isExpanded: true,
                                  ),
                                );
                              }
                            }
                          },
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
                        DefaultButton(
                          text: "Siguiente",
                          color: Constants.kPrimaryColor,
                          press: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
      onChanged: (v) => _pet.petSize = v,
      hint: const Text("Tamaño"),
      disabledHint: _pet.petSize != null
          ? Text(listsOptions.firstWhere((item) => item == _pet.petSize))
          : null,
      value: _pet.petSize,
    );
  }
}
