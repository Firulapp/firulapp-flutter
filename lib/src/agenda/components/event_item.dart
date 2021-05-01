import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/constants.dart';

class EventItem extends StatelessWidget {
  final String title;
  final String icon;
  final String routeName;

  EventItem(
    this.title,
    this.icon,
    this.routeName,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
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
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  icon,
                  color: Constants.kPrimaryColor,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
