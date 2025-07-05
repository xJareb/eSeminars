import 'dart:math';

import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/reservations.dart';
import 'package:eseminars_mobile/models/savedSeminars.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/reservations_provider.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/providers/wishlist_provider.dart';
import 'package:eseminars_mobile/utils/TCustomCurvedEdges.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:eseminars_mobile/utils/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SeminarDetailsScreen extends StatefulWidget {
  Seminars? seminars;
  SeminarDetailsScreen({super.key,this.seminars});

  @override
  State<SeminarDetailsScreen> createState() => _SeminarDetailsScreenState();
}

class _SeminarDetailsScreenState extends State<SeminarDetailsScreen> {

  SearchResult<Seminars>? result = null;
  late SeminarsProvider provider;
  late String randomImagePath;
  bool isLoading = true;
  Color color = Color.fromRGBO(70, 70, 70, 1);
  late ReservationsProvider reservationsProvider;
  late WishlistProvider wishlistProvider;
  SearchResult<Savedseminars>? wishlistResult;

  final List<String> imagePaths = [
  "assets/images/OIP.jpg",
  "assets/images/Speaking2.jpg",
  "assets/images/52844500911_19813ef7cd_b.jpg",
  "assets/images/Universal-655-1520027541.jpg",
  ];
  Future<void> _loadSeminarsInfo() async{
    var filter = {
      'SeminarId' : widget.seminars?.seminarId,
      'KorisnikId' : UserSession.currentUser?.korisnikId
    };
    result = await provider.get(filter: filter);
    setState(() {
    });
  }
  Future<void> _loadWishlist() async{
    var filter = {
      'KorisnikId' : UserSession.currentUser?.korisnikId
    };
    wishlistResult = await wishlistProvider.get(filter: filter);

    setState(() {
      isLoading = false;
    });
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    provider = context.read<SeminarsProvider>();
    reservationsProvider = context.read<ReservationsProvider>();
    wishlistProvider = context.read<WishlistProvider>();
    final random = Random();
    randomImagePath = imagePaths[random.nextInt(imagePaths.length)];
    _loadWishlist();
    _loadSeminarsInfo();
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUpperContainer(),
            _buildSeminarDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpperContainer(){
    
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ClipPath(
        clipper: Tcustomcurvededges(),
        child: Stack(
          children: [Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(randomImagePath),
              fit: BoxFit.cover)
            ),
          ),
          Positioned(top: 10,child: IconButton(onPressed: (){
            Navigator.pop(context,true);
          }, icon: Icon(CupertinoIcons.arrow_left),style: IconButton.styleFrom(
            foregroundColor: Colors.white
          ),))
          ]
        ),
      ),
    );
  }
  Widget _buildSeminarDetails() {
  final fetchedSeminar = result?.result.first;
  final dateTime = widget?.seminars?.datumVrijeme;
  bool isSeminarExpired = false;

  if (widget.seminars?.datumVrijeme != null) {
  final seminarDateTime = DateTime.tryParse(widget.seminars!.datumVrijeme!);
  isSeminarExpired = seminarDateTime != null && seminarDateTime.isBefore(DateTime.now());
  }

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget?.seminars?.naslov ?? "",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Created by: ${fetchedSeminar?.korisnik?.ime ?? ''} ${fetchedSeminar?.korisnik?.prezime ?? ''}",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
        ),
        const SizedBox(height: 20),

        _buildRow(
          CupertinoIcons.time,
          "${dateTime!.substring(0, dateTime.indexOf("T"))} ${dateTime.substring(dateTime.indexOf("T") + 1, dateTime.indexOf(":") + 3)}",
          Icons.event_seat,
          "${widget?.seminars?.kapacitet ?? ''}",
        ),

        const SizedBox(height: 24),
        Text(
          "Description",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget?.seminars?.opis ?? '',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
        ),

        const SizedBox(height: 24),

        _buildRow(
          CupertinoIcons.pin,
          widget?.seminars?.lokacija ?? '',
          CupertinoIcons.person,
          "${fetchedSeminar?.predavac?.ime ?? ''} ${fetchedSeminar?.predavac?.prezime ?? ''}",
        ),

        const SizedBox(height: 24),
        Text(
          "Sponsors",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        fetchedSeminar?.sponzoriSeminaris == null || fetchedSeminar!.sponzoriSeminaris!.isEmpty ? 
        Text("No sponsors available",style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey)) : SizedBox(
          height: 100,
          child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: fetchedSeminar.sponzoriSeminaris!.length,
          itemBuilder: (context, index) {
          final sponsor = fetchedSeminar.sponzoriSeminaris![index].sponzor;
          return Text(sponsor?.naziv ?? "Unknown", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),);
          }
          )
        ),
        const SizedBox(height: 24,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          IconButton(onPressed: () async{
            try {
              final alreadySaved = wishlistResult?.result.any((s) => s.seminar?.seminarId == widget?.seminars?.seminarId) ?? false;
              if(!alreadySaved){
              final request = {
              'seminarId' : widget?.seminars?.seminarId,
              'korisnikId' : UserSession.currentUser?.korisnikId
              };
                          
              await wishlistProvider.insert(request);
              _loadWishlist();
              setState(() {
                            
              });
            }else{
              //TODO:: Remove seminar from wishlist
              final savedSeminar = wishlistResult?.result.firstWhere(
              (s) => s.seminar?.seminarId == widget?.seminars?.seminarId,);
              final savedSeminarId = savedSeminar?.sacuvaniSeminarId;
              try {
              MyDialogs.showInformationDialog(context, "Are you sure you want to remove this seminar from wishlist?", ()async{
              try {
              await wishlistProvider.softDelete(savedSeminarId!);
              await  _loadWishlist();
              setState(() {});
              await MyDialogs.showSuccessDialog(context, "Successfully removed sponsor from seminar");
              } catch (e) {
              await MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
              }
            });
           } catch (e) {
            await MyDialogs.showErrorDialog(context, "Something bad happened, please try again");
          }
            }
            } catch (e) {
              await MyDialogs.showErrorDialog(context, "Something bad happened, please try again");
            }
          }, icon: Icon(
            (wishlistResult?.result.any((s) => s.seminar?.seminarId == widget?.seminars?.seminarId) ?? false ) ? CupertinoIcons.heart_solid : CupertinoIcons.heart, color: 
            (wishlistResult?.result.any((s) => s.seminar?.seminarId == widget?.seminars?.seminarId) ?? false ) ? Colors.red:Colors.grey,
          )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(onPressed: isSeminarExpired ? null :  ()async{
              MyDialogs.showInformationDialog(context, "Are you sure you want to reserve a seat?", ()async{
                try {
                  final request = {
                    'seminarId' : widget?.seminars?.seminarId,
                    'korisnikId' : UserSession.currentUser?.korisnikId
                  };
                  await reservationsProvider.insert(request);
                  await MyDialogs.showSuccessDialog(context, "Successfully reserved! Please wait for the reservation approval");
                } catch (e) {
                  await MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception: ", ''));
                }
              });
            }, child: Text("Reserve"),style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),),
          )
        ],)
      ],
    ),
  );
}

Widget _buildRow(IconData icon1, String text1, IconData icon2, String text2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Row(
          children: [
            Icon(icon1, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text1,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      Flexible(
        child: Row(
          children: [
            Icon(icon2, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text2,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

}