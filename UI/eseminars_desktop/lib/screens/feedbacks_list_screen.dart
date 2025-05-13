import 'dart:math';

import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/models/feedbacks.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/seminars.dart';
import 'package:eseminars_desktop/providers/feedbacks_provider.dart';
import 'package:eseminars_desktop/providers/seminars_provider.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class FeedbacksListScreen extends StatefulWidget {
  const FeedbacksListScreen({super.key});

  @override
  State<FeedbacksListScreen> createState() => _FeedbacksListScreenState();
}

class _FeedbacksListScreenState extends State<FeedbacksListScreen> {

  SearchResult<Feedbacks>? result = null;
  late FeedbacksProvider feedbacksProvider;
  late SeminarsProvider seminarsProvider;
  SearchResult<Seminars>? typeOfSeminarsResult;
  int _selectedIndex = 0;
  int pageSize = 4;
  bool isLoading = true;
  String? selectedSeminarId;
  String? selectedSeminarTitle;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    seminarsProvider = context.read<SeminarsProvider>();
    feedbacksProvider = context.read<FeedbacksProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_){
    initForm(); 
  });
    
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  Future<void> _filterData(String query) async{
    _selectedIndex = 0;
    var filter = {
      'SeminarId': selectedSeminarId,
      'Page' : _selectedIndex,
      'PageSize': pageSize,
    };
    result = await feedbacksProvider.get(filter: filter);
    setState(() {});
  }

  Future initForm() async{
    typeOfSeminarsResult = await seminarsProvider.get();

    setState(() {
      if(typeOfSeminarsResult?.result.isNotEmpty == true){
        selectedSeminarId = typeOfSeminarsResult?.result.first.seminarId.toString();
        _filterData("");
      }

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen('Feedbacks',Column(
      children: [
         isLoading ? Container() :
        _buildFilter(),
        const SizedBox(height: 55,),
        _buildForm()
      ],
    ));
  }

  Widget _buildFilter(){
    return Row(
      children: [
        Expanded(flex: 3,child: Container()),
        Expanded(flex: 2,child: FormBuilderDropdown(name: 'seminarId',decoration: InputDecoration(labelText: "Seminar",border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30))), items: 
          typeOfSeminarsResult?.result.map((item) => DropdownMenuItem(value: item.seminarId.toString(),child: Text(item.naslov ?? ""),)).toList() ?? []
        ,onChanged: (value){
          setState(() {
            selectedSeminarId = value as String;
          });
          _filterData("");
        },))
      ],
    );
  }
  //TODO:: Add Date of feedback
  Widget _buildForm(){
    return Expanded(child: 
    SingleChildScrollView(child: 
    DataTable(columns: [
      DataColumn(label: Text('User')),
      DataColumn(label: Text('Rating')),
      DataColumn(label: Text(""))
    ]
    , rows: result?.result.map((e) => DataRow(cells: [
      DataCell(Text(e.korisnik?.ime ?? "")),
      DataCell(buildStars(e.ocjena ?? 0)),
      DataCell(ElevatedButton(child: Text("Remove"),onPressed: () async{
        await buildAlertDiagram(context: context, onConfirmDelete: () async{

        });
      },
      )
      ),
    ]
    )
    ).toList().cast<DataRow>() ?? []
    )
    ,)
    );
  }

  Widget buildStars(int rating, {int maxRating = 5}) {
  return Row(
    children: List.generate(maxRating, (index) {
      if (index < rating) {
        return const Icon(Icons.star, color: Colors.amber, size: 20);
      } else {
        return const Icon(Icons.star_border, color: Colors.grey, size: 20);
      }
    }),
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
      await _filterData("");
    },
  );
}
}