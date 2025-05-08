import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/sponsors.dart';
import 'package:eseminars_desktop/providers/sponsors_provider.dart';
import 'package:eseminars_desktop/utils/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class SponsorsDetailsScreen extends StatefulWidget {
  Sponsors? sponsors;
  SponsorsDetailsScreen({super.key,this.sponsors});

  @override
  State<SponsorsDetailsScreen> createState() => _SponsorsDetailsScreenState();
}

class _SponsorsDetailsScreenState extends State<SponsorsDetailsScreen> {

  Map<String, dynamic> _initialValue = {};
  RegExp phoneExp = RegExp( r'^\d{9,10}$');
  final _formKey = GlobalKey<FormBuilderState>();
  late SponsorsProvider provider;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = context.read<SponsorsProvider>();
    _initialValue = {
      'naziv' : widget.sponsors?.naziv,
      'email' : widget.sponsors?.email,
      'telefon' : widget.sponsors?.telefon,
      'kontaktOsoba' : widget.sponsors?.kontaktOsoba
    };
    if(widget.sponsors != null){
      print("Test");
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return MasterScreen('Sponsor details', Column(
      children: [
        _buildForm(),
        const SizedBox(height: 20,),
        _buildControls()
      ],
    ));
  }

  Widget _buildForm(){
    return FormBuilder(key:_formKey,initialValue: _initialValue,child: 
    Column(
      children: [
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: 'naziv', label: "Kompanija",validators: [
              FormBuilderValidators.required(errorText: "Ovo polje je obavezno")
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'email', label: "Email",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
                FormBuilderValidators.email(errorText: "Unesite validan format emaila")
              ])
            ])),
          ],
        ),
        const SizedBox(height: 20,),
        Row(children: [
            Expanded(child: CustomFormBuilderTextField(name: 'telefon', label: "Telefon",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Ovo polje je obavezno"),
                FormBuilderValidators.match(phoneExp,errorText: "Unesite ispravan format telefona")
              ])
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'kontaktOsoba', label: "Kontakt osoba",validators: [
              FormBuilderValidators.required(errorText: "Ovo polje je obavezno")
            ],)),
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
          ElevatedButton(onPressed: ()async{
            if(_formKey.currentState?.saveAndValidate() == true){
              if(widget.sponsors == null){
                await provider.insert(_formKey.currentState?.value);
                Navigator.pop(context);
              }else{
                await provider.update(widget.sponsors!.sponzorId!,_formKey.currentState?.value);
                Navigator.pop(context);
              }
            }
          }, child: Text("Dodaj"))
        ],
      ),
    );
  }
}