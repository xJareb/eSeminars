import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/notifications.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/notifications_provider.dart';
import 'package:eseminars_desktop/screens/notifications_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsListScreen extends StatefulWidget {
  const NotificationsListScreen({super.key});

  @override
  State<NotificationsListScreen> createState() => _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen> {

  int _selectedIndex = 0;
  int pageSize = 4;
  SearchResult<Notifications>? result = null;
  late NotificationsProvider provider;
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    provider = context.read<NotificationsProvider>();

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

  @override
  Widget build(BuildContext context) {
    return MasterScreen('Notifications', Column(
      children: [
        _buildSearch(),
        const SizedBox(height: 55,),
        _buildForm(),
        _buildPaging()
      ],
    ));
  }


  Widget _buildSearch(){
    return Row(
      children: [
        Expanded(flex:2,child: Text("")),
        Expanded(flex:1,child: Row(
          children: [
            Expanded(child: TextField(decoration: InputDecoration(
            labelText: "Pretraži obavijest",
            labelStyle: TextStyle(fontSize: 15),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30)),
            ),
            )
            ),
            SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsDetailsScreen()));
              await _loadData();
            }, child: Text("Dodaj",style: TextStyle(fontSize: 15)))
          ],
        ))
      ],
    );
  }
  Widget _buildForm(){
    if(result == null){
      return Center(child: CircularProgressIndicator(),);
    }
    return Expanded(child: 
    SingleChildScrollView(child: 
    DataTable(
      showCheckboxColumn: false,
      columns: [
      DataColumn(label: Text("Naslov")),
      DataColumn(label: Text("Sadržaj")),
      DataColumn(label: Text("Datum objave")),
      DataColumn(label: Text("")),
    ], 
    rows: result?.result.map((e)=>
    DataRow(onSelectChanged: (selected) async{
      if(selected == true){
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsDetailsScreen(notifications: e,)));
        await _loadData();
      }
    },cells: [
      DataCell(Text(e.naslov ?? "")),
      DataCell(Text(e.sadrzaj ?? "")),
      DataCell(Text(e.datumObavijesti ?? "")),
      DataCell(ElevatedButton(child: Text("Obriši"),onPressed: () async{
        await provider.softDelete(e.obavijestId!);
        await _loadData();
      },))
    ])).toList().cast<DataRow>() ?? []
    ),
    )
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