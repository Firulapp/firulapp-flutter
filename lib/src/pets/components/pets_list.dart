import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:firulapp/provider/pets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PetsList extends StatefulWidget {
  PetsList({Key key}) : super(key: key);

  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {
  Future _petsFuture;

  Future _obtainPetsFuture() {
    return Provider.of<Pets>(context, listen: false).fetchPetList();
  }

  @override
  void initState() {
    _petsFuture = _obtainPetsFuture();
    super.initState();
  }

  File _storedImage;
  @override
  Widget build(BuildContext context) {
    return Consumer<Pets>(
      builder: (context, providerData, _) => FutureBuilder(
        future: _petsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 20),
              children: const <Widget>[Center(child: Text("Loading..."))],
            );
          } else {
            return Consumer<Pets>(
              builder: (ctx, listPets, _) => ListView(
                padding: EdgeInsets.symmetric(vertical: 20),
                children: _getListings(lista: listPets.items),
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _getListings({List<PetItem> lista}) {
    List listings = List<Widget>();
    lista.forEach((e) {
      // String _base64 = e.picture;
      // // File _storedImage;
      // Uint8List bytes = base64Decode(_base64);
      // File _storedImage = Image.memory(bytes);
      listings.add(new ListTile(
        leading: CircleAvatar(
          backgroundImage: _storedImage != null
              ? FileImage(_storedImage)
              : AssetImage("assets/images/default-avatar.png"),
        ),
        title: Text(e.name),
        onTap: () {
          print("me llamo = " + e.name);
        },
        trailing: Icon(Icons.keyboard_arrow_right),
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
      ));
    });

    return listings;
  }
}
