import 'package:carousel_slider/carousel_slider.dart';
import 'package:eseminars_mobile/utils/TCustomCurvedEdges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildUpperPart(),
          const SizedBox(height: 15,),
          _buildCarouselNotifications()
        ],
      ),
    );
  }


  Widget _buildUpperPart(){
    return SizedBox(
      height: 
      MediaQuery.of(context).size.height * 0.4
    ,child: 
    ClipPath(
      clipper: Tcustomcurvededges(),
      child: Container(decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/notification_background.png'),
        fit: BoxFit.cover),
        
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 65,left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Good day for seminars",style: GoogleFonts.poppins(fontSize: 13,color: Colors.white),),
                  Text("Book your seminar",style: GoogleFonts.poppins(fontSize: 19,fontWeight: FontWeight.bold,color: Colors.white))
                ],)),
                Expanded(child: Container())
              ],
            ),
          ),
          const SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.only(top: 15,left: 10,right: 10),
            child: TextField(decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(CupertinoIcons.search),
              prefixIconColor: Colors.grey,
              hintText: "Search notification",
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
              )
              ),
              ),
          )
        ],
      ),
      ),
    )
    );
  }
  Widget _buildCarouselNotifications(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: CarouselSlider(
        options: CarouselOptions(height: 200.0,viewportFraction: 1.0),
        items: [1, 2, 3].map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            
            child: Column(
              children: [
                Text("Title"),
                Text("Content"),
                Text("DateTime")
              ],
            ),
          );
        },
      );
        }).toList(),
      ),
    );
  }
}