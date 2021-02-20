import 'package:firulapp/src/constants.dart';
import 'package:flutter/material.dart';

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Firulapp',
            style: TextStyle(
              fontSize: 30.1,
              color: kSecondaryColor,
            ),
          ),
          Padding(padding: EdgeInsets.all(16.0)),
          RawMaterialButton(
            onPressed: () {},
            elevation: 2.0,
            fillColor: kPrimaryColor,
            child: Icon(
              Icons.pets_rounded,
              size: 80.0,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
          Text('Mascotas'),
          Padding(padding: EdgeInsets.all(16.0)),
          RawMaterialButton(
            onPressed: () {},
            elevation: 2.0,
            fillColor: kPrimaryColor,
            child: Icon(
              Icons.store,
              size: 80.0,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
          Text('Servicios'),
          Padding(padding: EdgeInsets.all(16.0)),
          RawMaterialButton(
            onPressed: () {},
            elevation: 2.0,
            fillColor: kPrimaryColor,
            child: Icon(
              Icons.favorite,
              size: 80.0,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
          Text('Cuidados'),
        ],
      ),
    );
  }
}
