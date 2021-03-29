import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firulapp/provider/user.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key key}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File _storedImage;
  Future _initialImage;

  @override
  void initState() {
    _initialImage = _initiateStoredImage();
    super.initState();
  }

  Future _initiateStoredImage() async {
    String base64 =
        Provider.of<User>(context, listen: false).userData.profilePicture;
    if (base64 == null) {
      return;
    }
    Uint8List bytes = base64Decode(base64);
    final tempPath = await syspaths.getTemporaryDirectory();
    _storedImage = File('${tempPath.path}/profile.png');
    await _storedImage.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    FileImage(_storedImage).evict();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        width: 150,
        child: FutureBuilder(
          future: _initialImage,
          builder: (_, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/default-avatar.png"),
                      fit: BoxFit.cover,
                      alignment: Alignment.center),
                ),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('Algo salio mal'),
                );
              } else {
                return Container(
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
                );
              }
            }
          },
        ));
  }
}
