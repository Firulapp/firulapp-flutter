import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/city.dart';
import '../../components/dialogs.dart';
import '../../constants/constants.dart';
import 'components/profile_photo.dart';
import '../../provider/user.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profile-details";
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  File _pickedImage;
  Future _citiesFuture;
  String _birthDate;
  final df = new DateFormat('dd-MM-yyyy');
  DateTime _date = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _date) {
      setState(() {
        _date = pickedDate;
        _birthDate = _date.toIso8601String();
      });
    }
  }

  Future _obtainCitiesFuture() {
    return Provider.of<City>(context, listen: false).fetchCities();
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
    Provider.of<User>(context, listen: false).userData.profilePicture =
        base64Encode(_pickedImage.readAsBytesSync());
  }

  @override
  void initState() {
    _citiesFuture = _obtainCitiesFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Informacion Personal"),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: ProfilePhoto(
                      _selectImage, user.userData.profilePicture, _status),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Informacion Personal',
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
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                              initialValue: user.userData.name,
                              decoration: InputDecoration(
                                hintText: "Ingresa tu Nombre",
                                labelText: 'Nombre',
                                labelStyle: defaultTextStyle(),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (newValue) =>
                                  user.userData.name = newValue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                              initialValue: user.userData.surname,
                              decoration: InputDecoration(
                                hintText: "Ingresa tu Apellido",
                                labelText: 'Apellido',
                                labelStyle: defaultTextStyle(),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (newValue) =>
                                  user.userData.surname = newValue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                              initialValue: user.userData.mail,
                              decoration: InputDecoration(
                                hintText: "Ingresa tu Correo",
                                labelText: 'Correo',
                                labelStyle: defaultTextStyle(),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (newValue) =>
                                  user.userData.mail = newValue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                              initialValue: user.userData.userName,
                              decoration: InputDecoration(
                                hintText: "Ingresa su usuario",
                                labelText: 'Usuario',
                                labelStyle: defaultTextStyle(),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (newValue) =>
                                  user.userData.userName = newValue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(user.userData.birthDate),
                                ),
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_today_outlined),
                                onPressed: () async {
                                  await _selectDate(context);
                                  setState(() {
                                    user.userData.birthDate = _birthDate;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: FutureBuilder(
                            future: _citiesFuture,
                            builder: (_, dataSnapshot) {
                              return Consumer<City>(
                                builder: (ctx, cityData, child) =>
                                    DropdownButtonFormField(
                                  items: cityData.cities
                                      .map(
                                        (city) => DropdownMenuItem(
                                          value: city.id,
                                          child: Text(city.name),
                                        ),
                                      )
                                      .toList(),
                                  value: user.userData.city,
                                  onChanged: !_status
                                      ? (newValue) =>
                                          user.userData.city = newValue
                                      : null,
                                  hint: const Text("Ciudad"),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: DropdownButtonFormField(
                            items: user
                                .getDocumentTypeOptions()
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                            value: user.userData.documentType,
                            autofocus: !_status,
                            onChanged: !_status
                                ? (newValue) =>
                                    user.userData.documentType = newValue
                                : null,
                            hint: const Text("Tipo de documento"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            initialValue: user.userData.document,
                            decoration: InputDecoration(
                              hintText: "Ingresa su documento",
                              labelText: 'Documento de identidad',
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                            onChanged: (newValue) =>
                                user.userData.document = newValue,
                          ),
                        ),
                        !_status ? _getActionButtons() : Container(),
                      ],
                    ),
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

  TextStyle defaultTextStyle() {
    return TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: const Text("Guardar"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  try {
                    Provider.of<User>(context, listen: false).saveUser();
                  } catch (error) {
                    Dialogs.info(
                      context,
                      title: "ERROR",
                      content: error.response.data["message"],
                    );
                  }
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
                  child: const Text("Cancelar"),
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
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
}
