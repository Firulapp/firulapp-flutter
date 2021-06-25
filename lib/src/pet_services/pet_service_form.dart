import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/provider/species.dart';
import 'package:flutter/material.dart';

import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/provider/pet_service.dart';
import 'package:firulapp/src/mixins/validator_mixins.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';

class PetServiceForm extends StatefulWidget {
  static const routeName = "/pet-service-form";
  @override
  _PetServiceFormState createState() => _PetServiceFormState();
}

class _PetServiceFormState extends State<PetServiceForm> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  PetServiceItem _petService = new PetServiceItem();
  Future _initialSpecies;
  String _category;
  int _speciesId;

  Future<void> _getListSpecies() async {
    try {
      Provider.of<Species>(context, listen: false).getSpecies();
    } catch (e) {
      Dialogs.info(
        context,
        title: 'ERROR',
        content: e.toString(),
      );
    }
  }

  @override
  void initState() {
    _initialSpecies = _getListSpecies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario Consulta Médica"),
      ),
      body: ListView(
        children: [
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sizeConfig.wp(4.5),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildCategoryDropdown(
                        CategoryItem.DUMMY_CATEGORIES,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: FutureBuilder(
                            future: _initialSpecies,
                            builder: (_, dataSnapshot) {
                              if (dataSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text("Loading..."),
                                );
                              } else {
                                return Consumer<Species>(
                                  builder: (ctx, listSpecies, _) =>
                                      DropdownButtonFormField(
                                    hint: _speciesId == null
                                        ? Text('Elija una especie')
                                        : null,
                                    items: listSpecies.items
                                        .map((e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.name),
                                            ))
                                        .toList(),
                                    onChanged: (newValue) =>
                                        _speciesId = newValue,
                                    value: _speciesId,
                                    isExpanded: true,
                                  ),
                                );
                              }
                            }),
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildTitleFormField(
                        "Titulo del servicio",
                        "Ingrese el titulo del servicio que ofrecerá",
                        TextInputType.name,
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildDescriptionFormField(
                        "Descripción",
                        "Ingrese una descripción para el servicio a ofrecer",
                        TextInputType.multiline,
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildPriceFormField(
                        "Precio",
                        "Ingrese el precio en guaranies",
                        TextInputType.number,
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                      buildContactFormField(
                        "Contacto",
                        TextInputType.name,
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(25),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContactFormField(String label, TextInputType tipo) {
    return InputText(
      label: label,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: "correodelamigo@gmail.com",
      enabled: false,
    );
  }

  Widget buildTitleFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _petService.title,
      onChanged: (newValue) => _petService.title = newValue,
    );
  }

  Widget buildDescriptionFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      value: _petService.description,
      onChanged: (newValue) => _petService.description = newValue,
    );
  }

  Widget buildPriceFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      keyboardType: tipo,
      hintText: hint,
      validator: validateTextNotNull,
      value: _petService.price == null ? '' : _petService.price.toString(),
      onChanged: (newValue) => _petService.price = double.parse(newValue),
    );
  }

  DropdownButtonFormField buildCategoryDropdown(List<CategoryItem> categories) {
    List<DropdownMenuItem> _typeOptions = [];
    categories.forEach((category) {
      _typeOptions.add(
        DropdownMenuItem(
          child: Text(category.title),
          value: category.id,
        ),
      );
    });
    return DropdownButtonFormField(
      items: _typeOptions,
      onChanged: (newValue) => _category = newValue,
      hint: const Text("Tipo de servicio"),
    );
  }
}
