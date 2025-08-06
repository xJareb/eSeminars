import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/seminars.dart';
import 'package:flutter/material.dart';

class SeminarsInfoScreen extends StatefulWidget {
  Seminars? seminar;
  SeminarsInfoScreen({super.key, this.seminar});

  @override
  State<SeminarsInfoScreen> createState() => _SeminarsInfoScreenState();
}

class _SeminarsInfoScreenState extends State<SeminarsInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      'Seminar Info',
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSeminarInfo(),
            const SizedBox(height: 16),
            _buildDescription(),
            const SizedBox(height: 16),
            _buildSectionTitle("Organizer"),
            _buildOrganizerInfo(),
            const SizedBox(height: 16),
            _buildSectionTitle("Lecturer"),
            _buildLecturerInfo(),
          ],
        ),
      ),
      showBackButton: true,
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.seminar?.naslov ?? '',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          _formatDateTime(widget.seminar?.datumVrijeme),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || !dateTimeStr.contains("T")) return "";
    final parts = dateTimeStr.split("T");
    final time = parts[1].substring(0, 5);
    return "${parts[0]} $time";
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSeminarInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _infoRow(Icons.location_on, "Location", widget.seminar?.lokacija),
            _infoRow(Icons.chair, "Capacity", widget.seminar?.kapacitet.toString()),
            _infoRow(Icons.event_seat, "Reserved Seats", widget.seminar?.zauzeti.toString()),
            _infoRow(Icons.category, "Category", widget.seminar?.kategorija?.naziv),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Seminar Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(widget.seminar?.opis ?? ""),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizerInfo() {
    final user = widget.seminar?.korisnik;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _infoRow(Icons.person, "First Name", user?.ime),
            _infoRow(Icons.person_outline, "Last Name", user?.prezime),
            _infoRow(Icons.email, "Email", user?.email),
          ],
        ),
      ),
    );
  }

  Widget _buildLecturerInfo() {
    final lecturer = widget.seminar?.predavac;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.person, "First Name", lecturer?.ime),
            _infoRow(Icons.person_outline, "Last Name", lecturer?.prezime),
            _infoRow(Icons.email, "Email", lecturer?.email),
            const SizedBox(height: 8),
            const Text(
              "Biography:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(lecturer?.biografija ?? ""),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value ?? "-")),
        ],
      ),
    );
  }
}
