import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomFormBuilderTextField extends StatelessWidget {
  final String name;
  final String? label;
  final bool obscureText;
  final List<String? Function(String?)>? validators;
  final Widget? suffixIcon;
  final bool filled;
  final Color? fillColor;
  final bool enabled;

  const CustomFormBuilderTextField({
    Key? key,
    required this.name,
    this.label,
    this.obscureText = false,
    this.validators,
    this.suffixIcon,
    this.filled = false,
    this.fillColor,
    this.enabled = true
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      enabled: enabled,
      obscureText: obscureText,
      decoration: InputDecoration(filled: filled,fillColor: fillColor,labelText: label,border: OutlineInputBorder(), suffixIcon: suffixIcon,),
      validator: validators != null
          ? FormBuilderValidators.compose(validators!)
          : null,
    );
  }
}
