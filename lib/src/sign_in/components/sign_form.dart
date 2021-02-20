import '../../home/home.dart';
import '../../../components/default_button.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../size_config.dart';
import '../../mixins/validator_mixins.dart';
import 'package:flutter/material.dart';

class SingFrom extends StatefulWidget {
  SingFrom({Key key}) : super(key: key);

  @override
  _SingFromState createState() => _SingFromState();
}

class _SingFromState extends State<SingFrom> with ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          emailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          passwordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          //FormError(errors: errors),
          //SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Iniciar Sesión",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                Navigator.pushNamed(context, HomeScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField emailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo',
        hintText: 'ejemplo@gmail.com',
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
      validator: validateEmail,
      onChanged: (value) {
        //print(value);
      },
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Contraseña',
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
      validator: validatePassword,
      onChanged: (value) {
        //print(value);
      },
    );
  }

  TextFormField conformPassFormField() {
    return TextFormField();
  }
}
