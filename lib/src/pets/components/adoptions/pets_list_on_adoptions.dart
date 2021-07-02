import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/provider/user.dart';
import 'package:firulapp/src/pets/components/adoptions/pet_in_adoption.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';

import '../../../../provider/pets.dart';

class PetsListAdoptions extends StatefulWidget {
  PetsListAdoptions({Key key}) : super(key: key);

  @override
  _PetsListAdoptionsState createState() => _PetsListAdoptionsState();
}

class _PetsListAdoptionsState extends State<PetsListAdoptions> {
  Future _petsFuture;
  Directory tempPath;

  Future _obtainPetsFuture() {
    return Provider.of<Pets>(context, listen: false)
        .fetchPetListByStatus(status: "ADOPTAR");
  }

  Future _obtainTempPath() async {
    tempPath = await syspaths.getTemporaryDirectory();
  }

  @override
  void initState() {
    Provider.of<Pets>(context, listen: false).fetchPetList();
    _petsFuture = _obtainPetsFuture();
    _obtainTempPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _petsFuture,
      builder: (_, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return ListView(
            padding: EdgeInsets.symmetric(vertical: 20),
            children: const <Widget>[
              Center(child: CircularProgressIndicator())
            ],
          );
        } else {
          return Consumer<Pets>(
            builder: (context, providerData, _) => ListView.builder(
              itemCount: providerData.petsByStatus.length,
              itemBuilder: (context, i) {
                return _getListings(providerData.petsByStatus[i]);
              },
            ),
          );
        }
      },
    );
  }

  Widget _getListings(PetItem pet) {
    File _petImage;
    String _base64 = pet.picture;
    String name = pet.name;
    _petImage = _getFilePicture(_base64, name);
    return Container(
      height: 100,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        elevation: 6,
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              minRadius: 20,
              maxRadius: 30,
              backgroundImage: _petImage != null
                  ? FileImage(
                      _petImage,
                    )
                  : AssetImage(
                      "assets/images/default-avatar.png",
                    ),
            ),
            title: Center(
              child: Column(
                children: [
                  Text(
                    "$name",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  CupertinoButton(
                    child: Text("VER PERFIL"),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        PetInAdoption.routeName,
                        arguments: pet.id,
                      );
                    },
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
          ),
        ),
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
