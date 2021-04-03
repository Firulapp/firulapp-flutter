import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../size_config.dart';

class PetImage extends StatelessWidget {
  final String url;
  final VoidCallback onPressed; // es lo mismo que "void Funtion()"

  const PetImage({Key key, this.url, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    Future _initialImage;
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
                  FutureBuilder(
                    future: _initialImage,
                    builder: (_, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/default-avatar.png"),
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
                            width: sizeConfig.wp(38),
                            height: sizeConfig.hp(17),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/default-avatar.png"),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center),
                            ),
                          );
                        }
                      }
                    },
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
                        //   _showPicker(context);
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
}
