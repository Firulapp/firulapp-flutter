import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/no_account_text.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sizeConfig.wp(4.5)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: sizeConfig.hp(4)),
                SvgPicture.asset(
                  'assets/icons/Firulapp-icono.svg',
                  height: sizeConfig.hp(25),
                ),
                Text(
                  "Bienvenido/a",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeConfig.hp(4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Inicie sesión con su correo electrónico y contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: sizeConfig.wp(5)),
                ),
                SizedBox(height: sizeConfig.wp(1)),
                SingForm(),
                SizedBox(height: sizeConfig.wp(4)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
