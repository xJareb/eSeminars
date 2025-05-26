import 'package:eseminars_mobile/models/korisnik.dart';
import 'package:eseminars_mobile/models/logged_user.dart';
import 'package:eseminars_mobile/utils/custom_form_builder_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailsScreen extends StatefulWidget {
  LoggedUser? user;
  UserDetailsScreen({super.key,this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {

  bool isEditable = false;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'ime' : widget.user?.ime,
      'prezime' : widget.user?.prezime,
      'email' : widget.user?.email,
      'datumRodjenja' : widget.user?.datumRodjenja != null ? DateTime.tryParse(widget.user!.datumRodjenja!) : null
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your profile"),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: isEditable ? Container() : IconButton(onPressed: (){
                setState(() {
                  isEditable = true;
                });
              }, icon: Icon(CupertinoIcons.pen)),
            ),
            _buildForm(),
            isEditable ? _buildControls() : Container()
          ],
        ),
      ),
    );
  }
  Widget _buildForm() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: FormBuilder(key: _formKey, initialValue: _initialValue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800]
                      ),
                    ),
                    const SizedBox(height: 6),
                    FormBuilderTextField(
                      enabled: isEditable,
                      name: 'ime',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(),
                        
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Surname",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800]
                      ),
                    ),
                    const SizedBox(height: 6),
                    FormBuilderTextField(
                      name: 'prezime',
                      enabled: isEditable,
                      decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800]
                ),
              ),
              const SizedBox(height: 6),
              FormBuilderTextField(
                name: 'email',
                enabled: isEditable,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date of birth",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800]
                ),
              ),
              const SizedBox(height: 6),
              FormBuilderDateTimePicker(
                name: 'datumRodjenja',
                enabled: isEditable,
                inputType: InputType.date,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(CupertinoIcons.calendar),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
  Widget _buildControls(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(onPressed: (){
          setState(() {
            isEditable = false;
          });
          _formKey.currentState?.reset();
        }, child: Text("Cancel"),style: 
        ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black
        ),)),
        const SizedBox(width: 10,),
        SizedBox(width: MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(onPressed: (){
          if(_formKey.currentState?.saveAndValidate() == true){
            print(_formKey.currentState?.value);
          }
        }, child: Text("Confirm"),style:
        ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white
        ))),
      ],
    );
  }

}