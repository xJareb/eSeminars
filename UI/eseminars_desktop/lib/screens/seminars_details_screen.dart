import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/categories.dart';
import 'package:eseminars_desktop/models/lecturers.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/seminars.dart';
import 'package:eseminars_desktop/providers/categories_provider.dart';
import 'package:eseminars_desktop/providers/lecturers_provider.dart';
import 'package:eseminars_desktop/providers/seminars_provider.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class SeminarsDetailsScreen extends StatefulWidget {
  Seminars? seminars;
   SeminarsDetailsScreen({super.key,this.seminars});

  @override
  State<SeminarsDetailsScreen> createState() => _SeminarsDetailsScreenState();
}

class _SeminarsDetailsScreenState extends State<SeminarsDetailsScreen> {

   final _formKey = GlobalKey<FormBuilderState>();
   late LecturersProvider lecturersProvider;
   late CategoriesProvider categoriesProvider;
   late SeminarsProvider seminarsProvider;
   SearchResult<Lecturers>? typeofLecturers;
   SearchResult<Categories>? typeOfCategories;
   bool isLoading = true;
   Map<String, dynamic> _initialValue = {};
   final now = DateTime.now();
   DateTime? parsedDate;

   @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void initState() {
    lecturersProvider = context.read<LecturersProvider>();
    categoriesProvider = context.read<CategoriesProvider>();
    seminarsProvider = context.read<SeminarsProvider>();
    final tomorrow = now.add(Duration(days: 1));
    
    if (widget.seminars?.datumVrijeme != null) {
      parsedDate = DateTime.tryParse(widget.seminars!.datumVrijeme!);
    if (parsedDate != null && parsedDate!.isBefore(tomorrow)) {
    parsedDate = tomorrow;
  }
}

    _initialValue = {
      'naslov' : widget.seminars?.naslov,
      'opis' : widget.seminars?.opis,
      'datumVrijeme' : widget.seminars?.datumVrijeme != null ? DateTime.tryParse(widget.seminars!.datumVrijeme!) : null,
      'lokacija' : widget.seminars?.lokacija,
      'kapacitet' : widget.seminars?.kapacitet.toString(),
      'predavacId' : widget.seminars?.predavac?.predavacId,
      'kategorijaId' : widget.seminars?.kategorija?.kategorijaId
    };
    // TODO: implement initState
    super.initState();


    initForm();
  }
  Future initForm() async{
    typeofLecturers = await lecturersProvider.get();
    typeOfCategories = await categoriesProvider.get();


    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen('Seminar details', Column(
      children: [
       isLoading ? Container(): 
        _buildForm(),
        const SizedBox(height: 20,),
        _buildControls()
      ],
    ));
  }

  Widget _buildForm(){
    return FormBuilder(initialValue: _initialValue,key:_formKey ,child: 
    Column(
      children: [
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: 'naslov', label: "Seminar",validators: [
              FormBuilderValidators.required(errorText: "This field is required.")
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'opis', label: "Description",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "This field is required"),
                FormBuilderValidators.minLength(3,errorText: "This field must contain at least three characters.")
              ])
            ],)),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: FormBuilderDateTimePicker(inputType: InputType.both,initialDate: now.add(Duration(days: 1)),firstDate:now.add(Duration(days: 1)) ,name: 'datumVrijeme',decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Date & time",suffixIcon: Icon(Icons.date_range)),validator: 
            FormBuilderValidators.required(errorText: "This field is required."),)),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'lokacija', label: "Location",validators: [
              FormBuilderValidators.required(errorText: "This field is required.")
            ],)),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: 'kapacitet', label: "Capacity",validators: [
              FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "This field is required."),
                FormBuilderValidators.min(0, errorText: "Capacity cannot be less than 0."),
                FormBuilderValidators.max(100,errorText: "Capacity cannot exceed 100.")
              ])
            ],)),
            const SizedBox(width: 40,),
            Expanded(child: FormBuilderDropdown(decoration: InputDecoration(labelText: "Lecturer",border: OutlineInputBorder()),name: 'predavacId', items: typeofLecturers?.result.map((item) => DropdownMenuItem(value: item.predavacId,child: Text('${item.ime} ${item.prezime}'))).toList() ?? [],validator: 
            FormBuilderValidators.required(errorText: "This field is required."),)),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: FormBuilderDropdown(decoration: InputDecoration(labelText: "Category",border: OutlineInputBorder()),name: 'kategorijaId',items: typeOfCategories?.result.map((item) => DropdownMenuItem(value: item.kategorijaId,child: Text(item.naziv ?? ""))).toList() ?? [] ,validator:
              FormBuilderValidators.required(errorText: "This field is required.")
            ,)),
            const SizedBox(width: 40,),
            Expanded(child: Container())
          ],
        )
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
            foregroundColor: Colors.white,
          ),),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: () async{
            if(_formKey.currentState?.saveAndValidate() == true){
               final formValues = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
               if (formValues != null) {
             formValues['datumVrijeme'] = formValues['datumVrijeme']?.toIso8601String();
             }
              if(widget.seminars == null){
                try {
                  await seminarsProvider.insert(formValues);
                  _formKey.currentState?.reset();
                  showSuccessMessage(context, "Seminar successfully added");
                  Navigator.pop(context,true);

                } catch (e) {
                  showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
                }
              }else{
                try {
                  var seminarId = widget.seminars?.seminarId;
                  await seminarsProvider.update(seminarId ?? 0,formValues);
                  _formKey.currentState?.reset();
                  showSuccessMessage(context, "Seminar successfully updated");
                  Navigator.pop(context,true);
                } catch (e) {
                  showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
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