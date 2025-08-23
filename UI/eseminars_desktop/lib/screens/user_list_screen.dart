import 'dart:math';

import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/korisnici_provider.dart';
import 'package:eseminars_desktop/screens/user_details_screen.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
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
        result?.result.length == 0 ? Center(child:Text("Currently no materials available.",style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,)) :_buildResultView(),
        result?.result.length == 0 ? SizedBox.shrink() :_buildPaging()
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
              labelText: "Search user",
              labelStyle: TextStyle(fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)),
                ),
                )
                ),
            SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
              _userController.clear();
              await _loadData();
              final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDetailsScreen()));
              if(result == true){
                await _loadData();
              }
              
            }, child: Text("Add",style: TextStyle(fontSize: 15),))
          ],
        ),
        )
      ],
    );
  }

  Widget _buildResultView() {
  if (result == null) {
    return Center(child: CircularProgressIndicator());
  }

  return Expanded(
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: constraints.maxWidth * 0.9, // 90% širine ekrana
            child: DataTable(
              columnSpacing: 20,
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Surname")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Date of Birth")),
                DataColumn(label: Text("")),
              ],
              rows: result?.result.map((e) {
                return DataRow(
                  onSelectChanged: (selected) async {
                    _userController.clear();
                    if (selected == true) {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(user: e),
                        ),
                      );
                      await _loadData();
                    }
                  },
                  cells: [
                    DataCell(Text(e.ime ?? "")),
                    DataCell(Text(e.prezime ?? "")),
                    DataCell(Text(e.email ?? "")),
                    DataCell(Text((e.datumRodjenja ?? "").split("T").first)),
                    DataCell(
                      ElevatedButton(
                        onPressed: () async {
                          await buildAlertDiagram(
                            context: context,
                            onConfirmDelete: () async {
                              try {
                                await provider.softDelete(e.korisnikId!);
                                showSuccessMessage(context, "Record successfully removed");
                              } on Exception catch (e) {
                                showErrorMessage(context, e.toString());
                              }
                            },
                          );
                          await _loadData();
                          setState(() {});
                        },
                        child: const Text("Remove"),
                      ),
                    ),
                  ],
                );
              }).toList() ?? [],
            ),
          ),
        );
      },
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