import 'package:flutter/material.dart';

import '../../../components/menu_button.dart';
import '../../../size_config.dart';
import '../../../constants/constants.dart';
import '../../agenda/agenda_screen.dart';
import '../../pets/pets_dashboard.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    return SafeArea(
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig.wp(4.5),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: sizeConfig.wp(9)),
                    child: Text(
                      'Firulapp',
                      style: TextStyle(
                        fontSize: sizeConfig.hp(4),
                        color: Constants.kSecondaryColor,
                      ),
                    ),
                  ),
                  MenuButton(
                    sizeConfig: sizeConfig,
                    label: 'Mascotas',
                    icon: Icons.pets_rounded,
                    routeName: PetsDashboard.routeName,
                    color: Constants.kPrimaryColor,
                  ),
                  SizedBox(
                    height: SizeConfig.getProportionateScreenHeight(25),
                  ),
                  MenuButton(
                    sizeConfig: sizeConfig,
                    label: 'Servicios',
                    icon: Icons.store,
                    routeName: "",
                    color: Constants.kPrimaryColor,
                  ),
                  SizedBox(
                    height: SizeConfig.getProportionateScreenHeight(25),
                  ),
                  MenuButton(
                    sizeConfig: sizeConfig,
                    label: 'Cuidados',
                    icon: Icons.favorite,
                    routeName: "",
                    color: Constants.kPrimaryColor,
                  ),
                  SizedBox(
                    height: SizeConfig.getProportionateScreenHeight(25),
                  ),
                  MenuButton(
                    sizeConfig: sizeConfig,
                    label: 'Agenda',
                    icon: Icons.calendar_today,
                    routeName: AgendaScreen.routeName,
                    color: Constants.kPrimaryColor,
                  ),
                  SizedBox(
                    height: SizeConfig.getProportionateScreenHeight(25),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
