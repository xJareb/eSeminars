import 'package:eseminars_mobile/main.dart';
import 'package:eseminars_mobile/models/korisnik.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/providers/auth_provider.dart';
import 'package:eseminars_mobile/providers/korisnici_provider.dart';
import 'package:eseminars_mobile/screens/manage_user_screen.dart';
import 'package:eseminars_mobile/screens/seminars_history_screen.dart';
import 'package:eseminars_mobile/screens/sponsors_screen.dart';
import 'package:eseminars_mobile/utils/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  @override
  Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 25),
          _buildUserInfo(),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
           child: Padding(
             padding: const EdgeInsets.only(left:8.0),
             child: Text(
              "Profile",
              style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
                 ),
               ),
           ),
),
          const SizedBox(height: 20),
          _buildUserManage(
            "Manage user",
            CupertinoIcons.circle,
            Color.fromRGBO(203, 113, 59, 1),
            Color.fromRGBO(255, 240, 229, 1),
            () async{
              var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageUserScreen(user: UserSession.currentUser,)));
              if(result == true){
                setState(() {
                  
                });
              }
          }),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text("Activity",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]
              ),),
            ),
          ),
          const SizedBox(height: 20,),
          _buildUserManage(
            "Seminars history", 
            CupertinoIcons.book, 
            const Color.fromRGBO(92,72, 208, 1),
             const Color.fromRGBO(237,234, 255, 1), 
             () async{
              var result = Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeminarsHistoryScreen()));
             }),
            const SizedBox(height: 15,),
            if(UserSession.currentUser?.ulogaNavigation?.naziv == "Organizator") ... [
              _buildUserManage("Sponsors", 
              CupertinoIcons.money_dollar, 
              const Color.fromRGBO(34, 139, 34, 1), 
              const Color.fromRGBO(200, 255, 200, 1), 
              () async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SponsorsScreen()));
              })
            ]
        ],
      ),
    ),
  );
}

  Widget _buildUserInfo() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.person,
              size: 56,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${UserSession.currentUser?.ime}",
                style: GoogleFonts.poppins(
                  color: Colors.grey[800],
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false,
              ),
              const SizedBox(height: 4),
              Text(
                UserSession.currentUser?.ulogaNavigation?.naziv == "Korisnik" ? "Active user" : "Active organizer",
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
      ElevatedButton(
        onPressed: () async{
          AuthProvider.email = "";
          AuthProvider.password = "";

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()),(route)=> false);
        },
        child: Text("Sign Out"),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: Colors.red[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ],
  );
}
  Widget _buildUserManage(String text, IconData icon, Color iconColor, Color iconColorBackground, VoidCallback? onPressed) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          offset: Offset(0, 2),
        )
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColorBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
        IconButton(
          onPressed: onPressed ?? () {},
          icon: Icon(CupertinoIcons.right_chevron, color: Colors.grey[600]),
        ),
      ],
    ),
  );
}
Widget _buildFormDropDownMenu<T>(
  String? hintText,
  String name,
  List<T>? items,
  String Function(T) labelBuilder,
  dynamic Function(T) valueBuilder, {
  IconData? icon,
}) {
  return FormBuilderDropdown(
    name: name,
    decoration: InputDecoration(
      labelText: hintText,
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey[100],
      suffixIcon: icon != null ? Icon(icon, color: Colors.grey[700]) : null,
    ),
    items: items?.map((item) {
          return DropdownMenuItem(
            value: valueBuilder(item),
            child: Text(labelBuilder(item)),
          );
        }).toList() ??
        [],validator: FormBuilderValidators.required(errorText: "This field is required"),
  );
}
}