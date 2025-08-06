import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/materials.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/seminars.dart';
import 'package:eseminars_desktop/providers/materials_provider.dart';
import 'package:eseminars_desktop/providers/seminars_provider.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class MaterialsDetailsScreen extends StatefulWidget {
  Materials? materials;
  MaterialsDetailsScreen({super.key,this.materials});

  @override
  State<MaterialsDetailsScreen> createState() => _MaterialsDetailsScreenState();
}

class _MaterialsDetailsScreenState extends State<MaterialsDetailsScreen> {

  SearchResult<Seminars>? seminarsResult;
  late SeminarsProvider seminarsProvider;
  late MaterialsProvider materialsProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = true;
  final RegExp capitalLetter = RegExp(r'^[A-Z].*');
  final RegExp noNumber = RegExp(r'^[^0-9]*$');
  Map<String, dynamic> _initialValue = {};

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    seminarsProvider = context.read<SeminarsProvider>();
    materialsProvider = context.read<MaterialsProvider>();
    _loadSeminars();
  }
  @override
  void initState() {
    super.initState();
    _initialValue = {
      'seminarId': widget.materials?.seminarId,
      'naziv' : widget.materials?.naziv,
      'putanja':widget.materials?.putanja
    };
  }

  Future<void> _loadSeminars()async{
    var filter = {
      'isActive' : true
    };
    seminarsResult = await seminarsProvider.get(filter: filter);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen('Material details',Column(
      children: [
        isLoading ? Center(child: CircularProgressIndicator(),) : 
        _buildForm(),
        const SizedBox(height: 20,),
        _buildControls()
      ],
    ),showBackButton: true,);
  }

  Widget _buildForm(){
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
      children: [
        Row(children: [
          Expanded(child: CustomFormBuilderTextField(name: 'naziv', label: "Title",validators: [
            FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: "This field is required"),
              FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
              FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
            ])
          ],)),
          const SizedBox(width: 40,),
          Expanded(child: CustomFormBuilderTextField(name: 'putanja', label: "Link",validators: [
            FormBuilderValidators.required(errorText: "This field is required")
          ],)),
        ],),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(
            child: FormBuilderDropdown(decoration: InputDecoration(
              labelText: "Seminar",
              border: OutlineInputBorder()
            ),validator: FormBuilderValidators.required(errorText: "This field is required"),
            name: 'seminarId', 
            items: seminarsResult?.result.map((item) => DropdownMenuItem(
              value: item.seminarId,child: Text("${item.naslov ?? ""}"))).toList() ?? []),

            ),
          ],
        )
      ],
    ));
  }
  Widget _buildControls(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      ElevatedButton(onPressed: () async{
        Navigator.pop(context);
      }, child: Text("Cancel"),style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white
      ),),
      const SizedBox(width: 10,),
      ElevatedButton(onPressed: ()async{
        if(_formKey.currentState?.saveAndValidate() == true){
          try {
            if(widget.materials == null){
              await materialsProvider.insert(_formKey.currentState?.value);
              _formKey.currentState?.reset();
              showSuccessMessage(context, "Material successfully added");
              Navigator.pop(context,true);
            }else{
              await materialsProvider.update(widget.materials!.materijalId!,_formKey.currentState?.value);
              _formKey.currentState?.reset();
              showSuccessMessage(context, "Material successfully edited");
              Navigator.pop(context,true);
            }
          } catch (e) {
            showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
          }
        }
      }, child: Text("Confirm"),style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white
      ),)
    ],);
  }
}