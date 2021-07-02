import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/dropdown/item_selection_screen.dart';
import 'package:firulapp/components/dropdown/listtile_item.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/city.dart';
import 'package:firulapp/provider/pets.dart';
import 'package:firulapp/provider/reports.dart';
import 'package:firulapp/provider/user.dart';
import 'package:firulapp/src/mixins/validator_mixins.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../size_config.dart';

class LostPetForm extends StatefulWidget {
  static const routeName = "/lost_pet_form";

  @override
  _LostPetFormState createState() => _LostPetFormState();
}

class _LostPetFormState extends State<LostPetForm> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  ReportItem _report = new ReportItem();
  Future _citiesFuture;
  int _petId;
  int _city;
  bool _isLoading = false;
  CityItem _cityItem;

  @override
  void initState() {
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
                            Consumer<Pets>(
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
                            Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: FutureBuilder(
                                future: _citiesFuture,
                                builder: (_, dataSnapshot) {
                                  if (dataSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: Text("Loading..."),
                                    );
                                  } else {
                                    return Consumer<City>(
                                      builder: (ctx, listCities, _) {
                                        final list =
                                            listCities.toGenericFormItem();
                                        return buildSingleCity(list);
                                      },
                                    );
                                  }
                                },
                              ),
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
                                    ).saveLostReport(_report);
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

  Widget buildSingleCity(List<ListTileItem> cities) {
    final onTap = () async {
      final item = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemSelectionScreen(
            allItems: cities,
            subject: 'Ciudad',
          ),
        ),
      ) as ListTileItem;

      if (item == null) return;

      setState(() {
        this._cityItem = CityItem(id: item.id, name: item.value);
      });
    };

    return buildPicker(
      title: 'Selecciona una Ciudad',
      child: _cityItem == null
          ? buildListTile(title: 'Elige una Ciudad', onTap: onTap)
          : buildListTile(
              title: _cityItem.name,
              onTap: onTap,
            ),
    );
  }

  Widget buildPicker({
    @required String title,
    @required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(margin: EdgeInsets.zero, child: child),
        ],
      );

  Widget buildListTile({
    @required String title,
    VoidCallback onTap,
    Widget leading,
  }) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
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
