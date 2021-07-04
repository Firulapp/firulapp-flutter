import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter/material.dart';

import '../../../provider/pets.dart';

class PetOption extends StatefulWidget {
  final PetItem petItem;
  final ValueSetter<PetItem> onTap;

  PetOption({
    this.petItem,
    this.onTap,
  });

  @override
  _PetOptionState createState() => _PetOptionState();
}

class _PetOptionState extends State<PetOption> {
  Directory tempPath;
  File _petImage;
  Future _initialImage;

  @override
  void initState() {
    _initialImage = _initiateStoredImage();
    super.initState();
  }

  Future _initiateStoredImage() async {
    File _storedImage;
    String _base64 = widget.petItem.picture;
    if (_base64 != null) {
      final tempPath = await syspaths.getTemporaryDirectory();
      Uint8List bytes = base64Decode(_base64);
      _storedImage =
          File('${tempPath.path}/${widget.petItem.name}-profile.png');
      _storedImage.writeAsBytes(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      FileImage(_storedImage).evict();
    }
    _petImage = _storedImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(widget.petItem),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        child: Container(
          width: 150,
          height: 100,
          margin: EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text(
                widget.petItem.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              FutureBuilder(
                future: _initialImage,
                builder: (_, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        minRadius: 20,
                        maxRadius: 30,
                        backgroundImage: AssetImage(
                          "assets/images/default-avatar.png",
                        ),
                      ),
                    );
                  } else {
                    if (dataSnapshot.error != null) {
                      return Center(
                        child: Text('Algo salio mal'),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
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
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
