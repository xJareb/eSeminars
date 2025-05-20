import 'package:eseminars_mobile/providers/korisnici_provider.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:eseminars_mobile/utils/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final RegExp capitalLetter = RegExp(r'^[A-Z].*');
  late KorisniciProvider userProvider;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void initState() {
    userProvider = context.read<KorisniciProvider>();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration")),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomFormBuilderTextField(
                  name: 'ime',
                  label: 'Name',
                  suffixIcon: Icon(Icons.person),
                  validators: [
                    FormBuilderValidators.required(errorText: "This field is required"),
                    FormBuilderValidators.minLength(3, errorText: "This field must contain at least three characters."),
                    FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter.")
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomFormBuilderTextField(
                  name: 'prezime',
                  label: 'Surname',
                  suffixIcon: Icon(Icons.person_2),
                  validators: [
                    FormBuilderValidators.required(errorText: "This field is required"),
                    FormBuilderValidators.minLength(3, errorText: "This field must contain at least three characters."),
                    FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter.")
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomFormBuilderTextField(
                  name: 'email',
                  label: "Email",
                  suffixIcon: Icon(Icons.email),
                  validators: [
                    FormBuilderValidators.required(errorText: "This field is required"),
                    FormBuilderValidators.email(errorText: "Please enter a valid email format."),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilderDateTimePicker(
                  lastDate: DateTime.now(),
                  name: 'datumRodjenja',
                  decoration: InputDecoration(
                    labelText: "Date of birth",
                    suffixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                  ),validator: 
                  FormBuilderValidators.required(errorText: "This field is required."),
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomFormBuilderTextField(
                  obscureText: true,
                  name: 'lozinka',
                  label: "Password",
                  suffixIcon: Icon(Icons.password),
                  validators: [
                    FormBuilderValidators.required(errorText: "This field is required."),
                    FormBuilderValidators.minLength(7, errorText: "This field must contain at least 7 characters."),
                    FormBuilderValidators.hasNumericChars(atLeast: 1, errorText: "This field must contain numeric characters."),
                    FormBuilderValidators.hasUppercaseChars(atLeast: 1, errorText: "This field must contain an uppercase letter."),
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomFormBuilderTextField(
                  obscureText: true,
                  name: 'lozinkaPotvrda',
                  label: "Confirm Password",
                  suffixIcon: Icon(Icons.password),
                  validators: [
                    (val) {
                      final password = _formKey.currentState?.fields['lozinka']?.value;
                      if (val == null || val.isEmpty) {
                        return "This field is required.";
                      } else if (val != password) {
                        return "Passwords do not match.";
                      }
                      return null;
                    }
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ElevatedButton(onPressed: (){
                  _formKey.currentState?.reset();
                }, child: Text("Clear")),
                const SizedBox(width: 15,),
                ElevatedButton(onPressed: () async{
                  if(_formKey.currentState?.saveAndValidate() == true){
                    final formValues = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
                    try {
                      if(formValues != null){
                      formValues['datumRodjenja'] = formValues['datumRodjenja']?.toIso8601String();
                    }
                    await userProvider.insert(formValues);
                    MyDialogs.showSuccessDialog(context, "Successfully registered");
                    } catch (e) {
                      MyDialogs.showErrorDialog(context, e.toString().replaceFirst('Exception: ', ''));
                    }
                    
                  }
                }, child: Text("Confirm"),style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white
                ),)
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
