import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/pets.dart';
import '../pet_pic.dart';

String amount;

class PetForFostering extends StatelessWidget {
  static const routeName = "/for-forFostering";
  const PetForFostering({Key key}) : super(key: key);

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
            label: "Monto donanación",
            hint: "Ingrese un monto",
            tipo: TextInputType.number,
          ),
          SizedBox(height: 20),
          DefaultButton(
            text: "APADRINAR",
            color: Constants.kPrimaryColor,
            press: () async {
              final response = await Dialogs.alert(
                context,
                "¿Estás seguro que desea apadrinar a ${pet.name}?",
                "",
                "Cancelar",
                "Aceptar",
              );
              if (response) {
                Provider.of<Pets>(context, listen: false)
                    .requestFostering(id, amount);
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
      value: amount,
      onChanged: (newValue) => amount = newValue,
    );
  }
}
