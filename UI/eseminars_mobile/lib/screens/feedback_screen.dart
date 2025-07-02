import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/feedbacks.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/feedback_provider.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/utils/TCustomCurvedEdges.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  SearchResult<Seminars>? seminarsResult;
  SearchResult<Feedbacks>? feedbackResult;
  late SeminarsProvider seminarsProvider;
  late FeedbackProvider feedbackProvider;
  bool isLoadingSeminars = true;
  bool isLoadingFeedbacks = true;
  String? seminarName;
  int? seminarId;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    seminarsProvider = context.read<SeminarsProvider>();
    feedbackProvider = context.read<FeedbackProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_){
    initForm();
   });
   
  }
  Future<void> _loadFeedbacks() async{
    var filter = {
      'SeminarId' : seminarId
    };
    feedbackResult = await feedbackProvider.get(filter: filter);
    setState(() {
      isLoadingFeedbacks = false;
    });
  }
  Future<void> _loadSeminars() async{
    var filter = {
      'isActive' : true
    };
    seminarsResult = await seminarsProvider.get(filter: filter);
    setState(() {
      isLoadingSeminars = false;
    });
  }
  Future initForm() async{
    await _loadSeminars();
    if(seminarsResult?.result.isNotEmpty == true){
      seminarName = seminarsResult?.result.first.naslov;
      seminarId = seminarsResult?.result.first.seminarId;
      _loadFeedbacks();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFeedbacks()
      ],
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
          child: isLoadingSeminars ? Center(child: CircularProgressIndicator(),) : _buildHorizontalView()
        ),
      ),
    );
  }
    Widget _buildHorizontalView(){
    return ListView.builder(
      itemCount: seminarsResult?.result.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.only(top: 50.0,left: 8.0,right: 8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                seminarName = seminarsResult?.result[index].naslov;
                seminarId = seminarsResult?.result[index].seminarId;
                _loadFeedbacks();
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
                  child: Center(child: Text("${seminarsResult?.result[index].naslov!.substring(0,1)}",style: 
                  GoogleFonts.poppins(fontSize: 20),)),
                ),
                Text("${seminarsResult?.result[index].naslov!.substring(0,10 > seminarsResult!.result[index].naslov!.length ? seminarsResult!.result[index].naslov!.length : 10)}",style: 
                GoogleFonts.poppins(color: Colors.white),)
              ],
            ),
          ),
        );
    });
  }
    Widget _buildFeedbacks(){
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Text("${seminarName}",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false,),
            const SizedBox(height: 8,),
            Expanded(child: isLoadingFeedbacks? Center(child: CircularProgressIndicator(),) : _buildVerticalContent())
          ],
        ),
      );
    }
    Widget _buildVerticalContent(){
      if(feedbackResult?.result.isEmpty == true){
        return Center(child: Text(textAlign: TextAlign.center,"There are currently no feedbacks available for this seminar.",style: 
        TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),),);
      }
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: feedbackResult?.result.length,
        itemBuilder: (context,index){
          final feedback = feedbackResult?.result[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(flex: 3,child: Text("${feedbackResult?.result[index].korisnik?.ime} ${feedbackResult?.result[index].korisnik?.prezime}")),
                    Expanded(flex: 3,child: buildStars(feedbackResult?.result[index].ocjena ?? 0)),
                    Expanded(flex: 1,child: IconButton(onPressed: () async{
                      try {
                              MyDialogs.showInformationDialog(context, "Are you sure you want to delete this feedback?", ()async{
                              try {
                              await feedbackProvider.softDelete(feedback?.dojamId ?? 0);
                              await MyDialogs.showSuccessDialog(context, "Successfully removed feedback");
                              await _loadFeedbacks();
                              } catch (e) {
                                await MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
                              }
                            });
                          } catch (e) {
                            await MyDialogs.showErrorDialog(context, "Something bad happened, please try again");
                          }
                    }, icon: Icon(Icons.close,),style: IconButton.styleFrom(
                      foregroundColor: Colors.red
                    ),)),
                  ],
                ),
              ),
            ),
          );
      });
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
  }
