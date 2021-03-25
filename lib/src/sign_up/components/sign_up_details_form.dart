import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../home/home.dart';
import '../../../provider/session.dart';
import '../../../provider/user.dart';
import '../../../components/dialogs.dart';
import '../../../components/default_button.dart';
import '../../../components/input_text.dart';
import '../../mixins/validator_mixins.dart';
import '../../../size_config.dart';
import '../../../constants/constants.dart';

class SignUpDetailsForm extends StatelessWidget {
  static const routeName = "/sign_up/step2";
  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig.wp(4.5),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: sizeConfig.hp(4)), // 4%
                  Text("Registrar Cuenta", style: headingStyle),
                  Text("Complete sus datos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: sizeConfig.wp(4),
                      )),
                  SizedBox(height: sizeConfig.hp(6)),
                  Body(),
                  SizedBox(height: sizeConfig.hp(5)),
                  Text(
                    'Al continuar, confirma que está de acuerdo \ncon nuestros Términos y condiciónes',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: sizeConfig.hp(1.7)),
                  ),
                  SizedBox(height: sizeConfig.hp(2)),
                ],
              ),
            ),
          ),
        ),
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
  String _username;
  String _name;
  String _surname;
  String _documentType;
  String _document;
  int _city;
  String _birthDate;
  final df = new DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1940),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        _birthDate = currentDate.toIso8601String();
      });
  }

  @override
  Widget build(BuildContext context) {
    var _isLoading = false;
    final _userCredentials =
        ModalRoute.of(context).settings.arguments as UserCredentials;
    final _user = Provider.of<User>(context, listen: false);
    return _isLoading
        ? CircularProgressIndicator()
        : Form(
            key: _formKey,
            child: Column(children: [
              buildUsernameFormField(
                "Usuario",
                "Ingrese un nombre de usuario",
                TextInputType.name,
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              buildNameFormField(
                "Nombre",
                "Ingrese su primer nombre",
                TextInputType.name,
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              buildSurnameFormField(
                "Apellido",
                "Ingrese su apellido",
                TextInputType.name,
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              buildDropdown(
                _user.getDocumentTypeOptions(),
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              buildDocumentFormField(
                "Documento de identidad",
                "Ingrese su documento",
                TextInputType.number,
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              buildCityFormField(
                "Ciudad",
                "Ingrese una ciudad",
                TextInputType.number,
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text("Fecha de nacimiento"),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        df.format(currentDate),
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              DefaultButton(
                text: "Registrar",
                press: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  final isOK = _formKey.currentState.validate();
                  if (isOK) {
                    try {
                      _user.addUser(
                        UserData(
                          id: null,
                          userId: null,
                          mail: _userCredentials.mail,
                          encryptedPassword: _userCredentials.encryptedPassword,
                          confirmPassword: _userCredentials.confirmPassword,
                          userName: _username,
                          birthDate: _birthDate,
                          city: _city,
                          documentType: _documentType,
                          document: _document,
                          name: _name,
                          surname: _surname,
                          notifications: true,
                          profilePicture: null,
                        ),
                      );
                      await Provider.of<Session>(context, listen: false)
                          .register(userData: _user.userData);
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

  Widget buildSurnameFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _surname = newValue,
    );
  }

  Widget buildBirthdateFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      onChanged: (newValue) => _birthDate = newValue,
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
      onChanged: (newValue) => _documentType = newValue,
      hint: const Text("Tipo de documento"),
    );
  }
}
