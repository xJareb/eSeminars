import 'dart:ffi';

import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/categories.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/categories_provider.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/utils/TCustomCurvedEdges.dart';
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
  late CategoriesProvider categoriesProvider;
  late SeminarsProvider provider;
  bool isLoading=true;
  String? categoryName;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    categoriesProvider = context.read<CategoriesProvider>();
    provider = context.read<SeminarsProvider>();

    _loadCategories();
    _loadSeminars();
  }
  Future<void> _loadCategories() async{
    typeOfCategories = await categoriesProvider.get();
    setState(() {
      isLoading = false;
    });
  }
  Future<void> _loadSeminars() async{
    var filter = {
      'isActive':true,
      'KategorijaLIKE' : true
    };
    result = await provider.get(filter: filter);
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading? CircularProgressIndicator() : SingleChildScrollView(child: Column(
      children: [
        _buildUpperContainer(),
        _buildGridSeminars()
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
                      Positioned(bottom: 0,child: IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.heart))),
                      Positioned(bottom: 3,right: 3,child: 
                      Container(decoration: 
                      BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))
                      ),
                      child: 
                      IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.plus),style: IconButton.styleFrom(
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