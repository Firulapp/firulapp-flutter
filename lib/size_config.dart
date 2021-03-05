import 'package:flutter/material.dart';
import 'dart:math' as math;

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double _screenWidth, _screenHeight, _diagonal;
  static double defaultSize;
  static Orientation orientation;

  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;
  double get diagonal => _diagonal;

  //static SizeConfig of(BuildContext context) => SizeConfig();

  //Siempre llamar esta funcion en la primera pantalla de la app
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    Size size = _mediaQueryData.size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    orientation = _mediaQueryData.orientation;
    //cˆ2=aˆ2+bˆ2 => c = art(aˆ2+bˆ2)
    _diagonal =
        math.sqrt(math.pow(_screenWidth, 2) + math.pow(_screenHeight, 2));
  }

  // valor del ancho con respecto a un porcentaje
  double wp(double percent) => _screenWidth * percent / 100;
  // valor del alto con respecto a un porcentaje
  double hp(double percent) => screenHeight * percent / 100;
  // valor de la diagonal con respecto a un porcentaje
  double dp(double percent) => diagonal * percent / 100;
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig._screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate width as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig._screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
