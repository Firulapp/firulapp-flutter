import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/home.dart';
import '../../../provider/session.dart';
import '../../../provider/user_data.dart';
import '../../../components/dialogs.dart';
import '../../../components/default_button.dart';

class SignUpDetailsForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const routeName = "/sign_up/step2";

  @override
  Widget build(BuildContext context) {
    final ProgressDialog progressDialog = ProgressDialog(context);
    final _userCredentials =
        ModalRoute.of(context).settings.arguments as UserCredentials;
    final _user = Provider.of<User>(context, listen: false);
    return Form(
      key: _formKey,
      child: SizedBox(
        child: DefaultButton(
          text: "Register",
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
      ),
    );
  }
}
