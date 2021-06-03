import 'package:firulapp/provider/pets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LostPetForm extends StatefulWidget {
  static const routeName = "/lost_pet_form";

  @override
  _LostPetFormState createState() => _LostPetFormState();
}

class _LostPetFormState extends State<LostPetForm> {
  Future _petsFuture;
  int _petId;

  @override
  void initState() {
    _petsFuture = Provider.of<Pets>(context, listen: false).fetchPetList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _petsFuture,
      builder: (_, dataSnapshot) {
        return Consumer<Pets>(
          builder: (ctx, providerData, child) => DropdownButtonFormField(
            items: providerData.items
                .map(
                  (pet) => DropdownMenuItem(
                    value: pet.id,
                    child: Text(pet.name),
                  ),
                )
                .toList(),
            value: _petId,
            onChanged: (newValue) => _petId = newValue,
            hint: const Text("Mascota"),
          ),
        );
      },
    );
  }
}
