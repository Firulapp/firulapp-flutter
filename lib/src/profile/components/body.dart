import 'package:flutter/material.dart';

import '../../profile_detail/profile_details.dart';
import '../../../components/dialogs.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Mi Cuenta",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.pushNamed(context, ProfilePage.routeName),
            },
          ),
          ProfileMenu(
            text: "Notificaciones",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Ajustes",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Ayuda",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Desactivar cuenta",
            icon: "assets/icons/Log out.svg",
            press: () {
              Dialogs.info(
                context,
                title: 'Desactivar Perfil',
                content: 'Estas seguro que quiere desactivar la cuenta?',
              );
            },
          ),
        ],
      ),
    );
  }
}
