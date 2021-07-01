import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/provider/session.dart';
import 'package:firulapp/src/home/home.dart';
import 'package:flutter/material.dart';

import 'package:firulapp/components/custom_surfix_icon.dart';
import 'package:firulapp/components/default_button.dart';
import 'package:firulapp/components/input_text.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/user.dart';
import 'package:firulapp/src/mixins/validator_mixins.dart';
import 'package:provider/provider.dart';
import '../../../../components/dropdown/item_selection_screen.dart';
import '../../../../components/dropdown/listtile_item.dart';
import '../../../../provider/city.dart';
import '../../../../size_config.dart';

class OrganizationSignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<OrganizationSignUpForm>
    with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Body(),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;
  String _username;
  String _name;
  String _phoneNumber;
  String _description = "";
  String _documentType = 'RUC';
  String _document;
  String _type;
  int _city;
  CityItem _cityItem;

  Future _citiesFuture;

  Future _obtainCitiesFuture() {
    return Provider.of<City>(context, listen: false).fetchCities();
  }

  @override
  void initState() {
    _citiesFuture = _obtainCitiesFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _isLoading = false;
    final _user = Provider.of<User>(context, listen: false);
    return _isLoading
        ? CircularProgressIndicator()
        : Form(
            key: _formKey,
            child: Column(children: [
              buildEmailFormField(),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
              buildPasswordFormField(),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
              buildConformPassFormField(),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
              buildUsernameFormField(
                "Usuario",
                "Ingrese un nombre de usuario",
                TextInputType.name,
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),
              buildNameFormField(
                "Nombre",
                "Ingrese su primer nombre",
                TextInputType.name,
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),
              buildPhoneNumberFormField(
                "Teléfono",
                "0981-123456",
                TextInputType.name,
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),
              buildDropdownTypeOrganization(
                _user.getOrganizationTypeOptions(),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(25)),
              buildDropdown(
                _user.getDocumentTypeOptions(),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(15)),
              buildDocumentFormField(
                "Numero de RUC",
                "Ingrese su RUC",
                TextInputType.number,
              ),
              FutureBuilder(
                future: _citiesFuture,
                builder: (_, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text("Loading..."),
                    );
                  } else {
                    return Consumer<City>(
                      builder: (ctx, listCities, _) {
                        final list = listCities.toGenericFormItem();
                        return buildSingleCity(list);
                      },
                    );
                  }
                },
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(15)),
              buildDescriptionFormField(
                label: "Descripción",
                hint: "Ingrese una description",
                tipo: TextInputType.multiline,
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(15)),
              DefaultButton(
                text: "Registrar",
                color: Constants.kPrimaryColor,
                press: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  if (_document == null) {
                    Dialogs.info(
                      context,
                      title: "ERROR",
                      content: "Debe completar un RUC",
                    );
                    return;
                  }
                  final isOK = _formKey.currentState.validate();
                  if (isOK) {
                    try {
                      _user.addUser(
                        UserData(
                          id: null,
                          userId: null,
                          mail: _email,
                          encryptedPassword: _password,
                          confirmPassword: _confirmPassword,
                          userName: _username,
                          phoneNumber: _phoneNumber,
                          birthDate: null,
                          city: _city,
                          documentType: _documentType,
                          document: _document,
                          name: _name,
                          surname: null,
                          notifications: true,
                          profilePicture: null,
                          userType: 'ORGANIZACION',
                        ),
                      );
                      _user.addOrganization(
                        OrganizationData(
                          id: null,
                          userId: null,
                          type: _type,
                          organizationName: _name,
                          email: _email,
                          description: _description,
                          ruc: _document,
                          status: null,
                        ),
                      );
                      await Provider.of<Session>(context, listen: false)
                          .registerOrganizacion(
                        userData: _user.userData,
                        organizationData: _user.organizationData,
                      );
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routeName, (_) => false);
                    } catch (error) {
                      Dialogs.info(
                        context,
                        title: "ERROR",
                        content: error.response.data["message"],
                      );
                    }
                  }
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
            ]),
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
        _city = item.id;
      });
    };
    if (_city != null) {
      _cityItem = Provider.of<City>(
        context,
        listen: false,
      ).getLocalCityItemById(_city);
    }

    return buildPicker(
      title: 'Selecciona una Ciudad',
      child: _cityItem == null
          ? buildListTile(title: 'Ninguna Ciudad', onTap: onTap)
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
              fontSize: 5,
            ),
          ),
          SizedBox(height: SizeConfig().hp(2)),
          Card(
            margin: EdgeInsets.zero,
            child: child,
          ),
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
      ),
      trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
    );
  }

  Widget buildConformPassFormField() {
    return InputText(
        label: "Confirmar Contraseña",
        hintText: "Re-ingrese su contraseña",
        obscureText: true,
        onSaved: (newValue) => _confirmPassword = newValue,
        onChanged: (value) {
          if (value.isNotEmpty && _password == _confirmPassword) {
            return Constants.kMatchPassError;
          }
          _confirmPassword = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return Constants.kPassNullError;
          } else if ((_password != value)) {
            return Constants.kMatchPassError;
          }
          return null;
        },
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"));
  }

  Widget buildPasswordFormField() {
    return InputText(
      label: "Contraseña",
      hintText: "Ingresa tu contraseña",
      obscureText: true,
      onChanged: (value) => _password = value,
      validator: validatePassword,
      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
    );
  }

  Widget buildEmailFormField() {
    return InputText(
      label: "Correo",
      hintText: "Ingrese su correo",
      keyboardType: TextInputType.emailAddress,
      onChanged: (newValue) => _email = newValue,
      validator: validateEmail,
      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
    );
  }

  Widget buildUsernameFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _username = newValue,
    );
  }

  Widget buildCityFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _city = int.parse(newValue),
    );
  }

  Widget buildDocumentFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _document = newValue,
    );
  }

  Widget buildNameFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _name = newValue,
    );
  }

  Widget buildPhoneNumberFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _phoneNumber = newValue,
    );
  }

  DropdownButtonFormField buildDropdown(List<String> documentType) {
    List<DropdownMenuItem> _typeOptions = [];
    documentType.forEach((type) {
      _typeOptions.add(
        DropdownMenuItem(
          child: Text(type),
          value: type,
        ),
      );
    });
    return DropdownButtonFormField(
      items: _typeOptions,
      value: 'RUC',
      onChanged: (newValue) => _documentType = newValue,
      hint: const Text("Tipo de documento"),
    );
  }

  DropdownButtonFormField buildDropdownTypeOrganization(
      List<String> documentType) {
    List<DropdownMenuItem> _typeOptions = [];
    documentType.forEach((type) {
      _typeOptions.add(
        DropdownMenuItem(
          child: Text(type),
          value: type,
        ),
      );
    });
    return DropdownButtonFormField(
      items: _typeOptions,
      onChanged: (newValue) => _type = newValue,
      hint: const Text("Tipo de Organizacion"),
    );
  }

  Widget buildDescriptionFormField(
      {String label, String hint, TextInputType tipo}) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 100,
      value: _description,
      onChanged: (newValue) => _description = newValue,
    );
  }
}
