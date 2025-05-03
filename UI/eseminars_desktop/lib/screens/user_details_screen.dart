import 'dart:convert';

import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/providers/korisnici_provider.dart';
import 'package:eseminars_desktop/screens/user_list_screen.dart';
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
    return MasterScreen('Detalji korisnika', Column(
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
            Expanded(child: CustomFormBuilderTextField(name: "ime", label: "Ime", validators: [
              FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
              FormBuilderValidators.minLength(3,errorText: "Ovo polje mora sadržati minimalno tri karaktera"),
            ],
            )),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: "prezime", label: "Prezime", validators: [
              FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
              FormBuilderValidators.minLength(3,errorText: "Ovo polje mora sadržati minimalno tri karaktera"),
            ],))
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: "email", label: "Email",validators: [
              FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
              FormBuilderValidators.email(errorText: "Unesite validan email")
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: FormBuilderDateTimePicker(name: "datumRodjenja",decoration: InputDecoration(labelText: "Datum rođenja", 
            border: OutlineInputBorder()),inputType: InputType.date,lastDate: DateTime.now(),validator: FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),))
          ],
        ),
        const SizedBox(height: 20,),
        Row(
  children: [
    if (widget.user == null) ...[
      Expanded(
        child: CustomFormBuilderTextField(
          name: "lozinka",
          label: "Lozinka",
          obscureText: true,
          validators: [
            FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
              FormBuilderValidators.minLength(7, errorText: "Ovo polje mora sadržati minimalno 7 karaktera"),
              FormBuilderValidators.hasNumericChars(atLeast: 1, errorText: "Ovo polje mora sadržati numeričke karaktere"),
              FormBuilderValidators.hasUppercaseChars(atLeast: 1, errorText: "Ovo polje mora sadržati veliko slovo")
            ]),
          ],
        ),
      ),
      const SizedBox(width: 40),
      Expanded(
        child: CustomFormBuilderTextField(
          name: "lozinkaPotvrda",
          obscureText: true,
          label: "Potvrdi lozinku",
          validators: [
            (val) {
              final lozinka = _formKey.currentState?.fields['lozinka']?.value;
              if (val == null || val.isEmpty) {
                return "Ovo polje je obavezno";
              } else if (val != lozinka) {
                return "Lozinke se ne poklapaju";
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
          }, child: Text("Poništi")),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: (){
             if (_formKey.currentState?.saveAndValidate() ?? false) {
                final formValues = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});

             if (formValues != null) {
             formValues['datumRodjenja'] = formValues['datumRodjenja']?.toIso8601String();
             }
            if(widget.user == null){
              userProdiver.insert(formValues);
              Navigator.pop(context);
            }else{
              var korisnikId = widget.user!.korisnikId;
              userProdiver.update(korisnikId!,formValues);
            }
          } else {
            print('Forma nije validna');
          }
          }, child: Text("Potvrdi"))
        ],
      ),
    );
  }
  //TODO :: add checkbox to change password
}