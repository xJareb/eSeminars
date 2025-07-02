import 'package:eseminars_mobile/models/categories.dart';
import 'package:eseminars_mobile/models/lecturers.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/categories_provider.dart';
import 'package:eseminars_mobile/providers/lecturers_provider.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:eseminars_mobile/utils/custom_form_builder_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SeminarsEditScreen extends StatefulWidget {
  Seminars? seminar;
  SeminarsEditScreen({super.key,this.seminar});

  @override
  State<SeminarsEditScreen> createState() => _SeminarsEditScreenState();
}

class _SeminarsEditScreenState extends State<SeminarsEditScreen> {

  SearchResult<Lecturers>? lecturersResult;
  SearchResult<Categories>? categoriesResult;

  late LecturersProvider lecturersProvider;
  late CategoriesProvider categoriesProvider;
  late SeminarsProvider seminarsProvider;

  bool isLoadingLecturers = true;
  bool isLoadingCategories = true;

  final _formKey = GlobalKey<FormBuilderState>();
  Map<String,dynamic> _initialValue = {};
  bool isEnabled = true;
  final RegExp capitalLetter = RegExp(r'^[A-Z].*');
  final RegExp noNumber = RegExp(r'^[^0-9]*$');
  final RegExp numbers = RegExp(r'^[0-9]+$');

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    lecturersProvider = context.read<LecturersProvider>();
    categoriesProvider = context.read<CategoriesProvider>();
    seminarsProvider = context.read<SeminarsProvider>();

    _loadCategories();
    _loadLecturers();
  }

  Future<void> _loadLecturers() async{
    lecturersResult = await lecturersProvider.get();

    setState(() {
      isLoadingLecturers = false;
    });
  }
  Future<void> _loadCategories() async{
    categoriesResult = await categoriesProvider.get();

    setState(() {
      isLoadingCategories = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'naslov' : widget.seminar?.naslov,
      'opis' : widget.seminar?.opis,
      'datumVrijeme' : widget.seminar?.datumVrijeme != null ? DateTime.tryParse(widget.seminar!.datumVrijeme!) : null,
      'lokacija' : widget.seminar?.lokacija,
      'kapacitet' : widget.seminar?.kapacitet.toString(),
      'predavacId' : widget.seminar?.predavac?.predavacId,
      'kategorijaId': widget.seminar?.kategorija?.kategorijaId
    };
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text(widget.seminar?.naslov ?? ""),
    ),body: SingleChildScrollView(
      child: Column(children: [
        _buildForm(),
        _buildControls()
      ],),
    ),);
  }

  Widget _buildForm(){
    return SingleChildScrollView(
      child: FormBuilder(key: _formKey,initialValue: _initialValue,child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildInputField("Title", "naslov", isEnabled,extraValidators: [
              FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
              FormBuilderValidators.minLength(3, errorText: "This field must contain at least three characters."),
              FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
            ]),
            const SizedBox(height: 15,),
            _buildInputField("Description", "opis", isEnabled,extraValidators: [
              FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
            ]),
            const SizedBox(height: 15,),
            _buildInputDateTime("Date", "datumVrijeme", isEnabled),
            const SizedBox(height: 15,),
            _buildInputField("Location", "lokacija", isEnabled,extraValidators: [
              FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
              FormBuilderValidators.minLength(3, errorText: "This field must contain at least three characters."),
            ]),
            const SizedBox(height: 15,),
            _buildInputField("Capacity", "kapacitet", isEnabled,extraValidators: [
              FormBuilderValidators.match(numbers, errorText: "This field must contains only numbers"),
            ]),
            const SizedBox(height: 15,),
            _buildFormDropDownMenu<Lecturers>("Lecturers", "predavacId", lecturersResult?.result, (l)=>"${l.ime} ${l.prezime}" ?? "", (l)=>l.predavacId),
            const SizedBox(height: 15,),
            _buildFormDropDownMenu<Categories>("Categories", "kategorijaId", categoriesResult?.result, (c)=>c.naziv ?? "", (c)=>c.kategorijaId)

          ],
        ),
      )),
    );
  }
  Widget _buildControls() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
          _formKey.currentState?.reset();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[400],
          foregroundColor: Colors.black,
        ),
        child: const Text("Cancel"),
      ),
      const SizedBox(width: 10),
      ElevatedButton(
        onPressed: () async {
          if(_formKey.currentState?.saveAndValidate() == true){
            final formValues = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
            if (formValues != null) {
              formValues['datumVrijeme'] = formValues['datumVrijeme']?.toIso8601String();
              }
            try {
              await seminarsProvider.update(widget.seminar!.seminarId!,formValues);
              await MyDialogs.showSuccessDialog(context, "Successfully edited seminar");
              Navigator.pop(context,true);
            } catch (e) {
              await MyDialogs.showErrorDialog(context, "Something bad happened with editing this seminar");
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text("Confirm"),
      ),
    ],
  );
}


  Widget _buildInputField(String label, String name, bool isEnabled, {bool? obscureText,List<FormFieldValidator<String>>? extraValidators}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: GoogleFonts.poppins(
          color: Colors.grey[800],
          fontSize: 16,
          fontWeight: FontWeight.w500),),
        const SizedBox(height: 5,),
        CustomFormBuilderTextField(name: name, 
        obscureText: obscureText ?? false,
        filled: true,
        fillColor: Colors.grey[100],
        enabled: isEnabled,validators: [
          FormBuilderValidators.required(errorText: "This field is required"),
          ...?extraValidators
        ],)
      ],
    );
  }
  Widget _buildInputDateTime(String label, String name, bool isEnabled){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: GoogleFonts.poppins(
          color: Colors.grey[800],
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),),
        const SizedBox(height: 5,),
        FormBuilderDateTimePicker(name: name,
        enabled: isEnabled,
        inputType: InputType.date,
        lastDate: DateTime.now(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: Icon(CupertinoIcons.calendar),
          border: OutlineInputBorder(
          )
        ),)
      ],
    );
  }
  Widget _buildFormDropDownMenu<T>(
  String? hintText,
  String name,
  List<T>? items,
  String Function(T) labelBuilder,
  dynamic Function(T) valueBuilder, {
  IconData? icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(hintText ?? "",style: GoogleFonts.poppins(
          color: Colors.grey[800],
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),),
      FormBuilderDropdown(
        name: name,
        decoration: InputDecoration(
          labelText: "",
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: icon != null ? Icon(icon, color: Colors.grey[700]) : null,
        ),
        items: items?.map((item) {
              return DropdownMenuItem(
                value: valueBuilder(item),
                child: Text(labelBuilder(item)),
              );
            }).toList() ??
            [],validator: FormBuilderValidators.required(errorText: "This field is required"),
      ),
    ],
  );
}
}