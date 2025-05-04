import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/lecturers.dart';
import 'package:eseminars_desktop/providers/lecturers_provider.dart';
import 'package:eseminars_desktop/utils/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class LecturersDetailsScreen extends StatefulWidget {
  Lecturers? lecturers;
  LecturersDetailsScreen({super.key,this.lecturers});

  @override
  State<LecturersDetailsScreen> createState() => _LecturersDetailsScreenState();
}

class _LecturersDetailsScreenState extends State<LecturersDetailsScreen> {

  Map<String, dynamic> _initialValue = {};
  final _formKey = GlobalKey<FormBuilderState>();
  RegExp phoneExp = RegExp( r'^\d{9,10}$');
  late LecturersProvider provider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void initState() {
    provider = context.read<LecturersProvider>();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<LecturersProvider>();
    });
    _initialValue = {
      'ime': widget.lecturers?.ime,
      'prezime': widget.lecturers?.prezime,
      'biografija': widget.lecturers?.biografija,
    };
  }
  @override
  Widget build(BuildContext context) {
    return MasterScreen('Lecturers Details', Column(
      children: [
          _buildForm(),
          const SizedBox(height: 30,),
          _buildControls()
    ],));
  }


  Widget _buildForm(){
    return FormBuilder(key: _formKey,initialValue: _initialValue,child: 
    Column(
      children: [
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: 'ime', label: "Ime",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
                FormBuilderValidators.minLength(3,errorText: "Ovo polje mora sadržati minimalno tri karaktera"),
              ])
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'prezime', label: "Prezime",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
                FormBuilderValidators.minLength(3,errorText: "Ovo polje mora sadržati minimalno tri karaktera"),
              ])
            ],)),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: 'biografija', label: "Biografija",validators: [
              FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
            ],)),
            const SizedBox(width: 40,),
            if(widget.lecturers == null) ... [
            Expanded(child: CustomFormBuilderTextField(name: 'email', label: "Email",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
                FormBuilderValidators.email(errorText: "Unesite validan email"),
              ])
            ],))] else ... [
              Expanded(child: Text(""))
            ]
          ],
        ),
        const SizedBox(height: 20,),
        Row(children: [
          if(widget.lecturers == null) ... [
          Expanded(child: CustomFormBuilderTextField(name: 'telefon', label: "Telefon",validators: [
            FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
              FormBuilderValidators.match(phoneExp,errorText: "Broj telefona treba da sadži 9 ili 10 cifara")
            ])
          ],))] else ... [
            Container()
          ],
          const SizedBox(width: 40,),
          Expanded(child: Text(""))
        ],)
      ],
    ));
  }

  Widget _buildControls(){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Poništi")),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: (){
            if(widget.lecturers != null){
              if(_formKey.currentState?.saveAndValidate() == true){
                provider.update(widget.lecturers!.predavacId!,_formKey.currentState?.value);
                Navigator.pop(context);
              }else{
                print("Forma nije ispravna");
              }
            }else{
            if(_formKey.currentState?.saveAndValidate() == true){
              provider.insert(_formKey.currentState?.value);
              Navigator.pop(context);
            }else{
              print("Forma nije ispravna");
            }
            }
            
          }, child: Text("Dodaj")),
        ],
      ),
    );
  }
}