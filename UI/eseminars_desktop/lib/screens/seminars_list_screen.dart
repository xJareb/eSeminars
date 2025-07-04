import 'dart:math';

import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/categories.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/seminars.dart';
import 'package:eseminars_desktop/models/sponsors.dart';
import 'package:eseminars_desktop/models/sponsorsSeminars.dart';
import 'package:eseminars_desktop/providers/categories_provider.dart';
import 'package:eseminars_desktop/providers/seminars_provider.dart';
import 'package:eseminars_desktop/providers/sponsors_provider.dart';
import 'package:eseminars_desktop/providers/sponsors_seminars_provider.dart';
import 'package:eseminars_desktop/screens/seminars_details_screen.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class SeminarsListScreen extends StatefulWidget {
  SeminarsListScreen({super.key});

  @override
  State<SeminarsListScreen> createState() => _SeminarsListScreenState();
}

class _SeminarsListScreenState extends State<SeminarsListScreen> {

  SearchResult<Seminars>? result = null;
  final _formKey = GlobalKey<FormBuilderState>();
  late SponsorsProvider sponsorsProvider;
  late SeminarsProvider seminarsProvider;
  SearchResult<Seminars>? typeOfSeminarsResult; 
  SearchResult<Sponsors>? typeOfSponsorsResult;
  SearchResult<Seminars>? seminarsDropdown;
  late SponsorsSeminarsProvider sponsorsSeminarsProvider;
  late CategoriesProvider categoriesProvider;
  SearchResult<Categories>? typeOfCategories;
  SearchResult<Sponsorsseminars>? sponsorsSeminarsResult;
  bool isLoading = true;
  int _selectedIndex = 0;
  int pageSize = 4;
  String? selectedCategory;
  int? seminarId;

  bool isSeminarsActive = true;
  bool isSponsorsActive = false;
  bool isProcessing = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    sponsorsProvider = context.read<SponsorsProvider>();
    seminarsProvider = context.read<SeminarsProvider>();
    sponsorsSeminarsProvider = context.read<SponsorsSeminarsProvider>();
    categoriesProvider = context.read<CategoriesProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_){
    initForm();
    });

    _filterData();
  }
  Future<void> initForm() async{
    typeOfSeminarsResult = await seminarsProvider.get();
    typeOfSponsorsResult = await sponsorsProvider.get();
    typeOfCategories = await categoriesProvider.get();
    await _loadSeminarsDropDown();


    setState(() {
      if(typeOfCategories?.result.isNotEmpty == true){
        selectedCategory = typeOfCategories?.result.first.naziv.toString();
        _filterData();
      }
      isLoading = false;
      if(seminarsDropdown?.result.isNotEmpty == true){
        seminarId = seminarsDropdown?.result.first.seminarId;
      }
    });
  }
  Future<void> _loadSeminarsDropDown()async{
    var filter = {
      'isActive' : true
    };
    seminarsDropdown = await seminarsProvider.get(filter: filter);
    setState(() {
    });
  }
  Future<void> _loadData() async{
    var filter = {
      'Page' : _selectedIndex,
      'PageSize': pageSize
    };
    result = await seminarsProvider.get(filter: filter);
    final items = result?.result ?? [];

    if(items.isEmpty && _selectedIndex > 0){
      _selectedIndex--;
      filter['Page'] = _selectedIndex;
      result = await seminarsProvider.get(filter: filter);
    }

     setState((){         
     });
  }
  Future<void> _filterData() async{
    var filter = {
      'NaslovGTE': _searchSeminar.text,
      'Page' : _selectedIndex,
      'PageSize': pageSize,
      'KategorijaLIKE' : selectedCategory
    };
    result = await seminarsProvider.get(filter: filter);
    setState(() {});
  }
  Future<void> _loadSponsorsBySeminar()async{
    var filter = {
      'seminarId' : seminarId,
      'Page' : _selectedIndex,
      'PageSize' : pageSize
    };
    sponsorsSeminarsResult = await sponsorsSeminarsProvider.get(filter: filter);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen('Seminars', Column(children: [
     isLoading ? Container():
      _buildFilter(),
      const SizedBox(height: 55,),
      isSeminarsActive ? _buildForm() : Container(),
      isSponsorsActive ? _buildFormSponsors() : Container(),
      isSponsorsActive ? _buildPagingSponsors() : _buildPaging()
    ],));
  }

  TextEditingController _searchSeminar = TextEditingController();

  Widget _buildFilter(){
    return Row(
      children: [
        Expanded(flex: 1,child: Row(
          children: [
            IconButton(onPressed: isSeminarsActive ? null : () async {
              setState(() {
                isSeminarsActive = true;
                isSponsorsActive = false;
                _selectedIndex = 0;
                _filterData();
              });
            } , icon: Icon(Icons.cast_for_education)),
            const SizedBox(width: 10,),
            IconButton(onPressed: isSponsorsActive ? null : () async {
              setState(() {
                isSeminarsActive = false;
                isSponsorsActive = true;
                _selectedIndex = 0;
                _searchSeminar.clear();
                _loadSponsorsBySeminar();
              });
            }  , icon: Icon(Icons.attach_money)),

          ],
        )),
        Expanded(flex: 2,child: Row(
          children: [
            if(isSeminarsActive == true) ... [
            Expanded(child: TextField(controller: _searchSeminar,onChanged: (value) {
              setState(() {
                _selectedIndex = 0;
              });
             _filterData();
            },decoration: InputDecoration(labelText: "Search seminar",border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),)),
            ],
            const SizedBox(width: 10,),
             if(isSeminarsActive == true) ... [
            Expanded(child: FormBuilderDropdown(onChanged: (value) {
              setState(() {
                selectedCategory = value as String;
                _selectedIndex = 0;
              });
              _filterData();
            },initialValue: selectedCategory,decoration: InputDecoration(labelText: "Category", border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),name: 'kategorijaId', items: typeOfCategories?.result.map((item) => 
            DropdownMenuItem(value: item.naziv,child: Text(item.naziv ?? ""))).toList() ?? []))
            ],
            const SizedBox(width: 10,),
            if(isSponsorsActive == true) ... [
              Expanded(child: FormBuilderDropdown(decoration: InputDecoration(
                labelText: "Seminar",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30))),
                  initialValue:seminarId ,
                  name: 'seminarId', 
                  onChanged:(value) async{
                    setState(() {
                      seminarId = value as int;
                    });
                    await _loadSponsorsBySeminar();
                  },
                  items: seminarsDropdown?.result.map((item)=> DropdownMenuItem(value: item.seminarId,child: Text("${item.naslov}"))).toList() ?? []))
            ],
            const SizedBox(width: 10,),
            if(isSponsorsActive == true) ... [
            ElevatedButton(onPressed: (){
              isLoading ? Container() : showCustomDialog(context);
            }, child: Text("Sponsor"))
            ],
            const SizedBox(width: 10,),
            if(isSeminarsActive == true) ... [
            ElevatedButton(onPressed: () async{
              _searchSeminar.clear();
              var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeminarsDetailsScreen()));
              if(result == true){
                await _filterData();
              }
            }, child: Text("Add")),
            ]
          ],
        ))
      ],
    );
  }
  void showCustomDialog(BuildContext context){
    showGeneralDialog(context: context, pageBuilder: (context,animation1,animation2){
      return Container();
    },transitionBuilder: (context,a1,a2,widget){
      return ScaleTransition(scale: Tween<double>(begin: 0.5,end:1.0).animate(a1),
      child: FadeTransition(opacity: Tween<double>(begin: 0.5,end:1.0).animate(a1),
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Add sponsor"),
            TextButton(onPressed: (){
              Navigator.pop(context,true);
            }, child: Text("X",style: TextStyle(color: Colors.black)))
          ],
        ),
        content: _buildSponsorsForm(),
      ),),
      );
    });
  }
  Widget _buildSponsorsForm(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FormBuilder(key: _formKey,child: 
        Column(
          children: [
            const SizedBox(height: 20,),
            FormBuilderDropdown(validator: FormBuilderValidators.required(errorText:"This field is required."),
            decoration: InputDecoration(
              labelText: "Seminars",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20))),
                name: 'seminarId', 
                items: typeOfSeminarsResult?.result.map((item) => 
                DropdownMenuItem(value: item.seminarId,child: Text(item.naslov ?? ""))).toList() ?? []),
            const SizedBox(height: 30,),
            FormBuilderDropdown(validator: FormBuilderValidators.required(errorText: "This field is required."),
            decoration: InputDecoration(labelText: "Sponsors",border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)
            )),
            name: 'sponzorId', 
            items: typeOfSponsorsResult?.result.map((item) => 
            DropdownMenuItem(value: item.sponzorId,child: Text(item.naziv ?? ""))).toList() ?? []),
            const SizedBox(height: 30,),
          ],
        )),
        ElevatedButton(onPressed: () async{
          if(_formKey.currentState?.saveAndValidate() == true){
            try {
              await sponsorsSeminarsProvider.insert(_formKey.currentState?.value);
              _formKey.currentState?.reset();
              showSuccessMessage(context, "The sponsor successfully added in a seminar.");
              await _loadSponsorsBySeminar();
              Navigator.pop(context, true);
            } catch (e) {
              showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
              Navigator.pop(context, true);
            }
          }
        }, child: Text("Add"))
      ],
    );
  }
  Widget _buildFormSponsors(){
    if(sponsorsSeminarsResult?.result.length == 0){
      return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "Currently no sponsors available for this seminar.",
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
    return Expanded(child: 
    SingleChildScrollView(
      child: DataTable(columns: [
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Email")),
        DataColumn(label: Text("Phone")),
        DataColumn(label: Text(""))
      ], rows: sponsorsSeminarsResult?.result.map((e) => 
      DataRow(cells: [
        DataCell(Text(e.sponzor?.naziv ?? "")),
        DataCell(Text(e.sponzor?.email ?? "")),
        DataCell(Text(e.sponzor?.telefon ?? "")),
        DataCell(ElevatedButton(onPressed: ()async{
          await buildAlertDiagram(context: context, onConfirmDelete: ()async{
            try {
              await sponsorsSeminarsProvider.softDelete(e.sponzoriSeminariId!);
              showSuccessMessage(context, "Sponsor successfully removed");
            } catch (e) {
              showErrorMessage(context, e.toString().replaceFirst('Exception: ', ''));
            }
            await _loadSponsorsBySeminar();
            setState(() {});
          });
        },child: Text("Remove"),))
      ])).toList().cast<DataRow>() ?? []),
    ));
  }
  Widget _buildForm(){
    return Expanded(
      child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: 
      DataTable(
      showCheckboxColumn: false,
      columnSpacing: 14,
      columns: [
        DataColumn(label: Text("Seminar")),
        DataColumn(label: Text("Date")),
        DataColumn(label: Text("Location")),
        DataColumn(label: Text("Capacity")),
        DataColumn(label: Text("Reserved")),
        DataColumn(label: Text(""))
      ], rows: result?.result.map((e) =>
          DataRow(onSelectChanged: (selected) async{
            if(selected == true){
              try {
                List<String> actions = await seminarsProvider.allowedActions(e.seminarId!);
                if(actions.contains('Update')){
                  _searchSeminar.clear();
                  _filterData();
                  var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeminarsDetailsScreen(seminars: e,)));
                  if(result == true){
                  _filterData();
                }
                }
              } catch (e) {
                print(e.toString());
              }
            }
            
          },cells: [
          DataCell(Text(e.naslov ?? "")),
          DataCell(Text('${e.datumVrijeme!.substring(0,e.datumVrijeme!.indexOf("T"))} ${e.datumVrijeme!.substring(e.datumVrijeme!.indexOf("T") + 1,e.datumVrijeme!.indexOf(":") + 3)}' )),
          DataCell(Text(e.lokacija ?? "")),
          DataCell(Text(e.kapacitet.toString() ?? "")),
          DataCell(Text(e.zauzeti.toString() ?? "")),
          DataCell(Row(mainAxisAlignment: MainAxisAlignment.end,children: [
            FutureBuilder<List<String>>(
              future: seminarsProvider.allowedActions(e.seminarId!),
              builder: (context,snapshot){
                if (snapshot.hasError) {
                    return Text("Error");
                  }
                final actions = snapshot.data ?? [];
      
                return Row(
                  children: [
                    if(actions.contains('Activate'))
                    ElevatedButton(onPressed: isProcessing ? null : () async{
                      setState(() => isProcessing = true);
                      try {
                        await seminarsProvider.activateSeminar(e.seminarId!);
                        await _filterData();
                        showSuccessMessage(context, "Seminar successfully activated");
                        await _loadSeminarsDropDown();
                        setState(() {
                          seminarId = seminarsDropdown?.result.first.seminarId;
                        });
                        await Future.delayed(Duration(seconds: 3));
                      } catch (e) {
                        showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
                        await Future.delayed(Duration(seconds: 3));
                      } finally{
                        setState(() => isProcessing = false);
                      }
                    }, child: Text("Activate")),
                    if(actions.contains('Hide'))
                    ElevatedButton(onPressed: isProcessing ? null : () async{
                      setState(() => isProcessing = true);
                      try {
                        await seminarsProvider.hideSeminar(e.seminarId!);
                        await _filterData();
                        showSuccessMessage(context, "Seminar successfully hidden");
                        await _loadSeminarsDropDown();
                        setState(() {
                          seminarId = seminarsDropdown?.result.first.seminarId;
                        });
                        await Future.delayed(Duration(seconds: 3));
                      } catch (e) {
                        showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
                        await Future.delayed(Duration(seconds: 3));
                      } finally{
                        setState(() => isProcessing = false);
                      }
                    }, child: Text("Hide")),
                    if(actions.contains('Edit'))
                    ElevatedButton(onPressed: isProcessing ? null: () async{
                      setState(() => isProcessing = true);
                      try {
                        await seminarsProvider.editSeminar(e.seminarId!);
                        await _filterData();
                        showSuccessMessage(context, "Seminar successfully edited");
                        await _loadSeminarsDropDown();
                        setState(() {
                          seminarId = seminarsDropdown?.result.first.seminarId;
                        });
                        await Future.delayed(Duration(seconds: 3));
                      } catch (e) {
                        showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
                        await Future.delayed(Duration(seconds: 3));
                      } finally{
                        setState(() => isProcessing = false);
                      }
                    }, child: Text("Edit")),
                  ],
                );
              }
            ),
            ElevatedButton(onPressed: (){
              generatePdfReport(e);
            }, child: Text("Report"))
          ],))
      ])
      ).toList().cast<DataRow>() ?? [])
      ,),
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
      await _filterData();
    },
  );
}
Widget _buildPagingSponsors() {
  if(sponsorsSeminarsResult?.result.length == 0){
    return SizedBox.shrink();
  }
  return PaginationControls(
    currentPage: _selectedIndex,
    totalItems: sponsorsSeminarsResult?.count ?? 0,
    pageSize: pageSize,
    onPageChanged: (newPage) async {
      setState(() {
        _selectedIndex = newPage;
      });
      await _filterData();
    },
  );
}
void generatePdfReport(dynamic report) async {
  final pdf = pw.Document();

  String formatDateTime(String? datetime) {
    if (datetime == null || !datetime.contains('T')) return '';
    try {
      final date = datetime.substring(0, datetime.indexOf("T"));
      final time = datetime.substring(datetime.indexOf("T") + 1, datetime.indexOf(":") + 3);
      return "$date $time";
    } catch (e) {
      return '';
    }
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  report.naslov ?? '',
                  style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),

              pw.Center(
                child: pw.Text(
                  report.opis ?? '',
                  style: pw.TextStyle(fontSize: 18, fontStyle: pw.FontStyle.italic),
                ),
              ),
              pw.SizedBox(height: 20),

              pw.Text('Date & Time: ${formatDateTime(report.datumVrijeme)}', style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 5),
              pw.Text('Location: ${report.lokacija ?? '-'}', style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 5),
              pw.Text('Capacity: ${report.kapacitet ?? '-'}', style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 5),
              pw.Text(
                'Lecturer: ${report.predavac?.ime ?? '-'} ${report.predavac?.prezime ?? ''}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Organizer: ${report.korisnik?.ime ?? '-'} ${report.korisnik?.prezime ?? ''}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Category: ${report.kategorija?.naziv ?? '-'}', style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 20),

              pw.Text('Feedbacks:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              if (report.dojmovis != null && report.dojmovis.isNotEmpty)
                pw.Table.fromTextArray(
                  headers: ['User', 'Rating'],
                  data: report.dojmovis
                      .map<List<String>>(
                        (d) => [
                          '${d.korisnik?.ime ?? ''} ${d.korisnik?.prezime ?? ''}'.trim(),
                          '${d.ocjena ?? ''}'
                        ],
                      )
                      .toList(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
                  cellPadding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  cellAlignment: pw.Alignment.centerLeft,
                )
              else
                pw.Text('No feedbacks', style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
              pw.SizedBox(height: 20),

              pw.Text('Sponsors:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              if (report.sponzoriSeminaris != null && report.sponzoriSeminaris.isNotEmpty)
                pw.Table.fromTextArray(
                  headers: ['Sponsor Name'],
                  data: report.sponzoriSeminaris
                      .map<List<String>>(
                        (s) => ['${s.sponzor?.naziv ?? ''}'],
                      )
                      .toList(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.green),
                  cellPadding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                )
              else
                pw.Text('No sponsors', style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}
}


