import 'package:flutter/material.dart';

class SeminarScreen extends StatefulWidget {
  const SeminarScreen({super.key});

  @override
  State<SeminarScreen> createState() => _SeminarScreenState();
}

class _SeminarScreenState extends State<SeminarScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Seminars"),);
  }
}