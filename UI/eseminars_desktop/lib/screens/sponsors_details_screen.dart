import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/sponsors.dart';
import 'package:eseminars_desktop/providers/sponsors_provider.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
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
  final RegExp capitalLetter = RegExp(r'^[A-Z].*');
  final RegExp noNumber = RegExp(r'^[^0-9]*$');
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
    ),showBackButton: true,);
  }

  Widget _buildForm(){
    return FormBuilder(key:_formKey,initialValue: _initialValue,child: 
    Column(
      children: [
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: 'naziv', label: "Company",validators: [
              FormBuilderValidators.required(errorText: "This field is required."),
              FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
              FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'email', label: "Email",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "This field is required."),
                FormBuilderValidators.email(errorText: "Please enter a valid email format.")
              ])
            ])),
          ],
        ),
        const SizedBox(height: 20,),
        Row(children: [
            Expanded(child: CustomFormBuilderTextField(name: 'telefon', label: "Phone number",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "This field is required."),
                FormBuilderValidators.match(phoneExp,errorText: "Please enter the correct phone format.")
              ])
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'kontaktOsoba', label: "Representative person",validators: [
              FormBuilderValidators.required(errorText: "This field is required."),
              FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
              FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
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
          }, child: Text("Cancel"),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white
          ),),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: ()async{
            if(_formKey.currentState?.saveAndValidate() == true){
              if(widget.sponsors == null){
                try {
                await provider.insert(_formKey.currentState?.value);
                _formKey.currentState?.reset();
                showSuccessMessage(context, "Sponsor successfully added");
                Navigator.pop(context,true);
                } catch (e) {
                  showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
                }
              }else{
                try {
                await provider.update(widget.sponsors!.sponzorId!,_formKey.currentState?.value);
                _formKey.currentState?.reset();
                showSuccessMessage(context, "Sponsor successfully edited");
                Navigator.pop(context,true);
                } catch (e) {
                  showErrorMessage(context, e.toString().replaceFirst("Exception:", ''));
                }
              }
            }
          }, child: Text("Confirm"),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white
          ),)
        ],
      ),
    );
  }
}