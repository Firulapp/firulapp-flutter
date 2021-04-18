import 'dart:convert';
import 'dart:io';

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

  // valores dinamicos del formulario, se utilizaran para enviar el objeto al back
  int _speciesId;
  DateTime _birthDate = DateTime.now();
  int _age;
  bool _petStatus = true;

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

  Future<void> _getListBreeds(int idSpecies) async {
    try {
      final List<BreedsItem> items = [];
      Provider.of<Breeds>(context, listen: false).items = items;
      Provider.of<Breeds>(context, listen: false).getBreeds(idSpecies);
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
    final id = ModalRoute.of(context).settings.arguments as int;
    if (id != null && isInit) {
      _pet = Provider.of<Pets>(context, listen: false).getLocalPetById(id);
      _initialBreeds = _getListBreeds(_pet.speciesId);
      isInit = false;
    }
    super.didChangeDependencies();
  }

  final df = new DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: getProportionateScreenHeight(25)),
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
                      SizedBox(height: getProportionateScreenHeight(25)),
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
                                                    _getListBreeds(v);
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
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                icon: Icon(Icons.calendar_today_outlined),
                                onPressed: () => _selectDate(context),
                                iconSize: 40,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
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
                                  'Edad',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  (calculateAge(_birthDate).toString() +
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
                      SizedBox(height: getProportionateScreenHeight(25)),
                      buildDropdown(['PEQUEÑO', 'MEDIANO', 'GRANDE']),
                      SizedBox(height: getProportionateScreenHeight(25)),
                      buildPrimaryColorFormField(
                        label: "Color primario",
                        hint: "Ingrese un color",
                        tipo: TextInputType.text,
                      ),
                      SizedBox(height: getProportionateScreenHeight(25)),
                      buildSecondaryColorFormField(
                        label: "Color secundario",
                        hint: "Ingrese un color",
                        tipo: TextInputType.text,
                      ),
                      SizedBox(height: getProportionateScreenHeight(25)),
                      buildDescriptionFormField(
                        label: "Descripción",
                        hint: "Ingrese una description",
                        tipo: TextInputType.multiline,
                      ),
                      !_status ? _getActionButtons() : Container(),
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
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Guardar"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async {
                  try {
                    newPet = PetItem(
                      id: _pet.id,
                      name: _pet.name,
                      speciesId: _pet.speciesId,
                      breedId: _pet.breedId,
                      birthDate: _birthDate.toIso8601String(),
                      age: _age,
                      petSize: _pet.petSize,
                      primaryColor: _pet.primaryColor,
                      secondaryColor: _pet.secondaryColor,
                      description: _pet.description,
                      status: _petStatus,
                      picture: _pet.picture,
                      createdAt: _pet.createdAt,
                    );
                    Provider.of<Pets>(context, listen: false).petItem = newPet;
                    Provider.of<Pets>(context, listen: false).savePet();
                    print("Se guardo la mascota");
                    Navigator.pop(context);
                  } catch (e) {
                    Dialogs.info(
                      context,
                      title: 'ERROR',
                      content: e.response.data["message"],
                    );
                    print(e);
                  }
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Cancelar"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: kPrimaryColor,
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
