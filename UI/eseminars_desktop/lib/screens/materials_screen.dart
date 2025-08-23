import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/materials.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/seminars.dart';
import 'package:eseminars_desktop/providers/materials_provider.dart';
import 'package:eseminars_desktop/providers/seminars_provider.dart';
import 'package:eseminars_desktop/screens/materials_details_screen.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {

  SearchResult<Seminars>? seminarsResult;
  SearchResult<Materials>? materialsResult;
  late MaterialsProvider materialsProvider;
  late SeminarsProvider seminarsProvider;
  int? seminarId;
  bool isLoadingMaterials = true;
  int _selectedIndex = 0;
  int pageSize = 4;

  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    seminarsProvider = context.read<SeminarsProvider>();
    materialsProvider = context.read<MaterialsProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_){
    initForm(); 
    });

  }
  Future initForm() async{
    await _loadSeminars();

    setState(() {
      if(seminarsResult?.result.isNotEmpty == true){
        seminarId = seminarsResult?.result.first.seminarId;
        _loadMaterials();
      }
    });
  }
  Future<void> _loadMaterials()async{
    var filter = {
      'SeminarId' : seminarId
    };
    materialsResult = await materialsProvider.get(filter: filter);
    setState(() {
      isLoadingMaterials = false;
    });
  }

  Future<void> _loadSeminars()async{
    var filter = {
    };
    seminarsResult = await seminarsProvider.get(filter: filter);

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen('Materials', Column(
      children: [
        _buildFilter(),
        isLoadingMaterials ? Center(child: CircularProgressIndicator(),) : _buildMaterials(),
        const SizedBox(height: 55,),
        _buildPaging()
      ],
    ));
  }


  Widget _buildFilter(){
    return Row(
      children: [
        Expanded(flex: 2,child: Container()),
        Expanded(flex: 1,child: Row(
          children: [
            Expanded(child: FormBuilderDropdown(
            decoration: InputDecoration(
              labelText: "Seminar",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)
              )
            ),
            name: 'seminarId',
            onChanged: (value) {
              seminarId = value as int;
              _loadMaterials();
            },
            initialValue: seminarId,
            items: seminarsResult?.result.map((item)=> DropdownMenuItem(value: item.seminarId,child: Text("${item.naslov ?? ""}"))).toList() ?? [] )),
            const SizedBox(width: 10,),
            ElevatedButton(onPressed: ()async{
             var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MaterialsDetailsScreen()));
             if(result == true){
              await _loadMaterials();
             }
            }, child: Text("Add")),
            
          ],
        ))
      ],
    );
  }
  Widget _buildMaterials() {
  if (materialsResult?.result.isEmpty ?? true) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "Currently no materials available.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  return Expanded(
    child: LayoutBuilder(
      builder: (context,constraints){
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: constraints.maxWidth * 0.9,
          child: DataTable(showCheckboxColumn: false,
            columns: const [
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Link")),
              DataColumn(label: Text("")),
            ],
            rows: materialsResult!.result.map((e) => DataRow(onSelectChanged: (selected) async{
              if(selected == true){
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MaterialsDetailsScreen(materials: e,)));
                await _loadMaterials();
              }
            },cells: [
              DataCell(Text(e.naziv ?? "")),
              DataCell(Text(e.putanja ?? "")),
              DataCell(ElevatedButton(
                onPressed: () async {
                  try {
                    await buildAlertDiagram(context: context, onConfirmDelete: () async {
                      await materialsProvider.softDelete(e.materijalId!);
                      showSuccessMessage(context, "Material successfully removed");
                    });
                  } catch (e) {
                    showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
                  }
                  await _loadMaterials();
                  setState(() {});
                },
                child: const Text("Remove"),
              )),
            ])).toList(),
          ),
        ),
      );
      }
    ),
  );
}
  Widget _buildPaging() {
  if ((materialsResult?.count ?? 0) == 0) {
    return SizedBox.shrink();
  }

  return PaginationControls(
    currentPage: _selectedIndex,
    totalItems: materialsResult!.count,
    pageSize: pageSize,
    onPageChanged: (newPage) async {
      setState(() {
        _selectedIndex = newPage;
      });
      await _loadMaterials();
    },
  );
}
}