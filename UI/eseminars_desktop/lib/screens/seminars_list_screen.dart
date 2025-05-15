import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/seminars.dart';
import 'package:eseminars_desktop/models/sponsors.dart';
import 'package:eseminars_desktop/models/sponsorsSeminars.dart';
import 'package:eseminars_desktop/providers/seminars_provider.dart';
import 'package:eseminars_desktop/providers/sponsors_provider.dart';
import 'package:eseminars_desktop/providers/sponsors_seminars_provider.dart';
import 'package:eseminars_desktop/screens/seminars_details_screen.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class SeminarsListScreen extends StatefulWidget {
  const SeminarsListScreen({super.key});

  @override
  State<SeminarsListScreen> createState() => _SeminarsListScreenState();
}

class _SeminarsListScreenState extends State<SeminarsListScreen> {

  SearchResult<Seminars>? result = null;
  final _formKey = GlobalKey<FormBuilderState>();
  late SponsorsProvider sponsorsProvider;
  late SeminarsProvider seminarsProvider;
  SearchResult<Seminars>? typeOfSeminarsResult; 
  SearchResult<Sponsors>? typeOfSponsorsResult;
  late SponsorsSeminarsProvider sponsorsSeminarsProvider;
  bool isLoading = true;
  int _selectedIndex = 0;
  int pageSize = 4;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    sponsorsProvider = context.read<SponsorsProvider>();
    seminarsProvider = context.read<SeminarsProvider>();
    sponsorsSeminarsProvider = context.read<SponsorsSeminarsProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_){
    initForm();
    });

    _loadData();
  }
  Future<void> initForm() async{
    typeOfSeminarsResult = await seminarsProvider.get();
    typeOfSponsorsResult = await sponsorsProvider.get();


    setState(() {
      isLoading = false;
    });
  }
  Future<void> _loadData() async{
    var filter = {
      'Page' : _selectedIndex,
      'PageSize': pageSize
    };
    result = await seminarsProvider.get(filter: filter);
    final items = result?.result ?? [];

    if(items.isEmpty && _selectedIndex > 0){
      _selectedIndex--;
      filter['Page'] = _selectedIndex;
      result = await seminarsProvider.get(filter: filter);
    }

     setState((){         
     });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen('Seminars', Column(children: [
      _buildFilter(),
      const SizedBox(height: 55,),
      _buildForm(),
      _buildPaging()
    ],));
  }


  Widget _buildFilter(){
    return Row(
      children: [
        Expanded(flex: 1,child: Container()),
        Expanded(flex: 2,child: Row(
          children: [
            Expanded(child: TextField(decoration: InputDecoration(labelText: "Search seminar",border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),)),
            const SizedBox(width: 10,),
            Expanded(child: FormBuilderDropdown(decoration: InputDecoration(labelText: "Category", border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),name: 'name', items: [])),
            const SizedBox(width: 10,),
            ElevatedButton(onPressed: (){
              isLoading ? Container() : showCustomDialog(context);
            }, child: Text("Sponsor")),
            const SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeminarsDetailsScreen()));
            }, child: Text("Add")),
          ],
        ))
      ],
    );
  }
  void showCustomDialog(BuildContext context){
    showGeneralDialog(context: context, pageBuilder: (context,animation1,animation2){
      return Container();
    },transitionBuilder: (context,a1,a2,widget){
      return ScaleTransition(scale: Tween<double>(begin: 0.5,end:1.0).animate(a1),
      child: FadeTransition(opacity: Tween<double>(begin: 0.5,end:1.0).animate(a1),
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Add sponsor"),
            TextButton(onPressed: (){
              Navigator.pop(context,true);
            }, child: Text("X",style: TextStyle(color: Colors.black)))
          ],
        ),
        content: _buildSponsorsForm(),
      ),),
      );
    });
  }
  Widget _buildSponsorsForm(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FormBuilder(key: _formKey,child: 
        Column(
          children: [
            const SizedBox(height: 20,),
            FormBuilderDropdown(validator: FormBuilderValidators.required(errorText:"This field is required."),
            decoration: InputDecoration(
              labelText: "Seminars",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20))),
                name: 'seminarId', 
                items: typeOfSeminarsResult?.result.map((item) => 
                DropdownMenuItem(value: item.seminarId,child: Text(item.naslov ?? ""))).toList() ?? []),
            const SizedBox(height: 30,),
            FormBuilderDropdown(validator: FormBuilderValidators.required(errorText: "This field is required."),
            decoration: InputDecoration(labelText: "Sponsors",border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)
            )),
            name: 'sponzorId', 
            items: typeOfSponsorsResult?.result.map((item) => 
            DropdownMenuItem(value: item.sponzorId,child: Text(item.naziv ?? ""))).toList() ?? []),
            const SizedBox(height: 30,),
          ],
        )),
        ElevatedButton(onPressed: () async{
          if(_formKey.currentState?.saveAndValidate() == true){
            try {
              await sponsorsSeminarsProvider.insert(_formKey.currentState?.value);
              _formKey.currentState?.reset();
              showSuccessMessage(context, "The sponsor already exists in a seminar.");
              Navigator.pop(context, true);
            } catch (e) {
              showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
              Navigator.pop(context, true);
            }
          }
        }, child: Text("Add"))
      ],
    );
  }
  Widget _buildForm(){
    return Expanded(child: 
    SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: 
    DataTable(columns: [
      DataColumn(label: Text("Seminar")),
      DataColumn(label: Text("Date")),
      DataColumn(label: Text("Location")),
      DataColumn(label: Text("Capacity")),
      DataColumn(label: Text("Category")),
      DataColumn(label: Text(""))
    ], rows: result?.result.map((e) =>
        DataRow(cells: [
        DataCell(Text(e.naslov ?? "")),
        DataCell(Text('${e.datumVrijeme!.substring(0,e.datumVrijeme!.indexOf("T"))} ${e.datumVrijeme!.substring(e.datumVrijeme!.indexOf("T") + 1,e.datumVrijeme!.indexOf(":") + 3)}' )),
        DataCell(Text(e.lokacija ?? "")),
        DataCell(Text(e.kapacitet.toString() ?? "")),
        DataCell(Text(e.kategorija!.naziv ?? "")),
        DataCell(ElevatedButton(child: Text("Report"),onPressed: (){}))
    ])
    ).toList().cast<DataRow>() ?? [])
    ,));
  }
  Widget _buildPaging() {
  return PaginationControls(
    currentPage: _selectedIndex,
    totalItems: result?.count ?? 0,
    pageSize: pageSize,
    onPageChanged: (newPage) async {
      setState(() {
        _selectedIndex = newPage;
      });
      await _loadData();
    },
  );
}
}