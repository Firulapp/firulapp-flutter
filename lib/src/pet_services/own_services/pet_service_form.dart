import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../components/dialogs.dart';
import '../../../provider/species.dart';
import '../../../provider/user.dart';
import '../../../components/input_text.dart';
import '../../../provider/pet_service.dart';
import '../../../provider/service_type.dart';
import '../../mixins/validator_mixins.dart';
import '../../../components/default_button.dart';
import '../../../size_config.dart';
import '../../../constants/constants.dart';
import '../../../provider/agenda.dart';

class PetServiceForm extends StatefulWidget {
  static const routeName = "/pet-service-form";
  @override
  _PetServiceFormState createState() => _PetServiceFormState();
}

class _PetServiceFormState extends State<PetServiceForm> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  PetServiceItem _petService = new PetServiceItem();
  bool _isLoading = false;
  Future _initialSpecies;
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
    final serviceId = ModalRoute.of(context).settings.arguments as int;
    if (serviceId != null) {
      _petService = Provider.of<PetService>(
        context,
        listen: false,
      ).getLocalOwnServiceById(serviceId);
      if (_petService == null) {
        _petService = new PetServiceItem();
      }
    }
    final user = Provider.of<User>(context, listen: true);
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario Servicio"),
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
                            buildCategoryDropdown(
                              ServiceType.DUMMY_CATEGORIES,
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
                                          value: _petService.speciesId == null
                                              ? null
                                              : _petService.speciesId,
                                          isExpanded: true,
                                        ),
                                      );
                                    }
                                  }),
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildTitleFormField(
                              "Titulo del servicio",
                              "Ingrese el titulo del servicio que ofrecerá",
                              TextInputType.name,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildDescriptionFormField(
                              "Descripción",
                              "Ingrese una descripción para el servicio a ofrecer",
                              TextInputType.multiline,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildPriceFormField(
                              "Precio",
                              "Ingrese el precio en guaranies",
                              TextInputType.number,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildAddressFormField(
                              "Dirección",
                              "Ingrese la dirección donde ofrece el servicio",
                              TextInputType.number,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildContactFormField("Contacto",
                                TextInputType.name, user.userData.mail),
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
                                    });
                                    await Provider.of<PetService>(
                                      context,
                                      listen: false,
                                    ).save(_petService, _speciesId);
                                    Navigator.pop(context);
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
                                }
                              },
                            ),
                            _petService.id != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                          height: SizeConfig
                                              .getProportionateScreenHeight(
                                                  25)),
                                      DefaultButton(
                                        text: "Borrar",
                                        color: Colors.white,
                                        press: () async {
                                          final response = await Dialogs.alert(
                                            context,
                                            "¿Estás seguro que desea eliminar?",
                                            "Se borrará el registro del servicio",
                                            "Cancelar",
                                            "Aceptar",
                                          );
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          if (response) {
                                            try {
                                              await Provider.of<PetService>(
                                                context,
                                                listen: false,
                                              ).delete(_petService);
                                              await Provider.of<Agenda>(context,
                                                      listen: false)
                                                  .fetchEvents();
                                            } catch (error) {
                                              Dialogs.info(
                                                context,
                                                title: 'ERROR',
                                                content: error
                                                    .response.data["message"],
                                              );
                                            }
                                            Navigator.pop(context);
                                          }
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: SizeConfig
                                            .getProportionateScreenHeight(25),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height:
                                        SizeConfig.getProportionateScreenHeight(
                                      25,
                                    ),
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

  Widget buildContactFormField(String label, TextInputType tipo, String mail) {
    return InputText(
      label: label,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: mail,
      enabled: false,
    );
  }

  Widget buildAddressFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      value: _petService.address,
      onChanged: (newValue) => _petService.address = newValue,
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
      validator: validateTextNotNull,
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
      value: _petService.category == null ? null : _petService.category,
      onChanged: (newValue) => _petService.category = newValue,
      hint: const Text("Tipo de servicio"),
    );
  }
}
