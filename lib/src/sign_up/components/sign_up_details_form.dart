import 'package:flutter/material.dart';
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
  String _city;
  String _birthDate;

  @override
  Widget build(BuildContext context) {
    final ProgressDialog progressDialog = ProgressDialog(context);
    final _userCredentials =
        ModalRoute.of(context).settings.arguments as UserCredentials;
    final _user = Provider.of<User>(context, listen: false);
    return Form(
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
        buildBirthdateFormField(
          "Fecha de nacimiento",
          "Ingrese su fecha de nacimiento",
          TextInputType.number,
        ),
        SizedBox(height: getProportionateScreenHeight(25)),
        DefaultButton(
          text: "Registrar",
          press: () {
            final isOK = _formKey.currentState.validate();
            if (isOK) {
              try {
                progressDialog.show();
                _user.addUser(
                  UserData(
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
                Provider.of<Session>(context, listen: false)
                    .register(userData: _user.userData);
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (_) => false);
              } catch (error) {
                progressDialog.dismiss();
                Dialogs.info(
                  context,
                  title: "ERROR",
                  content: error.data.message,
                );
              }
            }
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
      onChanged: (newValue) => _city = newValue,
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
