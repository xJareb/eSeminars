import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/lecturers.dart';
import 'package:eseminars_desktop/providers/lecturers_provider.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
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
    return MasterScreen('Lecturer Details', Column(
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
            Expanded(child: CustomFormBuilderTextField(name: 'ime', label: "Name",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "This field is required."),
                FormBuilderValidators.minLength(3,errorText: "This field must contain at least three characters."),
              ])
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'prezime', label: "Surname",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "This field is required."),
                FormBuilderValidators.minLength(3,errorText: "This field must contain at least three characters."),
              ])
            ],)),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: 'biografija', label: "Biography",validators: [
              FormBuilderValidators.required(errorText: "This field is required."),
            ],)),
            const SizedBox(width: 40,),
            if(widget.lecturers == null) ... [
            Expanded(child: CustomFormBuilderTextField(name: 'email', label: "Email",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "This field is required."),
                FormBuilderValidators.email(errorText: "Please enter a valid email format."),
              ])
            ],))] else ... [
              Expanded(child: Text(""))
            ]
          ],
        ),
        const SizedBox(height: 20,),
        Row(children: [
          if(widget.lecturers == null) ... [
          Expanded(child: CustomFormBuilderTextField(name: 'telefon', label: "Phone number",validators: [
            FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: "This field is required."),
              FormBuilderValidators.match(phoneExp,errorText: "The phone number must contain 9 or 10 digits")
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
          }, child: Text("Cancel"),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white
          ),),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: () async{
            if(_formKey.currentState?.saveAndValidate() == true){
            if(widget.lecturers != null){
              try {
              await provider.update(widget.lecturers!.predavacId!,_formKey.currentState?.value);
              _formKey.currentState?.reset();
              showSuccessMessage(context, "Lecturer successfully edited");
              Navigator.pop(context,true);
              } catch (e) {
                showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
              }
              }else{
              try {
              await provider.insert(_formKey.currentState?.value);
              _formKey.currentState?.reset();
              showSuccessMessage(context, "Lecturer successfully added");
              Navigator.pop(context,true);
              } catch (e) {
                showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
              }
            }
            }
          }, child: Text("Confirm"),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white
          ),),
        ],
      ),
    );
  }
}