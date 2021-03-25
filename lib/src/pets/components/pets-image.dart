import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class PetImage extends StatelessWidget {
  final String url;
  final VoidCallback onPressed; // es lo mismo que "void Funtion()"
  const PetImage({Key key, this.url, this.onPressed}) : super(key: key);

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
                          this.url ??
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
                    CupertinoButton(
                      child: Container(
                        child: CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          radius: 18.0,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: this.onPressed,
                    )
                  ],
                )),
          ]),
        )
      ],
    );
  }
}
