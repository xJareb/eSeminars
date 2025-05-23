import 'package:eseminars_mobile/layouts/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30,),
          _buildWishList()
        ],
      ),
    );
  }
  Widget _buildWishList(){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: ListView.builder(
        itemCount: 13,
        scrollDirection: Axis.vertical,
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
              ),
              child: Stack(
                children:[
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0,left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tittle",style: GoogleFonts.poppins(fontSize: 26),),
                      Text("Description",style: GoogleFonts.poppins(fontSize: 18)),
                    ],
                                    ),
                  ),
                Positioned(bottom: 20,left: 10,child: Text("Date and time")),
                Positioned(bottom: 10,right: 10,child: ElevatedButton(onPressed: (){}, child: Text("Details"))),
                Positioned(top: 2,right: 10,child: IconButton(onPressed: (){}, icon: Icon(Icons.close)))
                ]
              ),
            ),
          );
      }),
    );
  }
}