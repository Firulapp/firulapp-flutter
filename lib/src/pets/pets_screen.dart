import 'package:flutter/material.dart';

import './components/pets_body.dart';

class PetsScreen extends StatelessWidget {
  static const routeName = "/pets";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Mascotas"),
      ),
      body: PetsBody(),
    );
  }
}
