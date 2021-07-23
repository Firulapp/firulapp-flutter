import 'package:flutter/material.dart';

import '../size_config.dart';

class Constants {
  static const kPrimaryColor = Color(0xFFFDBE83);
  static const kPrimaryLightColor = Color(0xFFFFECDF);
  static const lightBackgroundColor = Color(0XFFFFFAF6);
  static const kSecondaryColor = Color(0xFF00A2D3);
  static const kTextColor = Color(0xFF757575);

  static const kAnimationDuration = Duration(milliseconds: 200);

  static final headingStyle = TextStyle(
    fontSize: SizeConfig.getProportionateScreenWidth(28),
    fontWeight: FontWeight.bold,
    color: Colors.black,
    height: 1.5,
  );

  static const defaultDuration = Duration(milliseconds: 250);

// Form Error
  static final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static const String kEmailNullError = "Por favor, ingrese su Email";
  static const String kInvalidEmailError = "Por favor, ingrese un Email valido";
  static const String kPassNullError = "Por favor, ingrese su contraseña";
  static const String kShortPassError = "Contraseña muy corta";
  static const String kMatchPassError = "Las contraseñas no coinciden";
  static const String kNamelNullError = "Por favor, escriba su nombre";
  static const String kPhoneNumberNullError =
      "Por favor,introduzca su número de teléfono";
  static const String kAddressNullError = "Por favor, Ingrese su dirección";
  static const String kTextNotNull = "Este campo es obligatorio";
  static const String kDisableUser =
      "El usuario esta en revision, espere aprobación del administrador";

  static final otpInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
        vertical: SizeConfig.getProportionateScreenWidth(15)),
    border: outlineInputBorder(),
    focusedBorder: outlineInputBorder(),
    enabledBorder: outlineInputBorder(),
  );

  static OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(SizeConfig.getProportionateScreenWidth(15)),
      borderSide: BorderSide(color: kTextColor),
    );
  }
}
