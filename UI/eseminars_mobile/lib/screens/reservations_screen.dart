import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/reservations.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/reservations_provider.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/utils/TCustomCurvedEdges.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {

  SearchResult<Seminars>? seminarResult;
  SearchResult<Reservations>? reservationsResult;
  late SeminarsProvider seminarsProvider;
  late ReservationsProvider reservationsProvider;
  bool isLoadingSeminars = true;
  bool isLoadingReservations = true;
  List<String> reservationStates = ["pending","approved","rejected"];
  String? selectedState = "pending";
  String? seminarName;
  int? seminarId;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    seminarsProvider = context.read<SeminarsProvider>();
    reservationsProvider = context.read<ReservationsProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_){
    initForm(); 
   });
  }
  Future initForm() async{
  await _loadSeminars();
  setState(() {
    if(seminarResult?.result.isNotEmpty == true){
      seminarId = seminarResult?.result.first.seminarId;
      seminarName = seminarResult?.result.first.naslov;
      _loadReservations(state: selectedState);
      }
      });
  }
  Future<void> _loadSeminars() async{
    var filter = {
    };
    seminarResult = await seminarsProvider.get(filter: filter);
    setState(() {
      isLoadingSeminars = false;
    });
  }
  Future<void> _loadReservations({String? state}) async{
    var filter = {
      'SeminarId' : seminarId,
      'StateMachine' : state
    };
    reservationsResult = await reservationsProvider.get(filter: filter);
    setState(() {
      isLoadingReservations = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          isLoadingReservations ? Center(child: CircularProgressIndicator()) :_buildBody()
        ],
      ),
    );
  }

  Widget _buildHeader(){
    return ClipPath(
      clipper: Tcustomcurvededges(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue
          ),
          child: isLoadingSeminars ? Center(child: CircularProgressIndicator()):_buildHorizontalView(),
        ),
      ),
    );
  }

  Widget _buildHorizontalView(){
    return ListView.builder(
      itemCount: seminarResult?.result.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.only(top: 50.0,left: 8.0,right: 8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                seminarId = seminarResult?.result[index].seminarId;
                seminarName = seminarResult?.result[index].naslov;
                _loadReservations(state: selectedState);
              });
            },
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                  ),
                  child: Center(child: Text("${seminarResult?.result[index].naslov!.substring(0,1)}",style: 
                  GoogleFonts.poppins(fontSize: 20),)),
                ),
                Text("${seminarResult?.result[index].naslov!.substring(0,10 > seminarResult!.result[index].naslov!.length ? seminarResult!.result[index].naslov!.length : 10)}",style: 
                GoogleFonts.poppins(color: Colors.white),)
              ],
            ),
          ),
        );
    });
  }
  Widget _buildBody() {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.7,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  seminarName ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildDropdown()
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _buildVerticalView()),
      ],
    ),
  );
}
 Widget _buildVerticalView() {
  return ListView.builder(
    itemCount: reservationsResult?.result.length ?? 0,
    itemBuilder: (context, index) {
      final reservation = reservationsResult!.result[index];
      final user = reservation.korisnik;
      final nameSurname = "${user?.ime ?? ''} ${user?.prezime ?? ''}";
      final datum = reservation.datumRezervacije;
      final datumFormatted = datum != null
          ? "${datum.substring(0, datum.indexOf("T"))} ${datum.substring(datum.indexOf("T") + 1, datum.indexOf(":") + 3)}"
          : "";

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    nameSurname,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Text(
                    datumFormatted,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
                if (selectedState == "pending")
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async{
                          try {
                            MyDialogs.showInformationDialog(context, "Are you sure you want to approve this reservation? This action cannot be undone.", ()async{
                              try {
                                await reservationsProvider.allowReservation(reservationsResult?.result[index].rezervacijaId ?? 0);
                              await _loadReservations(state: selectedState);
                              } catch (e) {
                                MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
                              }
                            });
                          } catch (e) {
                            MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
                          }
                        },
                        icon: Icon(Icons.check, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () async{
                          try {
                            MyDialogs.showInformationDialog(context, "Are you sure you want to reject this reservation? This action cannot be undone.", ()async{
                            try {
                              await reservationsProvider.rejectReservation(reservationsResult?.result[index].rezervacijaId ?? 0);
                              await _loadReservations(state: selectedState);
                            } catch (e) {
                              MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
                            }
                          });
                          } catch (e) {
                            MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
                          }
                        },
                        icon: Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
 Widget _buildDropdown() {
  return Padding(
    padding: const EdgeInsets.only(right: 12.0),
    child: DropdownButton<String>(
      value: selectedState,
      hint: Text("Chose status", style: GoogleFonts.poppins()),
      style: GoogleFonts.poppins(color: Colors.black),
      underline: Container(height: 1, color: Colors.grey),
      items: reservationStates.map((String state) {
        return DropdownMenuItem<String>(
          value: state,
          child: Text(state, style: GoogleFonts.poppins()),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedState = newValue!;
          _loadReservations(state: selectedState);
        });
      },
    ),
  );
}
}