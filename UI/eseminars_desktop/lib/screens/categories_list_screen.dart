import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/categories.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/categories_provider.dart';
import 'package:eseminars_desktop/screens/categories_details_screen.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {

  late CategoriesProvider provider;
  int _selectedIndex = 0;
  int pageSize = 4;
  


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
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    provider = context.read<CategoriesProvider>();

    _loadData();
  }
  Future<void> _filterData(String query) async{
    _selectedIndex = 0;
    var filter = {
      'NazivGTE': query,
      'Page' : _selectedIndex,
      'PageSize': pageSize,
    };
    result = await provider.get(filter: filter);
    setState(() {});
  }

  SearchResult<Categories>? result = null;
  @override
  Widget build(BuildContext context) {
    return MasterScreen('Categories', Column(children: [
      _buildSearch(),
      const SizedBox(height: 20,),
      result?.result.length == 0 ? Center(child: Text("Currently no categories available .",style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,),) :  _buildForm(),
      result?.result.length == 0 ? SizedBox.shrink() :_buildPaging()
    ],));
  }

  TextEditingController _categoryName = TextEditingController();
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
              controller: _categoryName,
              decoration: InputDecoration(
              labelText: "Search category",
              labelStyle: TextStyle(fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)),
                ),
                )
                ),
            SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriesDetailsScreen()));
              await _loadData();
            }, child: Text("Add",style: TextStyle(fontSize: 15),))
          ],
        ),
        )
      ],
    );
  }

  Widget _buildForm(){
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          showCheckboxColumn: false,
          columns: [
          DataColumn(label: Text("Title")),
          DataColumn(label: Text("Description")),
          DataColumn(label: Text(""))
        ], rows: result?.result.map((e) => DataRow(onSelectChanged: (selected) async{
          if(selected == true){
            var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriesDetailsScreen(categories: e,)));
            if(result == true){
              await _loadData();
            }
          }
        },cells: [
          DataCell(Text(e.naziv ?? "")),
          DataCell(Text('${e.opis!.substring(0,50 > e.opis!.length ? e.opis!.length : 50)}...' ?? "")),
          DataCell(ElevatedButton(onPressed: () async{
            await buildAlertDiagram(context: context, onConfirmDelete: () async{
              try {
                await provider.softDelete(e.kategorijaId!);
                showSuccessMessage(context, "Category successfully removed");
                
              } catch (e) {
                showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
              }finally {
          }
            });

            await _loadData();
            setState(() {});
          },child: Text("Remove"),))
        ])).toList().cast<DataRow>() ?? []
        ),
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