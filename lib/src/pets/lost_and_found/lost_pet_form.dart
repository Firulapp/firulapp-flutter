import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/city.dart';
import 'package:firulapp/provider/pets.dart';
import 'package:firulapp/provider/reports.dart';
import 'package:firulapp/src/mixins/validator_mixins.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class LostPetForm extends StatefulWidget {
  static const routeName = "/lost_pet_form";

  @override
  _LostPetFormState createState() => _LostPetFormState();
}

class _LostPetFormState extends State<LostPetForm> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  ReportItem _report = new ReportItem();
  Future _petsFuture;
  Future _citiesFuture;
  int _petId;
  int _city;
  bool _isLoading = false;

  @override
  void initState() {
    _petsFuture = Provider.of<Pets>(context, listen: false).fetchPetList();
    _citiesFuture = Provider.of<City>(context, listen: false).fetchCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final point = ModalRoute.of(context).settings.arguments as GeographicPoints;
    _report.locationLatitude = double.parse(point.latitude);
    _report.locationLongitude = double.parse(point.longitude);
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportar Mascota Perdida"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
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
                            FutureBuilder(
                              future: _petsFuture,
                              builder: (_, dataSnapshot) {
                                return Consumer<Pets>(
                                  builder: (ctx, providerData, child) =>
                                      DropdownButtonFormField(
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
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildDetailFormField(
                              "Descripción sobre la pérdida",
                              "Ingrese el detalle sobre la pérdida de la mascota",
                              TextInputType.multiline,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildMainStreetFormField(
                              "Calle principal",
                              "Ingrese la calle principal",
                              TextInputType.name,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildSecondaryStreetFormField(
                              "Calle principal",
                              "Ingrese la calle principal",
                              TextInputType.name,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            FutureBuilder(
                              future: _citiesFuture,
                              builder: (_, dataSnapshot) {
                                return Consumer<City>(
                                  builder: (ctx, cityData, child) =>
                                      DropdownButtonFormField(
                                    items: cityData.cities
                                        .map(
                                          (city) => DropdownMenuItem(
                                            value: city.id,
                                            child: Text(city.name),
                                          ),
                                        )
                                        .toList(),
                                    value: _city,
                                    onChanged: (newValue) => _city = newValue,
                                    hint: const Text("Ciudad"),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            DefaultButton(
                              text: "Guardar",
                              color: Constants.kPrimaryColor,
                              press: () async {
                                final isOK = _formKey.currentState.validate();
                                if (isOK) {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                      _report.city = _city;
                                      _report.petId = _petId;
                                    });
                                    await Provider.of<Reports>(
                                      context,
                                      listen: false,
                                    ).saveReport(_report);
                                    Navigator.pop(context);
                                  } catch (error) {
                                    Dialogs.info(
                                      context,
                                      title: 'ERROR',
                                      content: error.response.data["message"],
                                    );
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
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

  Widget buildMainStreetFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      value: _report.mainStreet,
      onChanged: (newValue) => _report.mainStreet = newValue,
    );
  }

  Widget buildSecondaryStreetFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      value: _report.secondaryStreet,
      onChanged: (newValue) => _report.secondaryStreet = newValue,
    );
  }

  Widget buildDetailFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _report.description,
      maxLines: 10,
      onChanged: (newValue) => _report.description = newValue,
    );
  }
}
