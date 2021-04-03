import 'package:firulapp/provider/pets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PetsList extends StatefulWidget {
  PetsList({Key key}) : super(key: key);

  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Pets>(
      builder: (context, providerData, _) => FutureBuilder(
        future: providerData.fetchPetList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 20),
              children: const <Widget>[Center(child: Text("Loading..."))],
            );
          }

          return Consumer<Pets>(
            builder: (ctx, listPets, _) => ListView(
              padding: EdgeInsets.symmetric(vertical: 20),
              children: _getListings(lista: listPets.items),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _getListings({List<PetItem> lista}) {
    List listings = List<Widget>();

    lista.forEach((e) {
      listings.add(new ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            'https://ar.zoetis.com/_locale-assets/mcm-portal-assets/publishingimages/especie/caninos_perro_img.png',
          ),
        ),
        title: Text(e.name),
        onTap: () {},
        trailing: Icon(Icons.keyboard_arrow_right),
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
      ));
    });

    return listings;
  }
}
