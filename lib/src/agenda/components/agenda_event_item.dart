import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/pets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AgendaEventItem extends StatelessWidget {
  final dynamic event;
  final ValueSetter<PetItem> onTap;

  AgendaEventItem({
    this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final _pet = Provider.of<Pets>(context, listen: false)
        .getLocalPetById(event["petId"]);
    return GestureDetector(
      onTap: () => onTap(_pet),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          elevation: 3,
          child: ListTile(
            leading: event["petVaccinationRecordId"] != null
                ? SvgPicture.asset(
                    "assets/icons/syringe.svg",
                    color: Constants.kPrimaryColor,
                    width: 35,
                  )
                : event["activityId"] != null
                    ? SvgPicture.asset(
                        "assets/icons/play-with-pet.svg",
                        color: Constants.kPrimaryColor,
                        width: 35,
                      )
                    : SvgPicture.asset(
                        "assets/icons/medical-check.svg",
                        color: Constants.kPrimaryColor,
                        width: 35,
                      ),
            title: Text(event["details"]),
            subtitle: Text(_pet.name),
          ),
        ),
      ),
    );
  }
}
