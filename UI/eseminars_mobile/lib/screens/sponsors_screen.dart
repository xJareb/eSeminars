import 'dart:ffi';

import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/models/sponsors.dart';
import 'package:eseminars_mobile/models/sponsorsSeminars.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/providers/sponsorsSeminars_provider.dart';
import 'package:eseminars_mobile/providers/sponsors_provider.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:eseminars_mobile/utils/custom_form_builder_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class SponsorsScreen extends StatefulWidget {
  const SponsorsScreen({super.key});

  @override
  State<SponsorsScreen> createState() => _SponsorsScreenState();
}

class _SponsorsScreenState extends State<SponsorsScreen> {

  SearchResult<Seminars>? seminarsResult;
  SearchResult<Sponsorsseminars>? sponsorsSeminarsResult;
  SearchResult<Sponsors>? sponsorsForFormResult;
  late SeminarsProvider seminarsProvider;
  late SponsorsProvider sponsorsProvider;
  late SponsorsseminarsProvider sponsorsseminarsProvider;
  bool isLoadingSponsors = true;
  int? seminarId;
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKeySponsor = GlobalKey<FormBuilderState>();
  final RegExp capitalLetter = RegExp(r'^[A-Z].*');
  final RegExp noNumber = RegExp(r'^[^0-9]*$');
  RegExp phoneExp = RegExp( r'^\d{9,10}$');



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    seminarsProvider = context.read<SeminarsProvider>();
    sponsorsProvider = context.read<SponsorsProvider>();
    sponsorsseminarsProvider = context.read<SponsorsseminarsProvider>();
    
    _loadSeminars();
    _loadSponsors();
  }
  Future<void> _loadSponsors()async{
    sponsorsForFormResult = await sponsorsProvider.get();
    setState(() {
      
    });
  }
  Future<void> _loadSponsorsBySeminar({int? seminarId}) async{
      var filter = {
      'seminarId' : seminarId
    };
    sponsorsSeminarsResult = await sponsorsseminarsProvider.get(filter: filter);

    setState(() {
      isLoadingSponsors = false;
    });

  }

  Future<void> _loadSeminars() async{
    var filter = {
      'isActive' : true
    };
    seminarsResult = await seminarsProvider.get(filter: filter);

    if(seminarsResult?.result.isNotEmpty == true){
    seminarId = seminarsResult!.result.first.seminarId;
    await _loadSponsorsBySeminar(seminarId: seminarId);
    }
    setState(() {
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sponsors", ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 15,),
          Expanded(child: _buildSponsors())
        ],
      ),
    );
  }

  Widget _buildHeader(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 5,child: FormBuilderDropdown(
            initialValue: seminarId,
          hint: Text("Choose a seminar"),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
            )
          ),
          name: 'seminarId', 
          items: seminarsResult?.result.map((item) => DropdownMenuItem(value: item.seminarId,child: Text(item.naslov ?? ""))).toList() ?? [],
          onChanged: (value) async{
            if(value is int){
              seminarId = value;
              await _loadSponsorsBySeminar(seminarId: seminarId);
              setState(() {
                
              });
            }
          },
          )),
          const SizedBox(width: 10,),
          Expanded(flex: 1,child: IconButton(onPressed: () async{
            showDialog(context: context, builder: (context){
              return _buildDialog();
            });
          }, icon: Icon(Icons.add)))
        ],
      ),
    );
  }
  Widget _buildDialog(){
    return AlertDialog(
                title: const Text("New sponsor"),
                content: SingleChildScrollView(
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFormDropDownMenu<Seminars>(
                          "Seminars",
                          'seminarId',
                           seminarsResult?.result,
                          (s)=>s.naslov ?? "",
                          (s)=>s.seminarId,
                          icon: CupertinoIcons.book),
                          const SizedBox(height: 10,),
                        Row(children: [
                          Expanded(child: _buildFormDropDownMenu(
                        "Sponsors",
                        'sponzorId', 
                        sponsorsForFormResult?.result,
                        (sp) => sp.naziv ?? "",
                        (sp) => sp.sponzorId,
                        icon: CupertinoIcons.money_dollar)),
                        const SizedBox(width: 10,),
                        IconButton(onPressed: ()async{
                          Navigator.of(context).pop();
                          await showDialog(context: context, builder: (context){
                            return _buildSponsorsDialog();
                          });
                        }, icon: Icon(Icons.add))
                        ],),
                         const SizedBox(height: 10,),
                        _buildControls()
                      ],
                  )),
                ),
              );
  }
  Widget _buildSponsorsDialog(){
    return AlertDialog(
      title: Text("New sponsor"),
      content: SingleChildScrollView(
        child: FormBuilder(
          key: _formKeySponsor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
          children: [
            _buildFormControls('naziv', 'Company', CupertinoIcons.building_2_fill,extraValidators: [
              FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
              FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
            ]),
            const SizedBox(height: 10,),
            _buildFormControls('email', 'Email', Icons.email, extraValidators: [
              FormBuilderValidators.email(errorText: "Please enter a valid email format."),
            ]),
            const SizedBox(height: 10,),
            _buildFormControls('telefon', 'Phone number', Icons.phone,extraValidators: [
              FormBuilderValidators.match(phoneExp,errorText: "The phone number must contain 9 or 10 digits")
            ]),
            const SizedBox(height: 10,),
            _buildFormControls('kontaktOsoba', 'Representative person', Icons.person, extraValidators: [
              FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
              FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
            ]),
            const SizedBox(height: 10,),
            _buildSponsorControls()
        
          ],
        )),
      ),
    );
  }
  Widget _buildSponsorControls(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: ()async{
          Navigator.of(context).pop();
          await showDialog(context: context, builder: (context){
            return _buildDialog();
          });
        }, child: Text("Cancel"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black
        ),),
        const SizedBox(width: 15,),
        ElevatedButton(onPressed: ()async{
          if(_formKeySponsor.currentState?.saveAndValidate() == true){
            try {
              await sponsorsProvider.insert(_formKeySponsor.currentState?.value);
              await MyDialogs.showSuccessDialog(context, "New sponsor successfully added");
              Navigator.of(context).pop();
              await _loadSponsors();
              await showDialog(context: context, builder: (context){
              return _buildDialog();
            });

            } catch (e) {
              await MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception: ", ''));
            }
          }
        }, child: Text("Add"))
      ],
    );
  }
  Widget _buildControls(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      ElevatedButton(onPressed: ()async{
        Navigator.pop(context);
      }, 
      child: Text("Cancel")
      ,style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400],
        foregroundColor: Colors.black,
      ),
      ),
      const SizedBox(width: 10,),
      ElevatedButton(onPressed: ()async{
        if(_formKey.currentState?.saveAndValidate() == true){
          try {
            await sponsorsseminarsProvider.insert(_formKey.currentState?.value);
            Navigator.pop(context);
             await _loadSponsorsBySeminar(seminarId: seminarId);
            await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully added new sponsor"),duration: Duration(seconds: 3),backgroundColor: Colors.green,));
           
          } catch (e) {
            Navigator.pop(context);
            await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst("Exception", '')),duration: Duration(seconds: 3),backgroundColor: Colors.red));
          }
        }
      }, child: Text("Add"))
    ],);
  }
  Widget _buildSponsors() {
  return ListView.builder(
    itemCount: sponsorsSeminarsResult?.result.length ?? 0,
    itemBuilder: (context, index) {
      final sponsorSeminar = sponsorsSeminarsResult?.result[index];
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                     "${sponsorSeminar?.sponzor?.naziv ?? ""}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                              MyDialogs.showInformationDialog(context, "Are you sure you want to delete this sponsor from seminar?", ()async{
                              try {
                              await sponsorsseminarsProvider.softDelete(sponsorSeminar?.sponzoriSeminariId ?? 0);
                              await MyDialogs.showSuccessDialog(context, "Successfully removed sponsor from seminar");
                              await _loadSponsorsBySeminar(seminarId: seminarId);
                              } catch (e) {
                                await MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
                              }
                            });
                          } catch (e) {
                            await MyDialogs.showErrorDialog(context, "Something bad happened, please try again");
                          }
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.red,
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.email, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("${sponsorSeminar?.sponzor?.email ?? ""}")),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("${sponsorSeminar?.sponzor?.telefon ?? ""}")),
                ],
              ),
            ],
          ),
        ),
      );
    },
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
}