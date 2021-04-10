import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/pets.dart';
import '../profile/components/profile_menu.dart';
import 'components/pet_pic.dart';

class SelectedPetScreen extends StatelessWidget {
  static const routeName = "/selected-pet";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as int;
    final pet = Provider.of<Pets>(context, listen: false).getLocalPetById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(children: [
          PetPic(pet),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Mi Mascota",
            icon: "assets/icons/dog.svg",
            press: () => {
              //Navigator.pushNamed(context, ProfilePage.routeName),
              null
            },
          ),
          ProfileMenu(
            text: "Fichas Médicas",
            icon: "assets/icons/medical-check.svg",
            press: () {
              //Navigator.pushNamed(context,MedicalRecordsScreen.routeName,arguments: pet,);
            },
          ),
          ProfileMenu(
            text: "Libreta de Vacunación",
            icon: "assets/icons/syringe.svg",
            press: () {},
          ),
        ]),
      ),
    );
  }
}
