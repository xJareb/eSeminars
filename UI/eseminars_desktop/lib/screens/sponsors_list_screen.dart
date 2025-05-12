import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/sponsors.dart';
import 'package:eseminars_desktop/providers/sponsors_provider.dart';
import 'package:eseminars_desktop/screens/sponsors_details_screen.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class SponsorsListScreen extends StatefulWidget {
  const SponsorsListScreen({super.key});

  @override
  State<SponsorsListScreen> createState() => _SponsorsListScreenState();
}

class _SponsorsListScreenState extends State<SponsorsListScreen> {

  int _selectedIndex = 0;
  int pageSize = 4;
  SearchResult<Sponsors>? result = null;
  late SponsorsProvider provider;
  TextEditingController _filterSponsor = TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    provider = context.read<SponsorsProvider>();

    _loadData();
  }

  Future<void> _loadData() async{
    var filter = {
      'Page' : _selectedIndex,
      'PageSize': pageSize
    };
    result = await provider.get(filter: filter);

     setState((){         
     });
  }
  Future<void> _filterData(String query) async{
    _selectedIndex = 0;
    var filter = {
      'KompanijaGTE': _filterSponsor.text,
      'Page' : _selectedIndex,
      'PageSize': pageSize,
    };
    result = await provider.get(filter: filter);

    setState((){         
     });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen('Sponsors',Column(
      children: [
        _buildFiler(),
        const SizedBox(height: 55,),
        _buildForm(),
        _buildPaging()
      ],
    ));
  }

  Widget _buildFiler(){
    return Row(
      children: [
        Expanded(flex:2,child: Container()),
        Expanded(flex:1,child: Row(
          children: [
            Expanded(
              child: TextField(controller: _filterSponsor,
              onChanged: (value) {
                _filterData(value);
              },decoration: 
              InputDecoration(labelText: "Search sponsor",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)
              )),
              ),
            ),
            const SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SponsorsDetailsScreen()));
              await _loadData();
            }, child: Text("Add"))
          ],
        ))
      ],
    );
  }
  Widget _buildForm(){
    return Expanded(child: SingleChildScrollView(
      child: DataTable(showCheckboxColumn: false,columns: [
        DataColumn(label: Text("Company")),
        DataColumn(label: Text("Email")),
        DataColumn(label: Text("Phone number")),
        DataColumn(label: Text("Representative")),
        DataColumn(label: Text(""))
      ], rows: result?.result.map((e) => 
          DataRow(onSelectChanged: (selected) async{
            if(selected == true){
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SponsorsDetailsScreen(sponsors: e,)));
              await _loadData();
            }
          },cells: [
            DataCell(Text(e.naziv ?? "")),
            DataCell(Text(e.email ?? "")),
            DataCell(Text(e.telefon ?? "")),
            DataCell(Text(e.kontaktOsoba ?? "")),
            DataCell(ElevatedButton(child: Text("Remove"),onPressed: () async{
              await provider.softDelete(e.sponzorId!);
              await _loadData();
            },))
          ])
      ).toList().cast<DataRow>() ?? []
      ),
    ));
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