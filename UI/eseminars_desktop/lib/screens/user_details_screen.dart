import 'dart:convert';

import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/providers/korisnici_provider.dart';
import 'package:eseminars_desktop/screens/user_list_screen.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  Korisnik? user;
  UserDetailsScreen({super.key,this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {


  Map<String, dynamic> _initialValue = {};
  late KorisniciProvider userProdiver;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }
  @override
  void initState() {
    userProdiver = context.read<KorisniciProvider>();
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      userProdiver = context.read<KorisniciProvider>();
    });
    _initialValue = {
      'ime': widget.user?.ime,
      'prezime': widget.user?.prezime,
      'email': widget.user?.email,
      'datumRodjenja' : widget.user?.datumRodjenja != null ? DateTime.tryParse(widget.user!.datumRodjenja!) : null
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen('User Details', Column(
      children: [
        _buildForm(),
        const SizedBox(height: 30,),
        _buildControls()
      ],
    ));
  }
  Widget _buildForm(){
    return FormBuilder(key: _formKey,initialValue: _initialValue,child: 
    Column(
      children: [
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: "ime", label: "Name", validators: [
              FormBuilderValidators.required(errorText: "This field is required."),
              FormBuilderValidators.minLength(3,errorText: "This field must contain at least three characters."),
            ],
            )),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: "prezime", label: "Surname", validators: [
              FormBuilderValidators.required(errorText: "This field is required."),
              FormBuilderValidators.minLength(3,errorText: "This field must contain at least three characters."),
            ],))
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: "email", label: "Email",validators: [
              FormBuilderValidators.required(errorText: "This field is required."),
              FormBuilderValidators.email(errorText: "Please enter a valid email format.")
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: FormBuilderDateTimePicker(name: "datumRodjenja",decoration: InputDecoration(labelText: "Date of Birth", suffixIcon: Icon(Icons.date_range),
            border: OutlineInputBorder()),inputType: InputType.date,lastDate: DateTime.now(),validator: FormBuilderValidators.required(errorText: "This field is required."),))
          ],
        ),
        const SizedBox(height: 20,),
        Row(
  children: [
    if (widget.user == null) ...[
      Expanded(
        child: CustomFormBuilderTextField(
          name: "lozinka",
          label: "Password",
          obscureText: true,
          validators: [
            FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: "This field is required."),
              FormBuilderValidators.minLength(7, errorText: "This field must contain at least 7 characters."),
              FormBuilderValidators.hasNumericChars(atLeast: 1, errorText: "This field must contain numeric characters."),
              FormBuilderValidators.hasUppercaseChars(atLeast: 1, errorText: "This field must contain an uppercase letter.")
            ]),
          ],
        ),
      ),
      const SizedBox(width: 40),
      Expanded(
        child: CustomFormBuilderTextField(
          name: "lozinkaPotvrda",
          obscureText: true,
          label: "Confirm Password",
          validators: [
            (val) {
              final lozinka = _formKey.currentState?.fields['lozinka']?.value;
              if (val == null || val.isEmpty) {
                return "This field is required.";
              } else if (val != lozinka) {
                return "Passwords do not match.";
              }
              return null;
            }
          ],
        ),
      ),
    ] else ...[
      Container(),
    ]
  ],
)
      ],
    )
    );
  }

  Widget _buildControls(){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () async{
            Navigator.pop(context);
          }, child: Text("Cancel"),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white
          )),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: () async{
              if (_formKey.currentState?.saveAndValidate() ?? false) {
              final formValues = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});

             if (formValues != null) {
             formValues['datumRodjenja'] = formValues['datumRodjenja']?.toIso8601String();
             }
             if(widget.user == null){
              try {
                await userProdiver.insert(formValues);
                showSuccessMessage(context,"User successfully added");
                _formKey.currentState?.reset();
              Navigator.pop(context,true);
              } catch (e) {
                showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
              }
            }else{
              try {
              var korisnikId = widget.user!.korisnikId;
              await userProdiver.update(korisnikId!,formValues);
              showSuccessMessage(context,"User successfully edited");
               _formKey.currentState?.reset();
              Navigator.pop(context,true);
              } catch (e) {
                showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
              }
            }
          }
          }, child: Text("Confirm"),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white
          ))
        ],
      ),
    );
  }
  //TODO :: add checkbox to change password
}