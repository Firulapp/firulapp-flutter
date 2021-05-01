import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/agenda.dart';
import 'package:firulapp/provider/pets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AgendaEventItem extends StatelessWidget {
  final AgendaItem _event;

  AgendaEventItem(
    this._event,
  );

  @override
  Widget build(BuildContext context) {
    final _pet = Provider.of<Pets>(context).getLocalPetById(_event.petId);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: ListTile(
          leading: _event.petVaccinationRecordId != null
              ? SvgPicture.asset(
                  "assets/icons/syringe.svg",
                  color: Constants.kPrimaryColor,
                  width: 35,
                )
              : _event.activityId != null
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
          title: Text(_event.activityTitle),
          subtitle: Text(_pet.name),
        ),
      ),
    );
  }
}
