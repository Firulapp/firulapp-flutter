import 'package:flutter/material.dart';

import './components/adoptions/pets_list_on_adoptions.dart';

class PetOnAdoption extends StatelessWidget {
  static const routeName = "/pets-on-adoptions";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mascotas en Adopción"),
      ),
      body: PetsListAdoptions(),
    );
  }
}
