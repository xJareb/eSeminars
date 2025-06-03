import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/categories.dart';
import 'package:eseminars_mobile/models/lecturers.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/categories_provider.dart';
import 'package:eseminars_mobile/providers/lecturers_provider.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/screens/seminars_materials_freedbacks.dart';
import 'package:eseminars_mobile/utils/custom_form_builder_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SeminarsManageScreen extends StatefulWidget {
  const SeminarsManageScreen({super.key});

  @override
  State<SeminarsManageScreen> createState() => _SeminarsManageScreenState();
}

class _SeminarsManageScreenState extends State<SeminarsManageScreen> {

  final RegExp capitalLetter = RegExp(r'^[A-Z].*');
  final RegExp noNumber = RegExp(r'^[^0-9]*$');
  final _formKey = GlobalKey<FormBuilderState>();
  SearchResult<Lecturers>? lecturersResult;
  SearchResult<Categories>? categoriesResult;
  SearchResult<Seminars>? seminarResult = null;
  late CategoriesProvider categoriesProvider;
  late LecturersProvider lecturersProvider;
  late SeminarsProvider seminarsProvider;
  bool isLoading = true;
  bool isActive = true;
  bool isOnWait = false;
  int _selectedIndex = 0;
  int pageSize = 3;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    categoriesProvider = context.read<CategoriesProvider>();
    lecturersProvider = context.read<LecturersProvider>();
    seminarsProvider = context.read<SeminarsProvider>();
    _loadCategories();
    _loadLectures();
    _loadSeminars();
  }
  Future<void> _loadLectures()async{
    lecturersResult = await lecturersProvider.get();
    setState(() {
    });
  }
  Future<void> _loadSeminars()async{
    var filter = {
      'dateTime' :true,
      'Page' : _selectedIndex,
      'PageSize' : pageSize,
      'isDraft' : isOnWait ? true : false,
      'isActive' : isActive ? true : false
    };
    seminarResult = await seminarsProvider.get(filter: filter);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadCategories()async{
    categoriesResult = await categoriesProvider.get();
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25,),
        _buildControls(),
        const SizedBox(height: 15,),
        isLoading ? Center(child: CircularProgressIndicator(),):_buildContentSeminars(),
        _buildPagination()

      ],
    );
  }
  Widget _buildControls() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isOnWait = true;
                isActive = false;
                _selectedIndex = 0;
              });
              _loadSeminars();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: isOnWait ? Colors.blue[600] : null,
              foregroundColor: isOnWait ? Colors.white : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            child: const Text("On wait"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isOnWait = false;
                isActive = true;
                _selectedIndex = 0;
              });
              _loadSeminars();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: isActive ? Colors.blue[600] : null,
              foregroundColor: isActive ? Colors.white : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            child: const Text("Active"),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent,
            border: Border.all(width: 1.2, color: Colors.grey.shade400),
          ),
          child: IconButton(
            icon: const Icon(CupertinoIcons.add,color: Colors.white,),
            onPressed: () {
              showDialog(context: context, builder: (context){
                return _buildForm();
              });
            },
            tooltip: "Add",
          ),
        ),
      ],
    ),
  );
}

  Widget _buildPagination() {
  final totalRecords = seminarResult?.count ?? 0;
  final totalPages = (totalRecords/pageSize).ceil();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _selectedIndex > 0 ? (){
            setState(() {
              _selectedIndex--;
            });
            _loadSeminars();
          } : null,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            elevation: 2,
          ),
          child: const Icon(Icons.navigate_before),
        ),
        const SizedBox(width: 16),
        Text(
          "${_selectedIndex + 1}",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _selectedIndex < totalPages - 1 ? ()async{
            setState(() {
              _selectedIndex++;
            });
            _loadSeminars();
          } : null,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            elevation: 2,
          ),
          child: const Icon(Icons.navigate_next),
        ),
      ],
    ),
  );
}
  Widget _buildContentSeminars() {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.65,
    child: ListView.builder(
      itemCount: seminarResult?.result.length,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.18,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(2, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${seminarResult?.result[index].naslov}", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text("${seminarResult?.result[index].opis}", style: GoogleFonts.poppins(fontSize: 14)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date: ${seminarResult?.result[index].datumVrijeme!.substring(0,seminarResult!.result[index].datumVrijeme!.indexOf("T"))} ${seminarResult?.result[index].datumVrijeme!.substring(seminarResult!.result[index].datumVrijeme!.indexOf("T") + 1, seminarResult!.result[index].datumVrijeme!.indexOf(":") + 3)}", style: GoogleFonts.poppins(fontSize: 13)),
                    ElevatedButton(
                      onPressed: () async{
                        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeminarsMaterialsFreedbacks(seminar: seminarResult?.result[index],)));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: const Text("Details"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
    Widget _buildForm() {
  return AlertDialog(
    title: const Text("New seminar"),
    content: SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFormControls("naslov", "Title", Icons.title,extraValidators: [
            FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
            FormBuilderValidators.minLength(3, errorText: "This field must contain at least three characters."),
            FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
            ]),
            const SizedBox(height: 10),
            _buildFormControls("opis", "Description", Icons.description,extraValidators: [
            FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
            FormBuilderValidators.minLength(3, errorText: "This field must contain at least three characters."),
            FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
            ]),
            const SizedBox(height: 10),
            _buildFormControls("lokacija", "Location", Icons.location_on,extraValidators: [
              FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
            FormBuilderValidators.minLength(3, errorText: "This field must contain at least three characters."),
            ]),
            const SizedBox(height: 10),
            _buildFormControls("kapacitet", "Seats", Icons.event_seat),
            const SizedBox(height: 10),
            _buildFormDateTimePicker(),
            const SizedBox(height: 10),
            _buildFormDropDownMenu<Categories>(
              "Category",
              "kategorijaId",
              categoriesResult?.result,
              (k) => k.naziv ?? '',
              (k) => k.kategorijaId,
              icon: Icons.category,
            ),
            const SizedBox(height: 10),
            _buildFormDropDownMenu<Lecturers>(
              "Lecturer",
              "predavacId",
              lecturersResult?.result,
              (l) => "${l.ime} ${l.prezime}",
              (l) => l.predavacId,
              icon: Icons.person,
            ),
            const SizedBox(height: 10),
            _buildFormButtons(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}
    Widget _buildFormControls(String name, String label, IconData iconData,{List<FormFieldValidator<String>>? extraValidators}) {
    return CustomFormBuilderTextField(
    name: name,
    label: label,
    suffixIcon: Icon(iconData, color: Colors.grey[700]),
    filled: true,
    fillColor: Colors.grey[100],
    validators: [
      FormBuilderValidators.required(errorText: "This field is required"),
      ...?extraValidators
    ],
  );
  }
    Widget _buildFormButtons(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel"),style: 
          ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[400],
            foregroundColor: Colors.black,
          ),),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: () async{
            if(_formKey.currentState?.saveAndValidate() == true){
              final formValues = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
               if (formValues != null) {
              formValues['datumVrijeme'] = formValues['datumVrijeme']?.toIso8601String();
              }
              try {
                await seminarsProvider.insert(formValues);
                Navigator.pop(context);
                await _loadSeminars();
                setState(() {
                  isActive = true;
                  isOnWait = false;
                  _selectedIndex = 0;
                });
                await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully added seminar"),duration: Duration(seconds: 4),backgroundColor: Colors.green,));
                
              } catch (e) {
                Navigator.pop(context);
                await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst("Exception", '')),duration: Duration(seconds: 4),backgroundColor: Colors.red));
              }
            }
          }, child: Text("Add"))
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
  return FormBuilderDropdown(
    name: name,
    decoration: InputDecoration(
      labelText: hintText,
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
  );
}

    Widget _buildFormDateTimePicker() {
  final DateTime initial = DateTime.now().add(const Duration(days: 1));

  return FormBuilderDateTimePicker(
    name: 'datumVrijeme',
    inputType: InputType.both,
    firstDate: initial,
    initialDate: initial,
    decoration: InputDecoration(
      labelText: "Date & Time",
      filled: true,
      fillColor: Colors.grey[100],
      suffixIcon: Icon(Icons.event, color: Colors.grey[700]),
      border: const OutlineInputBorder(),
    ),
    validator: FormBuilderValidators.required(errorText: "Please pick a date and time"),
  );
}
}