import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/src/pets/pets_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/pets.dart';
import '../pet_pic.dart';

String user;
int userId;

class TransferPet extends StatelessWidget {
  static const routeName = "/transfer-pet";
  const TransferPet({Key key}) : super(key: key);

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
          buildUserFormField(
            label: "TRANSFERIR MASCOTA",
            hint: "Ingrese un usuario",
            tipo: TextInputType.multiline,
          ),
          SizedBox(height: 20),
          DefaultButton(
            text: "TRANFERIR MASCOTA",
            color: Constants.kPrimaryColor,
            press: () async {
              final response = await Dialogs.alert(
                context,
                "¿Desea tranferir ${pet.name} al usuario $user?",
                "",
                "Cancelar",
                "Aceptar",
              );
              if (response) {
                Provider.of<Pets>(context, listen: false).tranferPet(user, id);
                Navigator.pushReplacementNamed(context, PetsScreen.routeName);
              }
            },
          )
        ]),
      ),
    );
  }

  Widget buildUserFormField({String label, String hint, TextInputType tipo}) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 100,
      value: user,
      onChanged: (newValue) => user = newValue,
    );
  }
}
