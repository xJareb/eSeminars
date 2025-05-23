import 'dart:ffi';

import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/categories.dart';
import 'package:eseminars_mobile/models/savedSeminars.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/categories_provider.dart';
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


class SeminarScreen extends StatefulWidget {
  const SeminarScreen({super.key});

  @override
  State<SeminarScreen> createState() => _SeminarScreenState();
}

class _SeminarScreenState extends State<SeminarScreen> {

  SearchResult<Categories>? typeOfCategories;
  SearchResult<Seminars>? result = null;
  SearchResult<Savedseminars>? wishlistResult;
  late CategoriesProvider categoriesProvider;
  late SeminarsProvider provider;
  late ReservationsProvider reservationsProvider;
  late WishlistProvider wishlistProvider;
  bool isLoading=true;
  bool isCategoriesLoading = true;
  bool isSeminarsLoading = true;
  String? categoryName;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    categoriesProvider = context.read<CategoriesProvider>();
    provider = context.read<SeminarsProvider>();
    reservationsProvider = context.read<ReservationsProvider>();
    wishlistProvider = context.read<WishlistProvider>();

    _loadCategories();
    _loadSeminars();
    _loadWishlist();
  }
  Future<void> _loadCategories() async{
    typeOfCategories = await categoriesProvider.get();
    setState(() {
      isCategoriesLoading = false;
    });
  }
  Future<void> _loadSeminars() async{
    var filter = {
      'isActive': true,
      'KategorijaLIKE' : categoryName
    };
    result = await provider.get(filter: filter);
    setState(() {
      isSeminarsLoading = false;
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(
      children: [
        isCategoriesLoading ? const Center(child: CircularProgressIndicator()) : _buildUpperContainer(),
        isSeminarsLoading ? const Center(child: CircularProgressIndicator()) : _buildGridSeminars(),
      ],
    ),);
  }

  Widget _buildUpperContainer(){
    
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      
      child: ClipPath(
        clipper: Tcustomcurvededges(),
        child: Container(
          color: Colors.blue,
          child: Stack(
            children: [Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: _buildHorizontalListView(),
                ),
              ],
              
            ),
            Positioned(top: 10,left: 10,child: Text("Categories",style: GoogleFonts.poppins(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),))
            ]
          ),
          
        ),
      ),
    );
  }
  Widget _buildHorizontalListView(){
    return SizedBox(
      child: ListView.builder(
        itemCount: typeOfCategories?.result.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.only(top: 50.0,left: 8.0,right: 8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      categoryName=typeOfCategories?.result[index].naziv;
                    });
                    _loadSeminars();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                    child: Center(child: Text("${typeOfCategories?.result[index].naziv!.substring(0,1)}",style: GoogleFonts.poppins(fontSize: 20),)),
                  ),
                ),
                const SizedBox(height: 5,),
                Text('${typeOfCategories?.result[index].naziv!.substring(0,10 > typeOfCategories!.result[index].naziv!.length ? typeOfCategories?.result[index].naziv!.length : 10)}...' ?? "",style: GoogleFonts.poppins(color: Colors.white),)
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildGridSeminars(){
    return Column(
      children: [
        Text("${categoryName ?? ""}",style: GoogleFonts.poppins(fontSize: 20),),
        const SizedBox(height: 10,),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.64,
          width: MediaQuery.of(context).size.width * 0.95
          ,child: _buildGridBuilder())
      ],
    );
  }
  Widget _buildGridBuilder(){
    return GridView.builder(gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),itemCount: result?.result.length, itemBuilder: (context,index){
                  return Container(
                    alignment: Alignment.center,
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
                      children:[Column(
                        children: [
                          const SizedBox(height: 10,),
                          Text("${result?.result[index].naslov ?? ""}",style: GoogleFonts.poppins(fontSize: 26),),
                          const SizedBox(height: 10,),
                          Text("${result?.result[index].opis ?? ""}",style: GoogleFonts.poppins(fontSize: 18),),
                          const SizedBox(height: 20,),
                          Row(children: [
                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text("Seats: ${result?.result[index].kapacitet}",style: GoogleFonts.poppins()),
                            )),
                            Expanded(child: Text("${result?.result[index].datumVrijeme!.substring(0,result?.result[index].datumVrijeme!.indexOf("T"))}",style: GoogleFonts.poppins())),
                          ],)
                        ],
                      ),
                      Positioned(bottom: 0,child: IconButton(onPressed: () async{
                        try {

                          final alreadySaved = wishlistResult?.result.any((s) => s.seminar?.seminarId == result?.result[index].seminarId) ?? false;
                          if(!alreadySaved){
                            final request = {
                              'seminarId' : result?.result[index].seminarId,
                              'korisnikId' : UserSession.currentUser?.korisnikId
                            };
                          
                          await wishlistProvider.insert(request);
                          _loadWishlist();
                          setState(() {
                            
                          });
                          }else{
                            //TODO:: Remove seminar from wishlist
                          }
                          
                        } catch (e) {
                          MyDialogs.showErrorDialog(context, e.toString().replaceFirst('Exception: ', ''));
                        }
                      }, icon: Icon(
                        (wishlistResult?.result.any((s) => s.seminar?.seminarId == result?.result[index].seminarId) ?? false ) ? CupertinoIcons.heart_solid : CupertinoIcons.heart, color: 
                        (wishlistResult?.result.any((s) => s.seminar?.seminarId == result?.result[index].seminarId) ?? false ) ? Colors.red:Colors.grey,
                      ))),
                      Positioned(bottom: 3,right: 3,child: 
                      Container(decoration: 
                      BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))
                      ),
                      child: 
                      IconButton(onPressed: () async{
                        MyDialogs.showInformationDialog(context, "Are you sure you want to reserve a seat?", () async{
                          try {
                            final request = {
                              'seminarId' : result?.result[index].seminarId,
                              'korisnikId' : UserSession.currentUser?.korisnikId
                            };
                            await reservationsProvider.insert(request);
                            MyDialogs.showSuccessDialog(context, "Successfully reserved! Please wait for the reservation approval");
                            
                          } catch (e) {
                            MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception: ", ''));
                          }
                        });
                      }, icon: Icon(CupertinoIcons.plus),style: IconButton.styleFrom(
                        foregroundColor: Colors.white.withOpacity(0.8),
                        padding: EdgeInsets.all(4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap
                      ),),))
                      ]
                    ),
                  );
                });
  }
}