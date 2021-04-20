import 'package:flutter/material.dart';

import '../../../size_config.dart';
import '../../pets/pets_screen.dart';
import '../../../constants/constants.dart';

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    return SizedBox(
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
                    color: kSecondaryColor,
                  ),
                ),
              ),
              buildButtonOption(sizeConfig, 'Mascotas', Icons.pets_rounded,
                  context, PetsScreen.routeName),
              SizedBox(
                height: getProportionateScreenHeight(25),
              ),
              buildButtonOption(
                  sizeConfig, 'Servicios', Icons.store, context, ""),
              SizedBox(
                height: getProportionateScreenHeight(25),
              ),
              buildButtonOption(
                  sizeConfig, 'Cuidados', Icons.favorite, context, ""),
              SizedBox(
                height: getProportionateScreenHeight(25),
              ),
              buildButtonOption(
                  sizeConfig, 'Agenda', Icons.calendar_today, context, ""),
              SizedBox(
                height: getProportionateScreenHeight(25),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonOption(
    SizeConfig sizeConfig,
    String label,
    IconData icon,
    BuildContext context,
    String routeName,
  ) {
    return Column(
      children: [
        RawMaterialButton(
          onPressed: () => {
            Navigator.pushNamed(context, routeName),
          },
          elevation: sizeConfig.wp(1.5),
          fillColor: kPrimaryColor,
          child: Icon(
            icon,
            size: sizeConfig.dp(7),
          ),
          padding: EdgeInsets.all(sizeConfig.dp(3)),
          shape: CircleBorder(),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: sizeConfig.dp(2),
          ),
        )
      ],
    );
  }
}
