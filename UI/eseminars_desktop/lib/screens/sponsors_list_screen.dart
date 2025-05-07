import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/sponsors.dart';
import 'package:eseminars_desktop/providers/sponsors_provider.dart';
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
              child: TextField(decoration: 
              InputDecoration(labelText: "Pretraži sponzora",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)
              )),
              ),
            ),
            const SizedBox(width: 10,),
            ElevatedButton(onPressed: (){}, child: Text("Dodaj"))
          ],
        ))
      ],
    );
  }
  Widget _buildForm(){
    return Expanded(child: SingleChildScrollView(
      child: DataTable(columns: [
        DataColumn(label: Text("Kompanije")),
        DataColumn(label: Text("Email")),
        DataColumn(label: Text("Telefon")),
        DataColumn(label: Text("Kontakt osoba")),
        DataColumn(label: Text(""))
      ], rows: result?.result.map((e) => 
          DataRow(cells: [
            DataCell(Text(e.naziv ?? "")),
            DataCell(Text(e.email ?? "")),
            DataCell(Text(e.telefon ?? "")),
            DataCell(Text(e.kontaktOsoba ?? "")),
            DataCell(ElevatedButton(child: Text("Obriši"),onPressed: () async{
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