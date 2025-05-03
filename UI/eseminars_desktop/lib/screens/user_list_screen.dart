import 'dart:math';

import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/korisnici_provider.dart';
import 'package:eseminars_desktop/screens/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {

  late KorisniciProvider provider;

  int _selectedIndex = 0;
  int pageSize = 4;
 
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    provider = context.read<KorisniciProvider>();

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
      'ImePrezimeGTE': query,
      'Page' : _selectedIndex,
      'PageSize': pageSize,
    };
    result = await provider.get(filter: filter);
    setState(() {});
  }

  SearchResult<Korisnik>? result = null;
 
  @override
  Widget build(BuildContext context) {

    return MasterScreen("Users", Column(
      children: [
        _buildSearch(),
        SizedBox(height: 55,),
        _buildResultView(),
        _buildPaging()
      ],
    ));
  }
  TextEditingController _userController = TextEditingController();

  Widget _buildSearch(){
    return Row(
      children: [
        Expanded(flex: 2,child: Text("")),
        Expanded(flex:1,child: Row(
          children: [
            Expanded(child: TextField(
              onChanged: (value) {
                _filterData(value);
              },
              controller: _userController,
              decoration: InputDecoration(
              labelText: "Pretraga korisnika",
              labelStyle: TextStyle(fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)),
                ),
                )
                ),
            SizedBox(width: 10,),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDetailsScreen()));
            }, child: Text("Dodaj",style: TextStyle(fontSize: 15),))
          ],
        ),
        )
      ],
    );
  }

  Widget _buildResultView() {
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
        DataColumn(label: Text("Email")),
        DataColumn(label: Text("Datum rođenja")),
        DataColumn(label: Text(""))
      ], rows: result?.result.map((e) =>
          DataRow(
            onSelectChanged: (selected) =>{
              if(selected == true){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserDetailsScreen(user: e,)))
              }
            },
            cells: [
            DataCell(Text(e.ime ?? "")),
            DataCell(Text(e.prezime ?? "")),
            DataCell(Text(e.email ?? "")),
            DataCell(Text(e.datumRodjenja ?? "")),
            DataCell(ElevatedButton(child: Text("Obriši"),onPressed: () async{
              await provider.softDelete(e.korisnikId!);
              await _loadData();
            },))
          ])
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
          Text((_selectedIndex + 1).toString(),style: TextStyle(fontSize: 16),),
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