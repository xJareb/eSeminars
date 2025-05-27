import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/logged_user.dart';
import 'package:eseminars_mobile/providers/korisnici_provider.dart';
import 'package:eseminars_mobile/utils/TCustomCurvedEdges.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:eseminars_mobile/utils/custom_form_builder_text_field.dart';
import 'package:eseminars_mobile/utils/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class ManageUserScreen extends StatefulWidget {
  LoggedUser? user;
  ManageUserScreen({super.key,this.user});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  Map<String,dynamic> _initialValue = {};
  bool isEnabled = false;
  late KorisniciProvider userProvider;
  bool isPassword = false;
  final RegExp capitalLetter = RegExp(r'^[A-Z].*');
  final RegExp noNumber = RegExp(r'^[^0-9]*$');

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    userProvider = context.read<KorisniciProvider>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'ime':widget.user?.ime,
      'prezime':widget.user?.prezime,
      'email':widget.user?.email,
      'datumRodjenja': widget?.user?.datumRodjenja != null ? DateTime.tryParse(widget.user!.datumRodjenja!) : null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildFormControls(),
            isPassword ? _buildFormPassword() : _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: ClipPath(
        clipper: Tcustomcurvededges(),
        child: Stack(
          children: [
            Container(
               width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              color: Colors.blue,
              child: Text("Your profile",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600
              ),),
            ),
            Positioned(top: 5,child: IconButton(onPressed: (){
              Navigator.pop(context,true);
            }, icon: Icon(CupertinoIcons.arrow_left,),
            style: IconButton.styleFrom(
            foregroundColor: Colors.white
            ),))
          ],
        ),
      ),
    );
  }
  Widget _buildForm(){
    return FormBuilder(key: _formKey,
    initialValue: _initialValue,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _buildInputField("Name", 'ime',isEnabled, extraValidators:[
            FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
            FormBuilderValidators.minLength(3, errorText: "This field must contain at least three characters."),
            FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),

          ] ),
          const SizedBox(height: 15,),
          _buildInputField("Surname", 'prezime',isEnabled, extraValidators: [
            FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
            FormBuilderValidators.minLength(3, errorText: "This field must contain at least three characters."),
            FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
          ]),
          const SizedBox(height: 15,),
          _buildInputField("Email", 'email',false),
          const SizedBox(height: 15,),
          _buildInputDateTime("Date of birth", 'datumRodjenja',isEnabled),
          const SizedBox(height: 15,),
          isEnabled ?  _buildControls() : Container()
        ],
      ),
    ));
  }

  Widget _buildInputField(String label, String name, bool isEnabled, {bool? obscureText,List<FormFieldValidator<String>>? extraValidators}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: GoogleFonts.poppins(
          color: Colors.grey[800],
          fontSize: 16,
          fontWeight: FontWeight.w500),),
        const SizedBox(height: 5,),
        CustomFormBuilderTextField(name: name, 
        obscureText: obscureText ?? false,
        filled: true,
        fillColor: Colors.grey[100],
        enabled: isEnabled,validators: [
          FormBuilderValidators.required(errorText: "This field is required"),
          ...?extraValidators
        ],)
      ],
    );
  }
  Widget _buildInputDateTime(String label, String name, bool isEnabled){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: GoogleFonts.poppins(
          color: Colors.grey[800],
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),),
        const SizedBox(height: 5,),
        FormBuilderDateTimePicker(name: name,
        enabled: isEnabled,
        inputType: InputType.date,
        lastDate: DateTime.now(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: Icon(CupertinoIcons.calendar),
          border: OutlineInputBorder(
          )
        ),)
      ],
    );
  }
  Widget _buildControls(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3
        ,child: 
        ElevatedButton(onPressed: (){
          _formKey.currentState?.reset();
          setState(() {
            isEnabled = false;
          });
        }, 
        child: Text("Cancel",style: GoogleFonts.poppins()),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black
        ),
        ),
        ),
        const SizedBox(width: 10,),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: ElevatedButton(onPressed: () async{
            if(_formKey.currentState?.saveAndValidate() == true){
              final formValues = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
              if (formValues != null) {
              formValues['datumRodjenja'] = formValues['datumRodjenja']?.toIso8601String();
              }
              try {
                var userId = UserSession.currentUser!.korisnikId;
                await userProvider.update(userId!,formValues);
                var updatedUser = UserSession.currentUser;
                if(updatedUser != null){
                  updatedUser.ime = formValues['ime'];
                  updatedUser.prezime = formValues['prezime'];
                  updatedUser.datumRodjenja = formValues['datumRodjenja'];
                };
                MyDialogs.showSuccessDialog(context, "User successfully edited");
                setState(() {
                  isEnabled = false;
                });
              } catch (e) {
                MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
              }
            }
          }, 
          child: Text("Confirm",style: GoogleFonts.poppins(),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white
          ),),
        ),
      ],
    );
  }
  Widget _buildFormControls(){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween
              ,children: [
              IconButton(onPressed: isPassword ? null : (){
                setState(() {
                  isPassword = true;
                  isEnabled = false;
                });
              }, icon: Icon(Icons.password)),
              IconButton(onPressed: isEnabled ? null : ()async{
                setState(() {
                  isEnabled = true;
                  isPassword = false;
                });
              }, icon: Icon(CupertinoIcons.pen))
            ],),
    );
  }
  Widget _buildFormPassword(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormBuilder(key: _formKey,
        child: Column(children: [
          Text("Change password",style: 
          GoogleFonts.poppins(fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800]
          ),),
          const SizedBox(height: 10,),
          _buildInputField('Password', "lozinka", true,obscureText: true,extraValidators: [
            FormBuilderValidators.minLength(7, errorText: "This field must contain at least 7 characters."),
            FormBuilderValidators.hasNumericChars(atLeast: 1, errorText: "This field must contain numeric characters."),
            FormBuilderValidators.hasUppercaseChars(atLeast: 1, errorText: "This field must contain an uppercase letter.")
          ]),
          const SizedBox(height: 15),
          _buildInputField('Confirm password', "lozinkaPotvrda", true,obscureText: true,extraValidators: [
            (val){
               final lozinka = _formKey.currentState?.fields['lozinka']?.value;
                if (val == null || val.isEmpty) {
                return "This field is required.";
              } else if (val != lozinka) {
                return "Passwords do not match.";
              }
              return null;
            }
          ]),
          const SizedBox(height: 15),
          _buildPasswordControls()
        ],),
      ),
    );
  }
  Widget _buildPasswordControls(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: ElevatedButton(onPressed: (){
            _formKey.currentState?.reset();
            setState(() {
              isPassword = false;
            });
          }, child: Text("Cancel"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black
          ),),
        ),
        const SizedBox(width: 10,),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: ElevatedButton(onPressed: () async{
            if(_formKey.currentState?.saveAndValidate() == true){
              final formValues = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
              if(formValues != null){
                formValues['ime'] = widget.user?.ime;
                formValues['prezime'] = widget.user?.prezime;
                formValues['email'] = widget.user?.email;
                formValues['datumRodjenja'] = formValues['datumRodjenja']?.toIso8601String();
              }
              try {
                var userId = UserSession.currentUser!.korisnikId;
                await userProvider.update(userId!,formValues);
                MyDialogs.showSuccessDialog(context, "Password successfully changed");
                setState(() {
                  isPassword = false;
                });
              } catch (e) {
                MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception: ", ''));
              }
            }
            print('Ok');
          }, child: Text("Confirm"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue
          ),),
        )
      ],
    );
  }
}