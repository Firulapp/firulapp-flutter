import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../components/dialogs.dart';
import '../../provider/species.dart';
import '../../components/input_text.dart';
import '../../provider/pet_service.dart';
import '../../provider/service_type.dart';
import '../mixins/validator_mixins.dart';
import '../../components/default_button.dart';
import '../../size_config.dart';
import '../../constants/constants.dart';
import './book_appointment.dart';

class ServiceScreen extends StatefulWidget {
  static const routeName = "/selected-service";

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> with ValidatorMixins {
  PetServiceItem _petService = new PetServiceItem();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final serviceId = ModalRoute.of(context).settings.arguments as int;
    _petService = Provider.of<PetService>(
      context,
      listen: false,
    ).getLocalServiceById(serviceId);
    final species = Provider.of<Species>(context, listen: false)
        .getLocalSpeciesItemById(_petService.speciesId);
    final serviceType = ServiceType.DUMMY_CATEGORIES
        .firstWhere((element) => element.id == _petService.category);
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: Text(_petService.title),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildField(
                            "Tipo de Servicio",
                            serviceType.title,
                          ),
                          SizedBox(
                            height: SizeConfig.getProportionateScreenHeight(25),
                          ),
                          buildField(
                            "Especie",
                            species.name,
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
                            "Precio en Guaranies",
                            "Ingrese el precio en guaranies",
                            TextInputType.number,
                          ),
                          SizedBox(
                            height: SizeConfig.getProportionateScreenHeight(25),
                          ),
                          buildAddressFormField(
                            "Dirección",
                            "Ingrese la dirección donde ofrece el servicio",
                            TextInputType.number,
                          ),
                          SizedBox(
                            height: SizeConfig.getProportionateScreenHeight(25),
                          ),
                          buildField(
                            "Contacto del proveedor",
                            _petService.email,
                          ),
                          SizedBox(
                            height: SizeConfig.getProportionateScreenHeight(25),
                          ),
                          DefaultButton(
                            text: "Reservar Turno",
                            color: Constants.kPrimaryColor,
                            press: () async {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                Navigator.pushNamed(
                                    context, BookAppointment.routeName,
                                    arguments: _petService.id);
                              } catch (error) {
                                print(error);
                                Dialogs.info(
                                  context,
                                  title: 'ERROR',
                                  content: error.response.data["message"],
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildAddressFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      value: _petService.address,
      enabled: false,
    );
  }

  Widget buildField(String label, String value) {
    return InputText(
      label: label,
      value: value,
      enabled: false,
    );
  }

  Widget buildTitleFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      value: _petService.title,
      enabled: false,
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
      enabled: false,
    );
  }

  Widget buildPriceFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      keyboardType: tipo,
      hintText: hint,
      enabled: false,
      value: _petService.price == null ? '' : _petService.price.toString(),
    );
  }

  DropdownButtonFormField buildCategoryDropdown(List<ServiceType> categories) {
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
      value: _petService.category,
      onChanged: (newValue) => _petService.category = newValue,
      hint: const Text("Tipo de servicio"),
    );
  }
}
