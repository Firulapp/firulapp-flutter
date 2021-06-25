import 'package:flutter/material.dart';

import '../src/sign_up/user/sign_up_screen.dart';
import '../src/sign_up/organization/organization_sign_up_screen.dart';
import '../constants/constants.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "¿No tienes una cuenta? ",
          style:
              TextStyle(fontSize: SizeConfig.getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Registrar Usuario",
            style: TextStyle(
                fontSize: SizeConfig.getProportionateScreenWidth(16),
                color: Constants.kPrimaryColor),
          ),
        ),
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, OrganizationSignUpScreen.routeName),
          child: Text(
            "Registrar Organización",
            style: TextStyle(
                fontSize: SizeConfig.getProportionateScreenWidth(16),
                color: Constants.kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
