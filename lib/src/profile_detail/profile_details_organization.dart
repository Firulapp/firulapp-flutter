import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../components/dropdown/item_selection_screen.dart';
import '../../components/dropdown/listtile_item.dart';
import '../../provider/city.dart';
import '../../components/dialogs.dart';
import '../../constants/constants.dart';
import 'components/profile_photo.dart';
import '../../provider/user.dart';

class ProfilePageOrganization extends StatefulWidget {
  static const routeName = "/profile-details-organization";
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePageOrganization>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  File _pickedImage;
  Future _citiesFuture;
  String temporalDescription;
  CityItem _cityItem;

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
          title: const Text("Informacion Organizacion"),
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
                                      'Informacion',
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
                          padding: EdgeInsets.only(left: 25.0, right: 25.0),
                          child: FutureBuilder(
                            future: _citiesFuture,
                            builder: (_, dataSnapshot) {
                              if (dataSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text("Loading..."),
                                );
                              } else {
                                return Consumer<City>(
                                  builder: (ctx, listCities, _) {
                                    final list = listCities.toGenericFormItem();
                                    return buildSingleCity(list);
                                  },
                                );
                              }
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
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            initialValue: temporalDescription,
                            decoration: InputDecoration(
                              hintText: "Ingresa su descripción",
                              labelText: 'Descripción',
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                            onChanged: (newValue) =>
                                temporalDescription = newValue,
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

  Widget buildSingleCity(List<ListTileItem> cities) {
    final user = Provider.of<User>(context, listen: false);
    if (_cityItem == null) {
      _cityItem = Provider.of<City>(
        context,
        listen: false,
      ).getLocalCityItemById(user.userData.city);
    }
    final onTap = () async {
      final item = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemSelectionScreen(
            allItems: cities,
          ),
        ),
      ) as ListTileItem;

      if (item == null) return;

      setState(() {
        user.userData.city = item.id;
        this._cityItem = CityItem(id: item.id, name: item.value);
      });
    };

    return buildPicker(
      title: 'Selecciona una Ciudad',
      child: _cityItem == null
          ? buildListTile(title: 'Ninguna Ciudad', onTap: onTap)
          : buildListTile(
              title: _cityItem.name,
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
