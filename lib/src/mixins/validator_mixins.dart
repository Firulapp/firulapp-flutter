import '../../constants/constants.dart';

class ValidatorMixins {
  String validateEmail(String value) {
    if (!value.contains('@') |
        !Constants.emailValidatorRegExp.hasMatch(value)) {
      return Constants.kInvalidEmailError;
    } else if (value.isEmpty) {
      return Constants.kEmailNullError;
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty || value.trim().length == 0) {
      return Constants.kPassNullError;
    } else if (value.length < 8) {
      return Constants.kShortPassError;
    }
    return null;
  }

  String validateTextNotNull(String value) {
    if (value.isEmpty || value.trim().length == 0) {
      return Constants.kTextNotNull;
    }
    return null;
  }
}
