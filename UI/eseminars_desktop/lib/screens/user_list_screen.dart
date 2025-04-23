import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen("Users", Placeholder());
  }
}