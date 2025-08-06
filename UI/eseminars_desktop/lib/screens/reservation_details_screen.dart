import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/models/seminars.dart';
import 'package:eseminars_desktop/providers/seminars_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservationDetailsScreen extends StatefulWidget {
  Korisnik? user;
  int? SeminarId;

  ReservationDetailsScreen({super.key, this.user, this.SeminarId});

  @override
  State<ReservationDetailsScreen> createState() => _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  SearchResult<Seminars>? seminarResult;
  late SeminarsProvider seminarsProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    seminarsProvider = context.read<SeminarsProvider>();
    _getSeminar();
  }

  Future<void> _getSeminar() async {
    var filter = {
      'SeminarId': widget.SeminarId,
    };
    seminarResult = await seminarsProvider.get(filter: filter);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Reservation details",
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seminarResult?.result[0].naslov ?? '',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildUserInfo(),
              const SizedBox(height: 20),
              const Text(
                "Seminar informations",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              _buildSeminarInfo(),
              const SizedBox(height: 20),
              _buildSponsors()
            ],
          ),
        ),
      ),showBackButton: true,
    );
  }

  Widget _buildUserInfo() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reserved by:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("${widget.user?.ime} ${widget.user?.prezime}"),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text("${widget.user?.email}"),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.cake, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text("${widget.user?.datumRodjenja?.split('T').first ?? ''}"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeminarInfo() {
    final seminar = seminarResult?.result[0];
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(seminar?.opis ?? ''),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(CupertinoIcons.time),
                const SizedBox(width: 8),
                Text(
                  "${seminar?.datumVrijeme?.split('T').first} ${seminar?.datumVrijeme?.split('T')[1].substring(0, 5)}",
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(CupertinoIcons.pin),
                const SizedBox(width: 8),
                Text(seminar?.lokacija ?? ''),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(CupertinoIcons.person),
                const SizedBox(width: 8),
                Text("${seminar?.predavac?.ime ?? ''} ${seminar?.predavac?.prezime ?? ''}"),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.school),
                const SizedBox(width: 8),
                Text(seminar?.kategorija?.naziv ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsors() {
    final sponzori = seminarResult?.result[0].sponzoriSeminaris;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(CupertinoIcons.money_dollar),
                SizedBox(width: 8),
                Text("Sponsors", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            if (sponzori == null || sponzori.isEmpty)
              const Text("No sponsors available."),
            ...?sponzori?.map((s) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  s.sponzor?.naziv ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
