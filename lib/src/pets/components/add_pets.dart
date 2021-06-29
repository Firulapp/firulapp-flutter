import 'dart:convert';
import 'dart:io';

import 'package:firulapp/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/input_text.dart';
import '../../../provider/breeds.dart';
import '../../mixins/validator_mixins.dart';
import '../../../components/dialogs.dart';
import '../../../size_config.dart';
import '../../../constants/constants.dart';
import '../../../provider/species.dart';
import '../../../provider/pets.dart';
import './pets_image.dart';

class AddPets extends StatefulWidget {
  static const routeName = "/pets/add";
  AddPets({Key key}) : super(key: key);

  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<AddPets> with ValidatorMixins {
  bool _status = true;
  Future _initialSpecies;
  Future _initialBreeds;
  PetItem newPet;
  PetItem _pet = new PetItem();
  var isInit = true;
  var _isLoading = true;

  // valores dinamicos del formulario, se utilizaran para enviar el objeto al back
  int _speciesId;
  DateTime _birthDate = DateTime.now();
  int _age;
  String _petStatus = PetStatus.ADOPTADA.value;

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
    final id = ModalRoute.of(context).settings.arguments as int;
    if (id != null && isInit) {
      _pet = Provider.of<Pets>(context, listen: false).getLocalPetById(id);
      _birthDate = DateTime.parse(_pet.birthDate);
      _initialBreeds = providerBreeds.getBreeds(_pet.speciesId);
      isInit = false;
    }
    _isLoading = false;
    super.didChangeDependencies();
  }

  final df = new DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final providerBreeds = Provider.of<Breeds>(context, listen: false);
    return new Scaffold(
        appBar: AppBar(
          title: Text("Agregar Mascota"),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
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
                      SizedBox(
                          height: SizeConfig.getProportionateScreenHeight(25)),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 25.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status ? _getEditIcon() : Container(),
                                      ],
                                    )
                                  ],
                                )),
                            SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                    25)),
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
                                                          providerBreeds
                                                              .getBreeds(v);
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
                            GestureDetector(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            const Text(
                                              'Fecha de Nacimiento',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Constants.kSecondaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(
                                          df.format(_birthDate),
                                          style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              Icons.calendar_today_outlined),
                                          onPressed: () async {
                                            await _selectDate(context);
                                            setState(
                                              () {
                                                _pet.birthDate = _birthDate
                                                    .toIso8601String();
                                              },
                                            );
                                          },
                                          iconSize: 40,
                                          color: Constants.kPrimaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Text(
                                              'Edad',
                                              style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              (calculateAge(_birthDate)
                                                      .toString() +
                                                  " Años"),
                                              style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildDropdown(['PEQUEÑO', 'MEDIANO', 'GRANDE']),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildPrimaryColorFormField(
                              label: "Color primario",
                              hint: "Ingrese un color",
                              tipo: TextInputType.text,
                            ),
                            SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                    25)),
                            buildSecondaryColorFormField(
                              label: "Color secundario",
                              hint: "Ingrese un color",
                              tipo: TextInputType.text,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildDescriptionFormField(
                              label: "Descripción",
                              hint: "Ingrese una description",
                              tipo: TextInputType.multiline,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            !_status
                                ? Column(
                                    children: [
                                      DefaultButton(
                                        text: "Guardar",
                                        color: Constants.kPrimaryColor,
                                        press: () async {
                                          try {
                                            if (_pet.birthDate == null) {
                                              Dialogs.info(
                                                context,
                                                title: "ERROR",
                                                content:
                                                    "Debe seleccionar la fecha de nacimiento",
                                              );
                                              return;
                                            }
                                            newPet = PetItem(
                                              id: _pet.id,
                                              name: _pet.name,
                                              speciesId: _pet.speciesId,
                                              breedId: _pet.breedId,
                                              birthDate: _pet.birthDate,
                                              age: _age,
                                              petSize: _pet.petSize,
                                              primaryColor: _pet.primaryColor,
                                              secondaryColor:
                                                  _pet.secondaryColor,
                                              description: _pet.description,
                                              status: _petStatus,
                                              picture: _pet.picture,
                                              createdAt: _pet.createdAt,
                                            );
                                            Provider.of<Pets>(context,
                                                    listen: false)
                                                .petItem = newPet;
                                            // Provider.of<Pets>(context, listen: false).savePet();
                                            Navigator.pop(context);
                                          } catch (e) {
                                            Dialogs.info(
                                              context,
                                              title: 'ERROR',
                                              content:
                                                  e.response.data["message"],
                                            );
                                          }
                                          setState(() {
                                            _status = true;
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          });
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: SizeConfig
                                            .getProportionateScreenHeight(25),
                                      ),
                                      DefaultButton(
                                        text: "Cancelar",
                                        color: Colors.white,
                                        press: () async {
                                          setState(() {
                                            _status = true;
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: SizeConfig
                                            .getProportionateScreenHeight(25),
                                      ),
                                    ],
                                  )
                                : Container(),
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

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Constants.kPrimaryColor,
        radius: 20.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _birthDate)
      setState(() {
        _birthDate = pickedDate;
      });
  }

  //Calculate age for the backend
  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    _age = age; // aqui deberia actualizar el objeto de la mascotas
    return age;
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
