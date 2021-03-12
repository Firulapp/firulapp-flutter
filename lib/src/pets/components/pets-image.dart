import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class PetImage extends StatefulWidget {
  PetImage({Key key}) : super(key: key);

  @override
  _PhotoPerfilState createState() => _PhotoPerfilState();
}

class _PhotoPerfilState extends State<PetImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Stack(fit: StackFit.loose, children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://ar.zoetis.com/_locale-assets/mcm-portal-assets/publishingimages/especie/caninos_perro_img.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    )),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      radius: 25.0,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    )
                  ],
                )),
          ]),
        )
      ],
    );
  }
}
