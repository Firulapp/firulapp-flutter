import 'package:flutter/material.dart';

import 'components/body.dart';

class OrganizationSignUpScreen extends StatelessWidget {
  static const routeName = "/organization_sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Organization"),
      ),
      body: Body(),
    );
  }
}
