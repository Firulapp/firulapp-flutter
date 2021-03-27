import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import '../../../constants/constants.dart';

class ProfilePhoto extends StatefulWidget {
  final Function onSelectImage;
  ProfilePhoto(this.onSelectImage);

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  File _storedImage;
  final imagePicker = ImagePicker();

  Future _getImage(bool fromCamera) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    File imageFile;
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    } else {
      return;
    }
    setState(() {
      if (pickedFile != null) {
        _storedImage = imageFile;
      }
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: const Text('Galería'),
                    onTap: () {
                      _getImage(false);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: const Text('Cámara'),
                  onTap: () {
                    _getImage(true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _storedImage != null
                              ? FileImage(_storedImage)
                              : AssetImage("assets/images/default-avatar.png"),
                          fit: BoxFit.cover,
                          alignment: Alignment.center),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 90.0, right: 100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoButton(
                      child: Container(
                        child: CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          radius: 25.0,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        _showPicker(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
