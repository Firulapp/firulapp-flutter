import 'package:firulapp/services/my_service.dart';
import '../../../components/default_button.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../size_config.dart';
import '../../mixins/validator_mixins.dart';
import 'package:flutter/material.dart';
import 'package:firulapp/components/input_text.dart';

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
      MyServices myServices = MyServices();
      myServices.login(
        context,
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
          SizedBox(height: getProportionateScreenHeight(30)),
          emailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          passwordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          //FormError(errors: errors),
          //SizedBox(height: getProportionateScreenHeight(40)),
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
