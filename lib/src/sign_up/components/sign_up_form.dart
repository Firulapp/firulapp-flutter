import 'package:flutter/material.dart';

import '../../../provider/user.dart';
import '../../sign_up/components/sign_up_details_form.dart';
import '../../../constants/constants.dart';
import '../../mixins/validator_mixins.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/input_text.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            color: Constants.kPrimaryColor,
            press: () {
              final isOK = _formKey.currentState.validate();
              if (isOK) {
                final user = UserCredentials(
                    mail: _email,
                    confirmPassword: _confirmPassword,
                    encryptedPassword: _password);
                Navigator.of(context).pushNamed(
                  SignUpDetailsForm.routeName,
                  arguments: user,
                );
              }
            },
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
}
