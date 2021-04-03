import 'package:flutter/material.dart';

import 'add_pets.dart';

class PetsBody extends StatefulWidget {
  PetsBody({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<PetsBody> {
  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Column(
        children: <Widget>[
          TextButton.icon(
            label: Text('Agregar mascota'),
            icon: Icon(
              Icons.add,
            ),
            onPressed: () => Navigator.pushNamed(context, AddPets.routeName),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20),
              children:
                  _getListings(), // <<<<< Note this change for the return type
            ),
          )
        ],
      ),
    ));
  }

  List<Widget> _getListings() {
    // <<<<< Note this change for the return type
    List listings = List<Widget>();

    listings.add(ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://ar.zoetis.com/_locale-assets/mcm-portal-assets/publishingimages/especie/caninos_perro_img.png',
        ),
      ),
      title: Text('Firulains'),
      onTap: () {},
      trailing: Icon(Icons.keyboard_arrow_right),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
    ));

    listings.add(ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://ar.zoetis.com/_locale-assets/mcm-portal-assets/publishingimages/especie/caninos_perro_img.png',
        ),
      ),
      title: Text('Perris'),
      onTap: () {},
      trailing: Icon(Icons.keyboard_arrow_right),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
    ));

    return listings;
  }
}
