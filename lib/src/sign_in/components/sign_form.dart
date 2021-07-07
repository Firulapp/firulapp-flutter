import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../src/home/home.dart';
import '../../../components/dialogs.dart';
import '../../../provider/session.dart';
import '../../../components/default_button.dart';
import '../../../components/input_text.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../size_config.dart';
import '../../../constants/constants.dart';
import '../../mixins/validator_mixins.dart';
import '../../../provider/user.dart';

class SingForm extends StatefulWidget {
  SingForm({Key key}) : super(key: key);

  @override
  _SingFormState createState() => _SingFormState();
}

class _SingFormState extends State<SingForm>
    with AfterLayoutMixin, ValidatorMixins {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  // funcion para login con firebase chat
  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      String message = "Ocurrio un error inesperado";
      Dialogs.info(
        context,
        title: 'ERROR',
        content: message,
      );
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _check();
  }

  _check() async {
    setState(() {
      _isLoading = true;
      _isLogin = true;
    });
    try {
      final session = Provider.of<Session>(context, listen: false);
      await session.getSession();
      if (session.isAuth) {
        await Provider.of<User>(context, listen: false).getUser();
        final user = Provider.of<User>(context, listen: false);
        _userName = user.userData.userName;
        // Login para firebase chats
        _submitAuthForm(_userEmail.trim(), _userPassword.trim(),
            _userName.trim(), _isLogin, context);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } on PlatformException catch (err) {
      var message = 'Ocurrio un error, favor verifique sus credenciales!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      print(error);
      String message = "Ocurrio un error inesperado, vuelva a intentar";
      if (error.response.data['message'] != null) {
        message = error.response.data['message'];
      }
      Dialogs.info(
        context,
        title: 'ERROR',
        content: message,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  _submit() async {
    setState(() {
      _isLoading = true;
      _isLogin = true;
    });
    final isOK = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); // Cierra el teclado al ejecutar el check
    if (isOK) {
      _formKey.currentState.save();
      try {
        await Provider.of<Session>(context, listen: false).login(
          email: _userEmail,
          password: _userPassword,
        );
        await Provider.of<Session>(context, listen: false).logOut();
        await Provider.of<Session>(context, listen: false).login(
          email: _userEmail,
          password: _userPassword,
        );
        final session = Provider.of<Session>(context, listen: false);
        await session.getSession();
        if (session.isAuth) {
          await Provider.of<User>(context, listen: false).getUser();
          final user = Provider.of<User>(context, listen: false);
          _userName = user.userData.userName;
          // Login para firebase chats
          _submitAuthForm(_userEmail.trim(), _userPassword.trim(),
              _userName.trim(), _isLogin, context);
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      } on PlatformException catch (err) {
        var message = 'Ocurrio un error, favor verifique sus credenciales!';

        if (err.message != null) {
          message = err.message;
        }

        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      } catch (error) {
        print(error);
        String message = "Ocurrio un error inesperado, vuelva a intentar";
        if (error.response.data['message'] != null) {
          message = error.response.data['message'];
        }
        Dialogs.info(
          context,
          title: 'ERROR',
          content: message,
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
                emailFormField(),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
                passwordFormField(),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
                DefaultButton(
                  text: "Iniciar Sesión",
                  press: _submit,
                  color: Constants.kPrimaryColor,
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
      onSaved: (newValue) => _userEmail = newValue,
      onChanged: (value) {
        _userEmail = value;
      },
      validator: validateEmail,
    );
  }

  Widget passwordFormField() {
    return InputText(
      obscureText: true,
      label: 'Contraseña',
      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      onSaved: (newValue) => _userPassword = newValue,
      onChanged: (value) {
        _userPassword = value;
      },
      validator: validatePassword,
    );
  }
}
