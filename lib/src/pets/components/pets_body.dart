import 'package:firulapp/src/pets/components/pets_list.dart';
import 'package:flutter/material.dart';

import 'add_pets.dart';

class PetsBody extends StatefulWidget {
  PetsBody({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<PetsBody> {
  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Column(
        children: <Widget>[
          TextButton.icon(
            label: Text('Agregar mascota'),
            icon: Icon(
              Icons.add,
            ),
            onPressed: () => Navigator.pushNamed(context, AddPets.routeName),
          ),
          Expanded(child: PetsList()),
        ],
      ),
    ));
  }
}
