import 'dart:math';

import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/feedback_provider.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/utils/TCustomCurvedEdges.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:eseminars_mobile/utils/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SeminarsMaterialsFreedbacks extends StatefulWidget {
  Seminars? seminar;
  SeminarsMaterialsFreedbacks({super.key,this.seminar});

  @override
  State<SeminarsMaterialsFreedbacks> createState() => _SeminarsMaterialsFreedbacksState();
}

class _SeminarsMaterialsFreedbacksState extends State<SeminarsMaterialsFreedbacks> {

  SearchResult<Seminars>? result = null;
  late SeminarsProvider seminarsProvider;
  late FeedbackProvider feedbackProvider;
  bool isDetails = true;
  late int rating;
  bool isMaterials = false;
  late String randomImagePath;
  final List<String> imagePaths = [
  "assets/images/OIP.jpg",
  "assets/images/Speaking2.jpg",
  "assets/images/52844500911_19813ef7cd_b.jpg",
  "assets/images/Universal-655-1520027541.jpg",
  ];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final random = Random();
    randomImagePath = imagePaths[random.nextInt(imagePaths.length)];
    seminarsProvider = context.read<SeminarsProvider>();
    feedbackProvider = context.read<FeedbackProvider>();
    rating = 0;
    _loadSeminarsInfo();
  }
  Future<void> _loadSeminarsInfo() async{
    var filter = {
      'SeminarId' : widget.seminar?.seminarId,
      'includeMaterials' : true,
      'KorisnikId' : UserSession.currentUser?.korisnikId
    };
    result = await seminarsProvider.get(filter: filter);
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUpperContainer(),
            _buildControls(),
            isDetails ? _buildSeminarDetails() : Container(),
            isMaterials? _buildSeminarMaterials() :Container()

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
          children: [
            Container(
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
  Widget _buildControls(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: (){
          setState(() {
            isDetails = true;
            isMaterials = false;
          });
        }, child: Text("Details"),style: isDetails ? ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white
        ) : null),
        const SizedBox(width: 10,),
        ElevatedButton(onPressed:  (){
          setState(() {
            isDetails = false;
            isMaterials = true;
          });
        }, child: Text("Materials"),style: isMaterials ? ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white
        ):null),
        const SizedBox(width: 10,),
        ElevatedButton(
  onPressed: () async {
    setState(() {
            isDetails = true;
            isMaterials = false;
          });
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Your feedback"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Please rate your experience:"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      rating = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async{
                    try {
                      var request = {
                        'seminarId': widget.seminar?.seminarId,
                        'korisnikId' : UserSession.currentUser?.korisnikId,
                        'ocjena' : rating
                      };
                      await feedbackProvider.insert(request);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Feedback successfully submitted"),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 4),
                      ),
                    );
                      _loadSeminarsInfo();
                      setState(){
                      }
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString().replaceFirst("Exception:", '')),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 4),
                      ),
                    );
                    }
                  },
                  child: Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  },
  child: Text("Feedback"),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue[600],
    foregroundColor: Colors.white,
  ),
),
      ],
    );
  }
  Color color = Color.fromRGBO(70, 70, 70, 1);
  Widget _buildSeminarDetails(){
    final fetchedSeminar = result?.result.first;
    final dateTime = widget?.seminar?.datumVrijeme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget?.seminar?.naslov ?? "",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),),
          const SizedBox(height: 8),
          Text("Created by:  ${fetchedSeminar?.korisnik?.ime ?? ''} ${fetchedSeminar?.korisnik?.prezime ?? ""}",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),),
          const SizedBox(height: 20),
          _buildRow(
          CupertinoIcons.time,
          "${dateTime!.substring(0, dateTime.indexOf("T"))} ${dateTime.substring(dateTime.indexOf("T") + 1, dateTime.indexOf(":") + 3)}",
          Icons.event_seat,
          "${widget?.seminar?.kapacitet ?? ''}",
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
          widget?.seminar?.opis ?? '',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
        ),
        const SizedBox(height: 24),
         _buildRow(
          CupertinoIcons.pin,
          widget?.seminar?.lokacija ?? '',
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
        ],
      ),
    );
  }
  Widget _buildSeminarMaterials(){
    final fetchedSeminar = result?.result.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Materials: ",style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),),
          fetchedSeminar?.materijalis == null || fetchedSeminar!.materijalis!.isEmpty ? 
          Text("To access the seminar materials, please share your feedback first. Your opinion helps us improve future sessions.",
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey)) : SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: fetchedSeminar.materijalis!.length,
              itemBuilder: (context,index){
                final material = fetchedSeminar.materijalis![index];
                final rawPath = material.putanja ?? "";
                final path = rawPath.startsWith('http') ? rawPath : 'https://$rawPath';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(material.naziv ?? "", style: 
                    GoogleFonts.poppins(fontSize: 16, 
                    fontWeight: FontWeight.w600),),
                    const SizedBox(height: 4,),
                    InkWell(
                      onTap: () async {
                    final rawPath = material.putanja ?? "";
                    final path = rawPath.startsWith('http') ? rawPath : 'https://$rawPath';
                  
                    if (await canLaunchUrlString(path)) {
                      await launchUrlString(path);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unable to open the : $path')),
                      );
                  }
                  },
                      child: Text(material.putanja ?? "",style: GoogleFonts.poppins(
                      color: Colors.blue,
                      decoration: TextDecoration.underline),),
                    )
                    
                  ],
                );
            }),
          )
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