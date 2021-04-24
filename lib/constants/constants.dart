import 'package:flutter/material.dart';

import '../size_config.dart';

const kPrimaryColor = Color(0xFFFDBE83);
const kPrimaryLightColor = Color(0xFFFFECDF);
var kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const lightBackgroundColor = Color(0XFFFFFAF6);
const kSecondaryColor = Color(0xFF00A2D3);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: SizeConfig.getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Por favor, ingrese su Email";
const String kInvalidEmailError = "Por favor, ingrese un Email valido";
const String kPassNullError = "Por favor, ingrese su contraseña";
const String kShortPassError = "Contraseña muy corta";
const String kMatchPassError = "Las contraseñas no coinciden";
const String kNamelNullError = "Por favor, escriba su nombre";
const String kPhoneNumberNullError =
    "Por favor,introduzca su número de teléfono";
const String kAddressNullError = "Por favor, Ingrese su dirección";
const String kTextNotNull = "Este campo es obligatorio";

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
      vertical: SizeConfig.getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius:
        BorderRadius.circular(SizeConfig.getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
