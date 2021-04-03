import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../../../constants/constants.dart';
import '../../../size_config.dart';

class PetImage extends StatefulWidget {
  final Function onSelectImage;
  final bool status;
  PetImage({Key key, this.onSelectImage, this.status}) : super(key: key);

  @override
  _PetImageState createState() => _PetImageState();
}

class _PetImageState extends State<PetImage> {
  File _storedImage;
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
      // if (pickedFile != null) {
      _storedImage = imageFile;
      // }
    });
    // final tempPath = await syspaths.getTemporaryDirectory();
    // final savedImage = await imageFile.copy('${tempPath.path}/petProfile.png');
    // widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: sizeConfig.hp(0.7)),
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: sizeConfig.wp(38),
                    height: sizeConfig.hp(17),
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
                padding: EdgeInsets.only(
                    top: sizeConfig.hp(10), right: sizeConfig.dp(12)),
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
                        // if (!widget.status) {
                        _showPicker(context);
                        // }
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
}
