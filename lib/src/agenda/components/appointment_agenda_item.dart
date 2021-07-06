import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:firulapp/provider/pets.dart';
import 'package:firulapp/constants/constants.dart';

class AppointmentAgendaItem extends StatefulWidget {
  final dynamic event;
  final ValueSetter<PetItem> onTap;

  AppointmentAgendaItem({
    this.event,
    this.onTap,
  });

  @override
  _AppointmentAgendaItemState createState() => _AppointmentAgendaItemState();
}

class _AppointmentAgendaItemState extends State<AppointmentAgendaItem> {
  Future _petsFuture;

  @override
  void initState() {
    _petsFuture = Provider.of<Pets>(context, listen: false).getPetById(
      widget.event["petId"],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _petsFuture,
      builder: (_, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Consumer<Pets>(
            builder: (context, pet, _) => GestureDetector(
              onTap: () => widget.onTap(pet.petItem),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/icons/pet-shop.svg",
                      color: Constants.kPrimaryColor,
                      width: 35,
                      fit: BoxFit.cover,
                    ),
                    title: Text(widget.event["details"]),
                    subtitle: Text(pet.petItem.name),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
