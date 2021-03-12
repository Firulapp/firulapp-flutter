// Flutter imports:
import 'package:firulapp/src/pets/components/pets-image.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import '../../../constants/constants.dart';

class AddPets extends StatefulWidget {
  static String routeName = "/pets/add";
  const AddPets({Key key}) : super(key: key);

  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<AddPets>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String changedValue = 'Lesser';
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    //final userData = Provider.of<SuperUserData>(context);
    final SizeConfig sizeConfig = SizeConfig();
    return new Scaffold(
        appBar: AppBar(
          title: Text("Agregar Mascota"),
        ),
        body: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: sizeConfig.hp(25),
                  child: PetImage(),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
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
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: DropdownButton(
                            value: changedValue,
                            items: [
                              DropdownMenuItem<String>(
                                key: ValueKey<String>('Greater'),
                                value: 'Greater',
                                child: Text('Greater'),
                              ),
                              DropdownMenuItem<String>(
                                key: Key('Lesser'),
                                value: 'Lesser',
                                child: Text('Lesser'),
                              ),
                            ],
                            onChanged: (value) {
                              print('$value');
                              setState(() {
                                changedValue = value;

                                // here i have taken the boolen variable to show and hide the list if you have not seleted the value from the dropdown the it will show the text and if selected the it will show you the list.
                              });
                            },
                          ),

                          // TextFormField(
                          //   //initialValue: userData.name,
                          //   decoration: InputDecoration(
                          //     hintText: "Ingresa tu Nombre",
                          //     labelText: 'Especie',
                          //     labelStyle: defaultTextStyle(),
                          //   ),
                          //   enabled: !_status,
                          //   autofocus: !_status,
                          // ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            //initialValue: userData.surname,
                            decoration: InputDecoration(
                              hintText: "Ingresa tu Apellido",
                              labelText: 'Raza',
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            //initialValue: userData.mail,
                            decoration: InputDecoration(
                              hintText: "Solo en años",
                              labelText: 'Edad',
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            //initialValue: userData.birthDate.toString(),
                            decoration: InputDecoration(
                              hintText: "Ingresa tu fecha de nacimiento",
                              labelText: 'Fecha de nacimiento',
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            //initialValue: userData.city,
                            decoration: InputDecoration(
                              hintText: "Ingresa tu Ciudad",
                              labelText: 'Ciudad',
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Ingrese Nro de Telefono",
                                      labelText: 'Ciudad',
                                      labelStyle: defaultTextStyle(),
                                    ),
                                    enabled: !_status,
                                  ),
                                ),
                              ],
                            )),
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
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Cancel"),
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
}
