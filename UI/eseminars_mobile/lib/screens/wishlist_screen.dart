import 'dart:math';

import 'package:eseminars_mobile/layouts/master_screen.dart';
import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/savedSeminars.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/providers/wishlist_provider.dart';
import 'package:eseminars_mobile/screens/seminar_details_screen.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:eseminars_mobile/utils/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  SearchResult<Savedseminars>? result = null;
  late WishlistProvider wishlistProvider;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    wishlistProvider = context.read<WishlistProvider>();

    _loadWishlist();
  }
  Future<void> _loadWishlist() async{
    var filter = {
      'KorisnikId' : UserSession.currentUser?.korisnikId
    };
     result = await wishlistProvider.get(filter: filter);
     setState(() {
       isLoading = false;
     });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading ? Center(child: const CircularProgressIndicator()) : Column(
        children: [
          const SizedBox(height: 30,),
          result?.result.isEmpty ?? true ? Center(
            child: Text("Your seminar wishlist is currently empty.",style: TextStyle(fontSize: 16, color: Colors.grey[700]),textAlign: TextAlign.center,
                ),
          )
  : _buildWishList(),
          
        ],
      ),
    );
  }
  Widget _buildWishList(){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: ListView.builder(
        itemCount: result?.result.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,index){
          final wishlist = result?.result[index];
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
                      Text(() {
    final naslov = result?.result[index].seminar?.naslov;
    if (naslov == null) return "";
    final maxLength = 20;
    if (naslov.length <= maxLength) return naslov;
    return naslov.substring(0, maxLength) + "...";}(),
  style: GoogleFonts.poppins(fontSize: 26),
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  softWrap: false,
),
                      Text("${result?.result[index].seminar?.opis}",style: GoogleFonts.poppins(fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false),
                    ],
                                    ),
                  ),
                Positioned(bottom: 20,left: 10,child: Text("${result?.result[index].seminar?.datumVrijeme!.substring(0,result?.result[index].seminar?.datumVrijeme!.indexOf("T"))}")),
                Positioned(bottom: 10,right: 10,child: ElevatedButton(onPressed: () async{
                  await Navigator.of(context).push(MaterialPageRoute(
  builder: (context) => SeminarDetailsScreen(seminars: result?.result[index].seminar),
)).then((value) async {
  await _loadWishlist();
});
                }, child: Text("Details"))),
                Positioned(top: 2,right: 10,child: IconButton(onPressed: () async{
                  try {
                              MyDialogs.showInformationDialog(context, "Are you sure you want to remove this seminar from wishlist?", ()async{
                              try {
                              await wishlistProvider.softDelete(wishlist?.sacuvaniSeminarId ?? 0);
                              await MyDialogs.showSuccessDialog(context, "Successfully removed seminar from wishlist");
                              await _loadWishlist();
                              } catch (e) {
                                await MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
                              }
                            });
                          } catch (e) {
                            await MyDialogs.showErrorDialog(context, "Something bad happened, please try again");
                          }
                }, icon: Icon(Icons.close)))
                ]
              ),
            ),
          );
      }),
    );
  }
}