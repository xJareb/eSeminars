import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/lecturers.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/lecturers_provider.dart';
import 'package:eseminars_desktop/screens/lecturers_details_screen.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LecturersListScreen extends StatefulWidget {
  const LecturersListScreen({super.key});

  @override
  State<LecturersListScreen> createState() => _LecturersListScreenState();
}
class _LecturersListScreenState extends State<LecturersListScreen> {

  late LecturersProvider provider;
  int _selectedIndex = 0;
  int pageSize = 4;
  int end = 17;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    provider = context.read<LecturersProvider>();
    _loadData();
  }

  SearchResult<Lecturers>? result = null;

  Future<void> _loadData() async{
    var filter = {
      'Page' : _selectedIndex,
      'PageSize': pageSize
    };
    result = await provider.get(filter: filter);
    final items = result?.result ?? [];

    if(items.isEmpty && _selectedIndex > 0){
      _selectedIndex--;
      filter['Page'] = _selectedIndex;
      result = await provider.get(filter: filter);
    }


     setState((){         
     });
  }
  Future<void> _filterData(String query) async{
    _selectedIndex = 0;
    var filter = {
      'ImePrezimeGTE': _nameSurnameGTE.text,
      'Email': _emailEqual.text,
      'Page' : _selectedIndex,
      'PageSize': pageSize,
    };
    result = await provider.get(filter: filter);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return MasterScreen('Lecturers', Column(children: [
      _buildFilters(),
      const SizedBox(height: 55,),
      _buildForm(),
      _buildPaging()
    ],));
  }

  TextEditingController _nameSurnameGTE = TextEditingController();
  TextEditingController _emailEqual = TextEditingController();

  Widget _buildFilters(){
    return Row(
      children: [
        Expanded(flex: 1,child: Text("")),
        Expanded(flex:2,child: Row(
          children: [
            Expanded(child: TextField(
              onChanged: (value){
                _filterData(value);
                
              },
              controller: _nameSurnameGTE,
              decoration: InputDecoration(
                labelText: "Search lecturer",
                labelStyle: TextStyle(fontSize: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)
                )
              ),
            )),
            const SizedBox(width: 15,),
            Expanded(child: TextField(
              controller: _emailEqual,
              onChanged: (value) {
                _filterData(value);
              },
              decoration: InputDecoration(
                labelText: "Email address",
                labelStyle: TextStyle(fontSize: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)
                )
              ),
            )),
            const SizedBox(width: 15,),
            ElevatedButton(onPressed: () async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => LecturersDetailsScreen()));
              await _loadData();
            }, child: Text("Add",style: TextStyle(fontSize: 15),))
          ],
        ))
      ],
    );
  }

  Widget _buildForm(){
    if(result == null){
      return Center(child: CircularProgressIndicator(),);
    }
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Surname")),
            DataColumn(label: Text("Biography")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Phone number")),
            DataColumn(label: Text(""))
          ], rows: result?.result.map((e) =>
              DataRow(onSelectChanged: (seleceted) async{
                if(seleceted == true){
                  await Navigator.of(context).push(MaterialPageRoute(builder: (context) => LecturersDetailsScreen(lecturers: e,)));
                  await _loadData();
                }
              },
              cells: [
                DataCell(Text(e.ime ?? "")),
                DataCell(Text(e.prezime ?? "")),
                DataCell(Text('${e.biografija!.substring(0,17 > e.biografija!.length ? e.biografija!.length : 17)}...' ?? "")),
                DataCell(Container(width: 120,child: Text(e.email ?? "",),)),
                DataCell(Text('${e.telefon}' ?? "")),
                DataCell(ElevatedButton(onPressed: () async{
                  await provider.softDelete(e.predavacId!);
                  await _loadData();
                },child: Text("Remove"),))
              ]
              )
          ).toList().cast<DataRow>() ?? [],
          ),
      ),
    );
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