import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/src/pets/pets_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/pets.dart';
import '../pet_pic.dart';

String commentary;

class PetForAdoption extends StatelessWidget {
  static const routeName = "/for-adoption";
  const PetForAdoption({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as int;
    final pet = Provider.of<Pets>(context, listen: false).getLocalPetById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(children: [
          Center(child: PetPic(pet)),
          SizedBox(height: 20),
          buildCommentaryFormField(
            label: "Comentario de Adopción",
            hint: "Ingrese un comentario",
            tipo: TextInputType.multiline,
          ),
          SizedBox(height: 20),
          DefaultButton(
            text: "PONER EN ADOPCIÓN",
            color: Constants.kPrimaryColor,
            press: () async {
              final response = await Dialogs.alert(
                context,
                "¿Estás seguro que desea poner en adopción a  ${pet.name}?",
                "",
                "Cancelar",
                "Aceptar",
              );
              if (response) {
                pet.status = "ADOPTAR";
                pet.description = commentary;
                Provider.of<Pets>(context, listen: false).petItem = pet;
                Provider.of<Pets>(context, listen: false).savePet();
                Navigator.pop(context);
              }
            },
          )
        ]),
      ),
    );
  }

  Widget buildCommentaryFormField(
      {String label, String hint, TextInputType tipo}) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 100,
      value: commentary,
      onChanged: (newValue) => commentary = newValue,
    );
  }
}
