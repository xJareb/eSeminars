import 'dart:math';

import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/korisnici_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {

  late KorisniciProvider provider;
  
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    provider = context.read<KorisniciProvider>();
  }

  SearchResult<Korisnik>? result = null;
  @override
  Widget build(BuildContext context) {
    return MasterScreen("Users", Column(
      children: [
        _buildSearch(),
        SizedBox(height: 55,),
        _buildResultView()
      ],
    ));
  }

  Widget _buildSearch(){
    return Row(
      children: [
        Expanded(child: Text("")),
        Expanded(child: Row(
          children: [
            Expanded(child: TextField(
              decoration: InputDecoration(
              labelText: "Pretraga korisnika",
              labelStyle: TextStyle(fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)),
                ),
                )
                ),
            SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
              
              result = await provider.get();
              setState((){
                
              });
            }, child: Text("Pretrazi")),
            SizedBox(width: 10,),
            ElevatedButton(onPressed: (){}, child: Text("Dodaj",style: TextStyle(fontSize: 15),))
          ],
        ),
        )
      ],
    );
  }

  Widget _buildResultView() {
  return DataTable(columns: [
    DataColumn(label: Text("Ime")),
    DataColumn(label: Text("Prezime")),
    DataColumn(label: Text("Email")),
    DataColumn(label: Text("Datum rođenja")),
    DataColumn(label: Text(""))
  ], rows: result?.result.map((e) =>
      DataRow(cells: [
        DataCell(Text(e.ime ?? "")),
        DataCell(Text(e.prezime ?? "")),
        DataCell(Text(e.email ?? "")),
        DataCell(Text(e.datumRodjenja ?? "")),
        DataCell(ElevatedButton(child: Text("Obriši"),onPressed: (){},))
      ])
  ).toList().cast<DataRow>() ?? [],
  );
}
}