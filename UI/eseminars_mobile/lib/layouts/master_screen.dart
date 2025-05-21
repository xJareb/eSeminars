import 'package:eseminars_mobile/screens/notification_screen.dart';
import 'package:eseminars_mobile/screens/seminar_screen.dart';
import 'package:eseminars_mobile/screens/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    NotificationScreen(),
    SeminarScreen(),
    UserScreen()
  ];
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
        destinations: [
        NavigationDestination(icon: Icon(CupertinoIcons.home), label: 'Home',),
        NavigationDestination(icon: Icon(CupertinoIcons.book), label: 'Seminars'),
        NavigationDestination(icon: Icon(CupertinoIcons.person), label: 'Profile'),
      ]),
    );
  }
}