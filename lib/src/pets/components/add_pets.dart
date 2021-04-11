import 'dart:convert';
import 'dart:io';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/provider/breeds.dart';
import 'package:firulapp/src/mixins/validator_mixins.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/dialogs.dart';
import '../../../size_config.dart';
import '../../../constants/constants.dart';
import '../../../provider/species.dart';
import '../../../provider/pets.dart';
import 'pets_image.dart';

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

  // valores dinamicos del formulario, se utilizaran para enviar el objeto al back
  int _petId;
  String _name;
  int _speciesId;
  int _breedId;
  DateTime _birthDate = DateTime.now();
  int _age;
  String _petSize;
  String _primaryColor;
  String _petDescription;
  String _secondaryColor;
  bool _petStatus = true;
  File _petPicture;
  String _petPictureBase64;
  String _createdAt;
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

  Future<void> _getListBreeds() async {
    try {
      Provider.of<Breeds>(context, listen: false).getBreeds();
    } catch (e) {
      Dialogs.info(
        context,
        title: 'ERROR',
        content: e.toString(),
      );
    }
  }

  void _setPetData() async {
    try {
      PetItem pet = Provider.of<Pets>(context, listen: true).petItem;
      setState(() {
        _petId = pet.id;
        _name = pet.name;
        _speciesId = pet.speciesId;
        _breedId = pet.breedId;
        _birthDate = DateTime.parse(pet.birthDate);
        _age = pet.age;
        _petSize = pet.petSize;
        _primaryColor = pet.primaryColor;
        _petDescription = pet.description;
        _secondaryColor = pet.secondaryColor;
        _petStatus = pet.status;
        // _petPicture = pet.picture;
        _petPictureBase64 = pet.picture;
        _createdAt = pet.createdAt;
      });
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
    _initialBreeds = _getListBreeds();
    super.initState();
  }

  void _selectImage(File pickedImage) {
    setState(() {
      _petPicture = pickedImage;
    });
    _petPictureBase64 = base64Encode(pickedImage.readAsBytesSync());
  }

  final df = new DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    final id = ModalRoute.of(context).settings.arguments as int;
    if (id != null && _pet == null) {
      _pet = Provider.of<Pets>(context, listen: true).getLocalPetById(id);
      // _setPetData();
    }
    return new Scaffold(
        appBar: AppBar(
          title: Text("Agregar Mascota"),
        ),
        body: ListView(
          padding: EdgeInsets.only(left: 35.0, right: 25.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: sizeConfig.hp(22),
                  child: PetImage(
                    _selectImage,
                    _petPicture,
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
                          padding: EdgeInsets.only(top: 25.0),
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
                        padding: EdgeInsets.only(top: 25.0),
                        child: FutureBuilder(
                            future: _initialSpecies,
                            builder: (_, dataSnapshot) {
                              return Consumer<Species>(
                                builder: (ctx, listSpecies, _) =>
                                    DropdownButton(
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
                                            _pet.speciesId = v;
                                          })
                                      : null,
                                  value: _pet.speciesId,
                                  isExpanded: true,
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: FutureBuilder(
                          future: _initialBreeds,
                          builder: (_, dataSnapshot) {
                            return Consumer<Breeds>(
                              builder: (ctx, listBreeds, _) => DropdownButton(
                                hint: _breedId == null
                                    ? Text('Eliga una raza')
                                    : null,
                                disabledHint: _pet.breedId != null
                                    ? Text(listBreeds.items
                                        .firstWhere(
                                            (item) => item.id == _pet.breedId)
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
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text('Fecha de Nacimiento'),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  df.format(_birthDate),
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
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
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
                      id != null ? _getDeletePetButton() : Container(),
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

  Widget _getDeletePetButton() {
    return Padding(
      padding: EdgeInsets.only(top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Container(
              child: RaisedButton(
                child: Text("Borrar Mascota"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  // SelectDialog().alertDialog(context,
                  //     title: 'AVISO',
                  //     content:
                  //         'Está seguro que desa borrar el perfil de la mascota?');
                  Provider.of<Pets>(context, listen: false).deletePet(_petId);
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
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
                      speciesId: _speciesId,
                      breedId: _breedId,
                      birthDate: _birthDate.toIso8601String(),
                      age: _age,
                      primaryColor: _pet.primaryColor,
                      secondaryColor: _pet.secondaryColor,
                      description: _pet.description,
                      status: _petStatus,
                      picture: _petPictureBase64,
                      createdAt: _pet.createdAt,
                    );
                    Provider.of<Pets>(context, listen: false).petItem = newPet;
                    Provider.of<Pets>(context, listen: false).savePet();
                    print("Se guardo la mascota");
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
              padding: EdgeInsets.only(left: 10.0),
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
}
