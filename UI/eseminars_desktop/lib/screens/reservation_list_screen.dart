import 'dart:math';

import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/reservations.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/seminars.dart';
import 'package:eseminars_desktop/providers/reservations_provider.dart';
import 'package:eseminars_desktop/providers/seminars_provider.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ReservationListScreen extends StatefulWidget {
  const ReservationListScreen({super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {

  SearchResult<Reservations>? result = null;
  late SeminarsProvider seminarsProvider;
  late ReservationsProvider reservationsProvider;
  SearchResult<Seminars>? typeOfSeminarsResult;
  bool isLoading = true;
  String? selectedSeminarId;
  int _selectedIndex = 0;
  int pageSize = 4;
  List<String> reservationStates = ["pending","approved","rejected"];
  String? currentReservationState;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    seminarsProvider = context.read<SeminarsProvider>();
    reservationsProvider = context.read<ReservationsProvider>();

    currentReservationState = reservationStates[0];

    WidgetsBinding.instance.addPostFrameCallback((_){
    initForm(); 
  });
  }

   Future initForm() async{
    var seminarFilter = {
      'isActive' : true
    };
    typeOfSeminarsResult = await seminarsProvider.get(filter: seminarFilter);

    setState(() {
      if(typeOfSeminarsResult?.result.isNotEmpty == true){
        selectedSeminarId = typeOfSeminarsResult?.result.first.seminarId.toString();
        _filterData("",state: currentReservationState);
      }
      isLoading = false;
    });
    
   }
   Future<void> _filterData(String query,{String? state}) async{
    _selectedIndex = 0;
    var filter = {
      'SeminarId': selectedSeminarId,
      'Page' : _selectedIndex,
      'PageSize': pageSize,
      'StateMachine' : state
    };
    result = await reservationsProvider.get(filter: filter);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen("Reservations",Column(
      children: [
        isLoading ? Container() :
        _buildFilter(),
        const SizedBox(height: 55,),
        _buildForm(),
        _buildPaging()
      ],
    ));
  }

  Widget _buildFilter(){
    return Row(
      children: [
        Expanded(flex: 2,child: Row(
          children: [
            ElevatedButton(onPressed: () async{
              setState(() {
                currentReservationState = reservationStates[0];
              });
              await _filterData("",state: currentReservationState);
            }, child: Text("Pending")),
            const SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
               setState(() {
                currentReservationState = reservationStates[1];
              });
              await _filterData("",state: currentReservationState);
            }, child: Text("Approved"),style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white
            ),),
            const SizedBox(width: 10,),
            ElevatedButton(onPressed: () async{
               setState(() {
                currentReservationState = reservationStates[2];
              });
              await _filterData("",state: currentReservationState);
            }, child: Text("Rejected"),style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white
            ),)
          ],
        )),
        Expanded(flex: 1,child: 
            FormBuilderDropdown(initialValue: selectedSeminarId,name: 'seminarId', items: typeOfSeminarsResult?.result.map((item) => DropdownMenuItem(value: item.seminarId.toString(),child: Text(item.naslov ?? "" ))).toList() ?? [],
            decoration: InputDecoration(
              labelText: "Seminar",border: 
              OutlineInputBorder(borderRadius: 
              BorderRadius.circular(30)),
              ),
              onChanged: (value) async{
                setState(() {
                  selectedSeminarId = value as String;
                });
                await _filterData("",state: currentReservationState);
              },
        ))
      ],
    );
  }

  Widget _buildForm(){
    return Expanded(child: 
    SingleChildScrollView(child: DataTable(
      columns: [
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Surname")),
        DataColumn(label: Text("Date")),
        if(currentReservationState == reservationStates[0]) ...[
          DataColumn(label: Text(""))
        ]
      ], 
      rows: result?.result.map((e) =>
      DataRow(cells: [
        DataCell(Text(e.korisnik?.ime ?? "")),
        DataCell(Text(e.korisnik?.prezime ?? "")),
        DataCell(Text(e.datumRezervacije!.substring(0,(e.datumRezervacije!.indexOf("T"))) ?? "")),
        if(currentReservationState == reservationStates[0]) ... [
        DataCell(Row(children: [
          IconButton(onPressed: () async{
            await reservationsProvider.allowReservation(e.rezervacijaId!);
            await _filterData("", state: currentReservationState);
          }, icon: Icon(Icons.check,color: Colors.green,)),
          const SizedBox(width: 10,),
          IconButton(onPressed: () async{
            await reservationsProvider.rejectReservation(e.rezervacijaId!);
            await _filterData("",state: currentReservationState);
          }, icon: Icon(Icons.close,color: Colors.red,)),
        ],)),
        ]
      ])
      ).toList().cast<DataRow>() ?? []),)
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
      await _filterData("",state: currentReservationState);
    },
  );
}
}