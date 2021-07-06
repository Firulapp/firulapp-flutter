import 'package:firulapp/provider/pets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        return Consumer<Pets>(
          builder: (context, pet, _) => GestureDetector(
            onTap: () => widget.onTap(pet.petItem),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Card(
                elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.shopping_cart_outlined),
                  title: Text(widget.event["details"]),
                  subtitle: Text(pet.petItem.name),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
