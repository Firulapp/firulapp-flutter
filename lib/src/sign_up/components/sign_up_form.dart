import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../mixins/validator_mixins.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/input_text.dart';
import '../../../services/my_service.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _conformPassword;

  _submit() async {
    final isOK = _formKey.currentState.validate();
    if (isOK) {
      //_formKey.currentState.save();
      MyServices myServices = MyServices();
      await myServices.register(
        context,
        username: _email,
        email: _email,
        password: _password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: _submit,
          ),
        ],
      ),
    );
  }

  Widget buildConformPassFormField() {
    return InputText(
        label: "Confirmar Contraseña",
        hintText: "Re-ingrese su contraseña",
        obscureText: true,
        onSaved: (newValue) => _conformPassword = newValue,
        onChanged: (value) {
          if (value.isNotEmpty && _password == _conformPassword) {
            return kMatchPassError;
          }
          _conformPassword = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return kPassNullError;
          } else if ((_password != value)) {
            return kMatchPassError;
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
}
