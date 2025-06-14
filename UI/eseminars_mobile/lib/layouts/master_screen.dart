import 'package:eseminars_mobile/screens/feedback_screen.dart';
import 'package:eseminars_mobile/screens/materials_screen.dart';
import 'package:eseminars_mobile/screens/notification_screen.dart';
import 'package:eseminars_mobile/screens/reservations_screen.dart';
import 'package:eseminars_mobile/screens/seminar_screen.dart';
import 'package:eseminars_mobile/screens/seminars_manage_screen.dart';
import 'package:eseminars_mobile/screens/user_screen.dart';
import 'package:eseminars_mobile/screens/wishlist_screen.dart';
import 'package:eseminars_mobile/utils/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;
  final String? roles = UserSession.currentUser?.ulogaNavigation?.naziv;
  late List<Widget> _screens;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(roles == "Korisnik"){
      _screens = [
        NotificationScreen(),
        SeminarScreen(),
        WishlistScreen(),
        UserScreen()
      ];
    }
    if(roles == "Organizator"){
      _screens = [
        SeminarsManageScreen(),
        ReservationsScreen(),
        FeedbackScreen(),
        MaterialsScreen(),
        UserScreen()
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations:  [
        if(roles == "Korisnik") ... [
        NavigationDestination(icon: Icon(CupertinoIcons.home), label: 'Home',),
        NavigationDestination(icon: Icon(CupertinoIcons.book), label: 'Seminars'),
        NavigationDestination(icon: Icon(CupertinoIcons.heart), label: 'Wishlist'),
        NavigationDestination(icon: Icon(CupertinoIcons.person), label: 'Profile'),
        ] else if(roles == "Organizator") ... [
        NavigationDestination(icon: Icon(CupertinoIcons.book), label: 'Seminars'),
        NavigationDestination(icon: Icon(Icons.check), label: "Reservations"),
        NavigationDestination(icon: Icon(CupertinoIcons.star), label: "Feedbacks"),
        NavigationDestination(icon: Icon(CupertinoIcons.pen), label: 'Materials'),
        NavigationDestination(icon: Icon(CupertinoIcons.person), label: 'Profile'),
        ]
      ]),
    );
  }
}