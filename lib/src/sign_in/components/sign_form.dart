import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../src/home/home.dart';
import '../../../components/dialogs.dart';
import '../../../provider/session.dart';
import '../../../components/default_button.dart';
import '../../../components/input_text.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../size_config.dart';
import '../../mixins/validator_mixins.dart';

class SingFrom extends StatefulWidget {
  SingFrom({Key key}) : super(key: key);

  @override
  _SingFromState createState() => _SingFromState();
}

class _SingFromState extends State<SingFrom> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  _submit() {
    final isOK = _formKey.currentState.validate();
    _formKey.currentState.save();
    if (isOK) {
      try {
        Provider.of<Session>(context, listen: false).login(
          email: _email,
          password: _password,
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (_) => false,
        );
      } catch (error) {
        print(error);
        Dialogs.info(
          context,
          title: 'ERROR',
          content: "Error al loguearse",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(30)),
          emailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          passwordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Iniciar Sesión",
            press: _submit,
          ),
        ],
      ),
    );
  }

  Widget emailFormField() {
    return InputText(
      keyboardType: TextInputType.emailAddress,
      label: 'Correo',
      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      onSaved: (newValue) => _email = newValue,
      onChanged: (value) {
        _email = value;
      },
      validator: validateEmail,
    );
  }

  Widget passwordFormField() {
    return InputText(
      obscureText: true,
      label: 'Contraseña',
      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      onSaved: (newValue) => _password = newValue,
      onChanged: (value) {
        _password = value;
      },
      validator: validatePassword,
    );
  }
}
