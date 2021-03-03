import '../../../components/no_account_text.dart';

import '../../../size_config.dart';
import 'sign_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SvgPicture.asset(
                  'assets/icons/Firulapp-icono.svg',
                  height: 150,
                ),
                Text(
                  "Bienvenido/a",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Inicie sesión con su correo electrónico y contraseña',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 0.08),
                SingFrom(),
                SizedBox(height: 20),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
