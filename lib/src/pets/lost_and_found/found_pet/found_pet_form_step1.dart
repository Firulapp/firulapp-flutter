import 'dart:convert';
import 'dart:io';

import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/dropdown/item_selection_screen.dart';
import 'package:firulapp/components/dropdown/listtile_item.dart';
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
import 'found_pet_form_step2.dart';

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
  SpeciesItem _speciesItem;
  BreedsItem _breedsItem;

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
                                builder: (ctx, listSpecies, _) {
                                  final list = listSpecies.toGenericFormItem();
                                  return buildSingleSpecies(list);
                                },
                              );
                            }
                          },
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
                              return Consumer<Breeds>(
                                builder: (ctx, listBreeds, _) {
                                  final list = listBreeds.toGenericFormItem();
                                  return buildSingleBreeds(list);
                                },
                              );
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
                            Navigator.pushNamed(
                              context,
                              FoundPetFormStep2.routeName,
                              arguments: FoundPetReport(
                                pet: _pet,
                                report: _report,
                              ),
                            );
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

  Widget buildSingleSpecies(List<ListTileItem> species) {
    final onTap = () async {
      final item = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemSelectionScreen(
            allItems: species,
            subject: 'Especie',
          ),
        ),
      ) as ListTileItem;

      if (item == null) return;

      setState(() {
        this._speciesItem = SpeciesItem(id: item.id, name: item.value);
        _pet.speciesId = item.id;
        _initialBreeds = Provider.of<Breeds>(
          context,
          listen: false,
        ).getBreeds(item.id);
      });
    };
    if (_pet.speciesId != null) {
      _speciesItem = Provider.of<Species>(
        context,
        listen: false,
      ).getLocalSpeciesItemById(_pet.speciesId);
    }

    return buildPicker(
      title: 'Selecciona una Especie',
      child: _speciesItem == null
          ? buildListTile(title: 'Ninguna Especie', onTap: onTap)
          : buildListTile(
              title: _speciesItem.name,
              onTap: onTap,
            ),
    );
  }

  Widget buildSingleBreeds(List<ListTileItem> breeds) {
    final onTap = () async {
      final item = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemSelectionScreen(
            allItems: breeds,
            subject: 'Raza',
          ),
        ),
      ) as ListTileItem;

      if (item == null) return;

      setState(() {
        this._breedsItem = BreedsItem(id: item.id, name: item.value);
        _pet.breedId = item.id;
      });
    };
    if (_pet.breedId != null) {
      _breedsItem = Provider.of<Breeds>(
        context,
        listen: false,
      ).getLocalBreedsItemById(_pet.breedId);
    }

    return buildPicker(
      title: 'Selecciona una Raza',
      child: _breedsItem == null
          ? buildListTile(title: 'Ninguna Raza', onTap: onTap)
          : buildListTile(
              title: _breedsItem.name,
              onTap: onTap,
            ),
    );
  }

  Widget buildPicker({
    @required String title,
    @required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(margin: EdgeInsets.zero, child: child),
        ],
      );

  Widget buildListTile({
    @required String title,
    VoidCallback onTap,
    Widget leading,
  }) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
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
