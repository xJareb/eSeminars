import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomFormBuilderTextField extends StatelessWidget {
  final String name;
  final String label;
  final bool obscureText;
  final List<String? Function(String?)>? validators;

  const CustomFormBuilderTextField({
    Key? key,
    required this.name,
    required this.label,
    this.obscureText = false,
    this.validators,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label,border: OutlineInputBorder()),
      validator: validators != null
          ? FormBuilderValidators.compose(validators!)
          : null,
    );
  }
}
