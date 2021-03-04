import 'package:flutter/material.dart';

import '../../../size_config.dart';
import '../../constants.dart';

class PhotoPerfil extends StatefulWidget {
  PhotoPerfil({Key key}) : super(key: key);

  @override
  _PhotoPerfilState createState() => _PhotoPerfilState();
}

class _PhotoPerfilState extends State<PhotoPerfil> {
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
                        image: AssetImage('assets/images/Profile Image.png'),
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
