import 'package:flutter/material.dart';

import '../size_config.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key key,
    this.sizeConfig,
    this.label,
    this.icon,
    this.routeName,
    this.color,
  }) : super(key: key);
  final SizeConfig sizeConfig;
  final String label;
  final IconData icon;
  final String routeName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          onPressed: () => {
            Navigator.pushNamed(context, routeName),
          },
          elevation: sizeConfig.wp(1.5),
          fillColor: color,
          child: Icon(
            icon,
            size: sizeConfig.dp(7),
          ),
          padding: EdgeInsets.all(sizeConfig.dp(3)),
          shape: CircleBorder(),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: sizeConfig.dp(2),
          ),
        )
      ],
    );
  }
}
