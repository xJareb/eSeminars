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
    var seminarFilter = {
      'isActive' : true
    };
    typeOfSeminarsResult = await seminarsProvider.get(filter: seminarFilter);

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
        _buildForm(),
        _buildPaging()
      ],
    ));
  }

  Widget _buildFilter(){
    return Row(
      children: [
        Expanded(flex: 3,child: Container()),
        Expanded(flex: 2,child: FormBuilderDropdown(initialValue: selectedSeminarId,name: 'seminarId',decoration: InputDecoration(labelText: "Seminar",border: OutlineInputBorder(
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

  Widget _buildForm() {
  if (result?.result.isEmpty ?? true) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "Currently no feedbacks available.",
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
    child: SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('User')),
          DataColumn(label: Text('Rating')),
          DataColumn(label: Text('')),
        ],
        rows: result!.result.map((e) => DataRow(cells: [
          DataCell(Text(e.korisnik?.ime ?? "")),
          DataCell(buildStars(e.ocjena ?? 0)),
          DataCell(ElevatedButton(
            child: const Text("Remove"),
            onPressed: () async {
              await buildAlertDiagram(context: context, onConfirmDelete: () async {
                try {
                  await feedbacksProvider.softDelete(e.dojamId!);
                  showSuccessMessage(context, "Feedback successfully removed");
                } catch (e) {
                  showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
                }
              });
              await _filterData("");
              setState(() {});
            },
          )),
        ])).toList(),
      ),
    ),
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
  if ((result?.count ?? 0) == 0) {
    return SizedBox.shrink();
  }

  return PaginationControls(
    currentPage: _selectedIndex,
    totalItems: result!.count,
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