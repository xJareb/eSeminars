import 'dart:math';

import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/categories.dart';
import 'package:eseminars_desktop/providers/categories_provider.dart';
import 'package:eseminars_desktop/utils/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class CategoriesDetailsScreen extends StatefulWidget {
  Categories? categories;
  CategoriesDetailsScreen({super.key,this.categories});

  @override
  State<CategoriesDetailsScreen> createState() => _CategoriesDetailsScreenState();
}

class _CategoriesDetailsScreenState extends State<CategoriesDetailsScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  late CategoriesProvider provider;
  Map<String, dynamic> _initialValue = {};

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = context.read<CategoriesProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<CategoriesProvider>();
    });
    _initialValue = {
      'naziv':widget.categories?.naziv,
      'opis':widget.categories?.naziv,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen('Category details', Column(
      children: [
        const SizedBox(height: 20,),
        _buildForm(),
        const SizedBox(height: 30,),
        _buildControls()
      ],
    ));
  }

  Widget _buildForm(){
    return FormBuilder(key: _formKey,initialValue: _initialValue,child: 
    Row(
      children: [
        Expanded(child: CustomFormBuilderTextField(name: 'naziv', label: "Title",validators: [
          FormBuilderValidators.required(errorText: "This field is required."),
        ],)),
        const SizedBox(width: 40,),
        Expanded(child: CustomFormBuilderTextField(name: 'opis', label: "Description",validators: [
          FormBuilderValidators.required(errorText: "This field is required.")
        ],))
      ],
    )
    );
  }
  Widget _buildControls(){
    return Center(child: 
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel"),style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white
        ),),
        const SizedBox(width: 10,),
        ElevatedButton(onPressed: (){
          if(_formKey.currentState?.saveAndValidate() == true){
         if(widget.categories == null){
            provider.insert(_formKey.currentState?.value);
            _formKey.currentState?.reset();
            Navigator.pop(context);
            
          }else{
          if(_formKey.currentState?.saveAndValidate() == true){
            provider.update(widget.categories!.kategorijaId!,_formKey.currentState?.value);
            Navigator.pop(context);
          }
         }
         }
        }, child: Text("Confirm"),style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white
        ),),
      ],
    ),);
  }
}