import 'package:firulapp/provider/vaccination_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/medical_record.dart';
import '../medical_records/medical_records_screen.dart';
import '../vaccionation_records/vaccination_records_screen.dart';
import '../../provider/pets.dart';
import '../profile/components/profile_menu.dart';
import './components/pet_pic.dart';
import './components/add_pets.dart';
import 'pet_for_adoption.dart';

class SelectedPetScreen extends StatelessWidget {
  static const routeName = "/selected-pet";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as int;
    final pet = Provider.of<Pets>(context).getLocalPetById(id);
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
              Navigator.pushNamed(context, AddPets.routeName,
                  arguments: pet.id),
              null
            },
          ),
          ProfileMenu(
            text: "Fichas Médicas",
            icon: "assets/icons/medical-check.svg",
            press: () {
              Provider.of<MedicalRecord>(
                context,
                listen: false,
              ).setPetItem(pet);
              Navigator.pushNamed(
                context,
                MedicalRecordsScreen.routeName,
                arguments: pet,
              );
            },
          ),
          ProfileMenu(
            text: "Libreta de Vacunación",
            icon: "assets/icons/syringe.svg",
            press: () {
              Provider.of<VaccinationRecord>(
                context,
                listen: false,
              ).setPetItem(pet);
              Navigator.pushNamed(
                context,
                VaccinationRecordsScreen.routeName,
                arguments: pet,
              );
            },
          ),
          ProfileMenu(
            text: "Poner en Adopción",
            // icon: "assets/icons/adopcion.svg",
            icon: "assets/icons/casa-de-mascotas.svg",
            press: () {
              Navigator.of(context).pushNamed(
                PetForAdoption.routeName,
                arguments: pet.id,
              );
            },
          ),
        ]),
      ),
    );
  }
}
