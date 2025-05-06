import 'package:eseminars_desktop/screens/categories_list_screen.dart';
import 'package:eseminars_desktop/screens/lecturers_list_screen.dart';
import 'package:eseminars_desktop/screens/notifications_list_screen.dart';
import 'package:eseminars_desktop/screens/reservation_list_screen.dart';
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
      appBar: AppBar(backgroundColor: Color.fromRGBO(255, 246, 230, 1),elevation: 4,title: Text(widget.title)),
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserListScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text("Reservations"),
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ReservationListScreen()));
                  } ,
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
                )
              ],
            ),
          )),
          Expanded(flex:4,child: Center(
              child: Container(
                constraints: BoxConstraints(maxHeight: 600,maxWidth: 900),
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
              
          )
          )
        ],
      ),
    );
  }
}