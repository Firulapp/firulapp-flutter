import '../../constants/constants.dart';

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
    if (value.isEmpty || value.trim().length == 0) {
      return kPassNullError;
    } else if (value.length < 8) {
      return kShortPassError;
    }
    return null;
  }
}
