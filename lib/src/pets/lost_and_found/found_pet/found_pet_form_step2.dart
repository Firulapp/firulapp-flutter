import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/city.dart';
import 'package:firulapp/provider/reports.dart';
import 'package:firulapp/src/mixins/validator_mixins.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../size_config.dart';

class FoundPetFormStep2 extends StatefulWidget {
  static const routeName = "/found_pet_form/step2";

  @override
  _FoundPetFormStep2State createState() => _FoundPetFormStep2State();
}

class _FoundPetFormStep2State extends State<FoundPetFormStep2>
    with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  ReportItem _report = new ReportItem();
  Future _citiesFuture;
  int _city;
  bool _isLoading = false;

  @override
  void initState() {
    _citiesFuture = Provider.of<City>(context, listen: false).fetchCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final foundReport =
        ModalRoute.of(context).settings.arguments as FoundPetReport;
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportar Mascota Encontrada, Paso 2"),
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
                              "Calle secundaria",
                              "Ingrese la calle secundaria",
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
                                      foundReport.report.city = _city;
                                      foundReport.report.mainStreet =
                                          _report.mainStreet;
                                      foundReport.report.description =
                                          _report.description;
                                      foundReport.report.secondaryStreet =
                                          _report.secondaryStreet;
                                    });
                                    await Provider.of<Reports>(
                                      context,
                                      listen: false,
                                    ).saveFoundReport(foundReport);
                                    int count = 0;
                                    Navigator.of(context)
                                        .popUntil((_) => count++ >= 2);
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
