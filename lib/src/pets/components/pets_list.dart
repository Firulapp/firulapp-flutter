import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/pets.dart';
import '../selected_pet_screen.dart';

class PetsList extends StatefulWidget {
  static const routeName = "/pets/list";
  PetsList({Key key}) : super(key: key);

  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {
  Future _petsFuture;
  Directory tempPath;

  // Future _obtainPetsFuture() {
  //   return Provider.of<Pets>(context, listen: false).fetchPetList();
  // }

  Future _obtainTempPath() async {
    tempPath = await syspaths.getTemporaryDirectory();
  }

  @override
  void initState() {
    // _petsFuture = _obtainPetsFuture();
    _obtainTempPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _petsFuture = Provider.of<Pets>(context, listen: true).fetchPetList();
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
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 20),
              itemCount: providerData.items.length,
              itemBuilder: (context, i) {
                return _getListings(providerData.items[i]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _getListings(PetItem pet) {
    File _petImage;
    String _base64 = pet.picture;
    String name = pet.name;
    _petImage = _getFilePicture(_base64, name);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 6,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: _petImage != null
              ? FileImage(_petImage)
              : AssetImage("assets/images/default-avatar.png"),
        ),
        title: Text(
          "$name",
          style: Theme.of(context).textTheme.headline6,
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            SelectedPetScreen.routeName,
            arguments: pet.id,
          );
        },
        trailing: IconButton(
          icon: Image.asset(
            "assets/images/delete.png",
          ),
          onPressed: () =>
              Provider.of<Pets>(context, listen: false).deletePet(pet.id),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
      ),
    );
  }

  File _getFilePicture(String _base64, String name) {
    File _storedImage;
    if (_base64 != null) {
      Uint8List bytes = base64Decode(_base64);
      _storedImage = File('${tempPath.path}/$name-profile.png');
      _storedImage.writeAsBytes(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      FileImage(_storedImage).evict();
    }
    return _storedImage;
  }
}
