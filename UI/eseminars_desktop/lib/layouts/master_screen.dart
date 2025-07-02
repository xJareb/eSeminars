import 'package:eseminars_desktop/main.dart';
import 'package:eseminars_desktop/screens/categories_list_screen.dart';
import 'package:eseminars_desktop/screens/feedbacks_list_screen.dart';
import 'package:eseminars_desktop/screens/lecturers_list_screen.dart';
import 'package:eseminars_desktop/screens/materials_screen.dart';
import 'package:eseminars_desktop/screens/notifications_list_screen.dart';
import 'package:eseminars_desktop/screens/reservation_list_screen.dart';
import 'package:eseminars_desktop/screens/seminars_list_screen.dart';
import 'package:eseminars_desktop/screens/sponsors_list_screen.dart';
import 'package:eseminars_desktop/screens/user_list_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen(this.title,this.child,{super.key});
  String title;
  Widget child;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromRGBO(255, 246, 230, 1),elevation: 4,title: Text(widget.title), leading: IconButton(onPressed: () async{
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()),(route) => false);
      }, icon: Icon(Icons.logout)),),
      body: Row(
        children: [
          Expanded(flex: 1,child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(212, 241, 243, 1),
            ),
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Users"),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserListScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text("Reservations"),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReservationListScreen()));
                  } ,
                ),
                ListTile(
                  leading: Icon(Icons.cast_for_education),
                  title: Text("Seminars"),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SeminarsListScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_pin),
                  title: Text("Lecturers"),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LecturersListScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.category),
                  title: Text("Categories"),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriesListScreen()));
                  },),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text("Notifications"),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsListScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text("Sponsors"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SponsorsListScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.feedback),
                  title: Text("Feedbacks"),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FeedbacksListScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.book_outlined),
                  title: Text("Materials"),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MaterialsScreen()));
                  },
                )
              ],
            ),
          )),
          Expanded(flex:4,child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow:[
                     BoxShadow(
                      color: Colors.black12,
                      blurRadius: 16,
                      spreadRadius: 4
                    )
                  ]
                  ),
                  padding: EdgeInsets.all(32),
                  child: widget.child,
                ),
                
            ),
          )
          )
        ],
      ),
    );
  }
}