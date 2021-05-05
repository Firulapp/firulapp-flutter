import 'package:flutter/material.dart';

import './pets_list.dart';
import './add_pets.dart';

class PetsBody extends StatefulWidget {
  PetsBody({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<PetsBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            TextButton.icon(
              label: const Text('Agregar mascota'),
              icon: Icon(
                Icons.add,
              ),
              onPressed: () => Navigator.pushNamed(context, AddPets.routeName),
            ),
            Expanded(child: PetsList()),
          ],
        ),
      ),
    );
  }
}
