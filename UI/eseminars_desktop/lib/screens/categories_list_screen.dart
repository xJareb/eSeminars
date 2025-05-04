import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/categories.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/categories_provider.dart';
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
      _buildForm(),
      _buildPaging()
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
              labelText: "Pretraga kateogriju",
              labelStyle: TextStyle(fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)),
                ),
                )
                ),
            SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
            }, child: Text("Dodaj",style: TextStyle(fontSize: 15),))
          ],
        ),
        )
      ],
    );
  }

  Widget _buildForm(){
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(columns: [
          DataColumn(label: Text("Naziv")),
          DataColumn(label: Text(""))
        ], rows: result?.result.map((e) => DataRow(cells: [
          DataCell(Text(e.naziv ?? "")),
          DataCell(ElevatedButton(onPressed: () async{
            await provider.softDelete(e.kategorijaId!);
            await _loadData();
          },child: Text("Obriši"),))
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