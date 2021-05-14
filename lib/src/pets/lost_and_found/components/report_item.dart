import 'package:firulapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportItem extends StatelessWidget {
  final String title;
  final String icon;

  ReportItem({
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("option"),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        child: Container(
          width: 150,
          height: 125,
          margin: EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
                overflow: TextOverflow.clip,
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
