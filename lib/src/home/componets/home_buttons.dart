import 'package:firulapp/size_config.dart';
import '../../pets/pets_scream.dart';
import '../../constants.dart';
import 'package:flutter/material.dart';

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    final double _elevation = sizeConfig.wp(1.5);
    final double _sizeBotton = sizeConfig.dp(7);
    final double _sizeTextBotton = sizeConfig.dp(2);
    return Column(
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
            )),
        RawMaterialButton(
          onPressed: () => {Navigator.pushNamed(context, PetsScreen.routeName)},
          elevation: _elevation,
          fillColor: kPrimaryColor,
          child: Icon(
            Icons.pets_rounded,
            size: _sizeBotton,
          ),
          padding: EdgeInsets.all(sizeConfig.dp(3)),
          shape: CircleBorder(),
        ),
        Text('Mascotas', style: TextStyle(fontSize: _sizeTextBotton)),
        Padding(padding: EdgeInsets.all(16.0)),
        RawMaterialButton(
          onPressed: () {},
          elevation: _elevation,
          fillColor: kPrimaryColor,
          child: Icon(
            Icons.store,
            size: _sizeBotton,
          ),
          padding: EdgeInsets.all(sizeConfig.dp(3)),
          shape: CircleBorder(),
        ),
        Text('Servicios', style: TextStyle(fontSize: _sizeTextBotton)),
        Padding(padding: EdgeInsets.all(16.0)),
        RawMaterialButton(
          onPressed: () {},
          elevation: _elevation,
          fillColor: kPrimaryColor,
          child: Icon(
            Icons.favorite,
            size: _sizeBotton,
          ),
          padding: EdgeInsets.all(sizeConfig.dp(3)),
          shape: CircleBorder(),
        ),
        Text('Cuidados', style: TextStyle(fontSize: _sizeTextBotton)),
      ],
    );
  }
}
