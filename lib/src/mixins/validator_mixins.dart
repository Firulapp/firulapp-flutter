import '../constants.dart';

class ValidatorMixins {
  String validateEmail(String value) {
    if (!value.contains('@') | !emailValidatorRegExp.hasMatch(value)) {
      return kInvalidEmailError;
    } else if (value.isEmpty) {
      return kEmailNullError;
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return kPassNullError;
    } else if (value.length < 8) {
      print(value.length);
      return kShortPassError;
    }
    return null;
  }
}
