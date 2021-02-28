import 'package:flutter/material.dart';
import 'custom_surfix_icon.dart';

class InputText extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final CustomSurffixIcon suffixIcon;
  final void Function(String) validator;
  final void Function(String value) onChanged;
  final void Function(String value) onSaved;
  const InputText(
      {Key key,
      this.label = '',
      this.keyboardType = TextInputType.text,
      this.hintText = '',
      this.obscureText = false,
      @optionalTypeArgs this.suffixIcon,
      this.validator,
      this.onChanged,
      this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: this.keyboardType,
      obscureText: this.obscureText,
      decoration: InputDecoration(
        labelText: this.label,
        hintText: this.hintText,
        suffixIcon: this.suffixIcon,
      ),
      validator: this.validator,
      onChanged: this.onChanged,
      onSaved: this.onSaved,
    );
  }
}
