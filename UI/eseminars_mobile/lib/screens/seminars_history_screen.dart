import 'dart:math';

import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/screens/seminars_manage_screen.dart';
import 'package:eseminars_mobile/screens/seminars_materials_freedbacks.dart';
import 'package:eseminars_mobile/utils/TCustomCurvedEdges.dart';
import 'package:eseminars_mobile/utils/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SeminarsHistoryScreen extends StatefulWidget {
  const SeminarsHistoryScreen({super.key});

  @override
  State<SeminarsHistoryScreen> createState() => _SeminarsHistoryScreenState();
}

class _SeminarsHistoryScreenState extends State<SeminarsHistoryScreen> {

  SearchResult<Seminars>? result = null;
  late SeminarsProvider provider;
  late String randomImagePath;
  bool isLoading = true;
  final List<String> imagePaths = [
  "assets/images/OIP.jpg",
  "assets/images/Speaking2.jpg",
  "assets/images/52844500911_19813ef7cd_b.jpg",
  "assets/images/Universal-655-1520027541.jpg",
  ];
  Future<void> _loadHistorySeminarsOrg()async{
    var filter = {
      'isActive' : true,
      'OrganizatorId' : UserSession.currentUser?.korisnikId,
      'dateTime' : false
    };
    result = await provider.get(filter: filter);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadHistorySeminars() async{
    var filter = {
      'isHistory' : true,
      'KorisnikId' : UserSession.currentUser?.korisnikId
    };
    result = await provider.get(filter: filter);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final random = Random();
    randomImagePath = imagePaths[random.nextInt(imagePaths.length)];
    provider = context.read<SeminarsProvider>();
    UserSession.currentUser?.ulogaNavigation?.naziv == "Korisnik" ? _loadHistorySeminars() : _loadHistorySeminarsOrg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10,),
          _buildHeader(),
          const SizedBox(height: 20,),
          result?.result.isEmpty == true ? Center(child: Text("Your seminar history is currently empty.",style: TextStyle(fontSize: 16, color: Colors.grey[700]),textAlign: TextAlign.center,),) : SizedBox.shrink(),
          isLoading ? CircularProgressIndicator() : _buildHistorySeminars()
        ],
      )
    );
  }
  
  Widget _buildHeader(){
    return Row(
      children: [
      IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(CupertinoIcons.arrow_left)),
      const SizedBox(width: 10,),
        Text("History of seminars",
        style: GoogleFonts.poppins(
          color: Colors.grey[800],
          fontSize: 30,
          fontWeight: FontWeight.w500),),
      
    ],);
  }
  Widget _buildHistorySeminars(){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: result?.result.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(2, 3)
                    )
                  ]
                ),child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2,left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${result?.result[index].naslov}",style: GoogleFonts.poppins(fontSize: 26),maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false,),
                          Text("${result?.result[index].opis}",style: GoogleFonts.poppins(fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false),
                        ],
                      ),
                    ),
                    Positioned(bottom: 20,left: 10,child: Text("${result?.result[index].datumVrijeme!.substring(0,result?.result[index].datumVrijeme!.indexOf("T"))}")),
                    Positioned(bottom: 10,right: 10,child: ElevatedButton(onPressed: () async{
                     UserSession.currentUser?.ulogaNavigation?.naziv == "Korisnik" ?
                     await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeminarsMaterialsFreedbacks(seminar: result?.result[index],))) :
                     await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeminarsMaterialsFreedbacks(seminar: result?.result[index])));
                    }, child: Text("Details")))
                  ],

                ),
            ),
          );
      }),
    );
  }
}