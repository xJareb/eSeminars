import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/notifications.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/notifications_provider.dart';
import 'package:eseminars_desktop/screens/notifications_details_screen.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
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
  Future<void> _filterData(String query) async {
    _selectedIndex = 0;
    var filter = {
      'Page' : _selectedIndex,
      'PageSize' : pageSize,
      'NaslovLIKE' : _searchTitle.text
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
        result?.result.length == 0 ? Center(child: Text("Currently no notifications available .",style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,),) :  _buildForm(),
        result?.result.length == 0 ? SizedBox.shrink() :_buildPaging()
      ],
    ));
  }

  TextEditingController _searchTitle = TextEditingController();

  Widget _buildSearch(){
    return Row(
      children: [
        Expanded(flex:2,child: Text("")),
        Expanded(flex:1,child: Row(
          children: [
            Expanded(child: TextField(controller: _searchTitle,decoration: InputDecoration(
            labelText: "Search notification",
            labelStyle: TextStyle(fontSize: 15),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30)),
            ),onChanged: (value) {
              _filterData(value);
              print(_searchTitle.text);
            },
            )
            ),
            SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
              _searchTitle.clear();
              var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsDetailsScreen()));
              if(result == true){
                await _loadData();
              }
            }, child: Text("Add",style: TextStyle(fontSize: 15)))
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
    LayoutBuilder(
      builder: (context,constraints){
      return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: 
      Container(
        width: constraints.maxWidth * 0.9,
        child: DataTable(
          showCheckboxColumn: false,
          columns: [
          DataColumn(label: Text("Title")),
          DataColumn(label: Text("Content")),
          DataColumn(label: Text("Publication date")),
          DataColumn(label: Text("")),
        ], 
        rows: result?.result.map((e)=>
        DataRow(onSelectChanged: (selected) async{
          if(selected == true){
            _searchTitle.clear();
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsDetailsScreen(notifications: e,)));
            await _loadData();
          }
        },cells: [
          DataCell(Text(e.naslov ?? "")),
          DataCell(Text(e.sadrzaj != null && e.sadrzaj!.length > 17 ? '${e.sadrzaj!.substring(0, 17)}...' : (e.sadrzaj ?? ''))),
          DataCell(Text('${e.datumObavijesti!.substring(0,e.datumObavijesti!.indexOf("T"))} ${e.datumObavijesti!.
          substring(e.datumObavijesti!.indexOf("T") + 1,e.datumObavijesti!.indexOf("."))}' ?? "")),
          DataCell(ElevatedButton(child: Text("Remove"),onPressed: () async{
            await buildAlertDiagram(context: context, onConfirmDelete: () async{
              try {
                await provider.softDelete(e.obavijestId!);
                showSuccessMessage(context, "Notification successfully removed");
              } catch (e) {
                showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
              }
            });
            await _loadData();
            setState(() {
            });
          },))
        ])).toList().cast<DataRow>() ?? []
        ),
      ),
      );
      }
    )
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