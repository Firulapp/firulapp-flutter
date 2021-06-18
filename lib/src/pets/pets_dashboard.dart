import 'package:flutter/material.dart';

import '../profile/components/profile_menu.dart';
import './pets_screen_adoptions.dart';
import './pets_screen.dart';
import './lost_and_found/lost_and_found_map.dart';

class PetsDashboard extends StatelessWidget {
  static const routeName = "/pets-dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mascotas"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfileMenu(
              text: "Mis Mascotas",
              icon: "assets/icons/dog.svg",
              press: () => {Navigator.pushNamed(context, PetsScreen.routeName)},
            ),
            ProfileMenu(
              text: "En Adopción",
              icon: "assets/icons/casa-de-mascotas.svg",
              press: () =>
                  {Navigator.pushNamed(context, PetOnAdoption.routeName)},
            ),
            ProfileMenu(
              text: "Mascotas Perdidas y Encontradas",
              icon: "assets/icons/lostDog.svg",
              press: () =>
                  {Navigator.pushNamed(context, LostAndFoundMap.routeName)},
            ),
          ],
        ),
      ),
    );
  }
}
