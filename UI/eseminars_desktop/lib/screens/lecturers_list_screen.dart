import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/lecturers.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/lecturers_provider.dart';
import 'package:eseminars_desktop/screens/lecturers_details_screen.dart';
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
                labelText: "Pretraži predavača",
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
                labelText: "Pretraži email",
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
            }, child: Text("Dodaj",style: TextStyle(fontSize: 15),))
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
        child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text("Ime")),
            DataColumn(label: Text("Prezime")),
            DataColumn(label: Text("Biografija")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Telefon")),
            DataColumn(label: Text(""))
          ], rows: result?.result.map((e) =>
              DataRow(onSelectChanged: (seleceted){
                if(seleceted == true){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LecturersDetailsScreen(lecturers: e,)));
                }
              },
              cells: [
                DataCell(Text(e.ime ?? "")),
                DataCell(Text(e.prezime ?? "")),
                DataCell(Text(e.biografija ?? "")),
                DataCell(Container(width: 120,child: Text(e.email ?? "",),)),
                DataCell(Text(e.telefon ?? "")),
                DataCell(ElevatedButton(onPressed: () async{
                  await provider.softDelete(e.predavacId!);
                  await _loadData();
                },child: Text("Obriši"),))
              ]
              )
          ).toList().cast<DataRow>() ?? [],
          ),
      ),
    );
  }

  Widget _buildPaging(){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPreviousPage(),
          SizedBox(width: 10),
          Text((_selectedIndex+1).toString(),style: TextStyle(fontSize: 16),),
          SizedBox(width: 10),
          _buildNextPage(),
        ],
      ),
    );
  }

   Widget _buildPreviousPage(){
    return ElevatedButton(onPressed: _selectedIndex > 0 ? () async{
            setState(() {
              _selectedIndex--;
            });
            await _loadData();
          } : null, child: Icon(Icons.navigate_before));
  }
  Widget _buildNextPage(){
    int totalItems = result?.count ?? 0;
    int totalPages = (totalItems / pageSize).ceil();
    return ElevatedButton(onPressed: (_selectedIndex + 1) <  totalPages ? () async{
            setState(() {
              _selectedIndex ++;
            });
            await _loadData();
          }:null, child: Icon(Icons.navigate_next));
  }
}