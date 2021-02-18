import 'package:flutter/material.dart';

class homeButtons extends StatelessWidget {
  //const homeButtons({Key key}) : super(key: key);
  Color button_color = Color(0xFFFED9B7);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          //Padding(padding: EdgeInsets.all(16.0)),
          Text(
            'Firulapp',
            style: TextStyle(
                fontSize: 30.1,
                fontStyle: FontStyle.italic,
                color: Color(0XFF00AFB9)),
          ),
          Padding(padding: EdgeInsets.all(16.0)),
          RawMaterialButton(
            onPressed: () {},
            elevation: 2.0,
            fillColor: button_color,
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
            fillColor: button_color,
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
            fillColor: button_color,
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
