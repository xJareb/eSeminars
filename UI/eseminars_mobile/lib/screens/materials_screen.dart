import 'package:eseminars_mobile/models/materials.dart';
import 'package:eseminars_mobile/models/search_result.dart';
import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/materials_provider.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/utils/TCustomCurvedEdges.dart';
import 'package:eseminars_mobile/utils/custom_dialogs.dart';
import 'package:eseminars_mobile/utils/custom_form_builder_text_field.dart';
import 'package:eseminars_mobile/utils/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  SearchResult<Seminars>? seminarsResult;
  SearchResult<Materials>? materialsResult;
  late SeminarsProvider seminarsProvider;
  late MaterialsProvider materialsProvider;
  bool isLoadingSeminars = true;
  bool isLoadingMaterials = true;
  String? seminarName;
  int? seminarId;
  final RegExp capitalLetter = RegExp(r'^[A-Z].*');
  final RegExp noNumber = RegExp(r'^[^0-9]*$');

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    seminarsProvider = context.read<SeminarsProvider>();
    materialsProvider = context.read<MaterialsProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_){
    initForm();
   });
  }
  Future initForm() async{
    await _loadSeminars();
    if(seminarsResult?.result.isNotEmpty == true){
      seminarName = seminarsResult?.result.first.naslov;
      seminarId = seminarsResult?.result.first.seminarId;
      setState(() {
        
      });
      _loadMaterials();
    }
  }

  Future<void> _loadSeminars() async{
    var filter = {
      'isActive' : true
    };
    seminarsResult = await seminarsProvider.get(filter: filter);
    setState(() {
      isLoadingSeminars = false;
    });
  }
  Future<void> _loadMaterials() async{
    var filter = {
      'SeminarId' : seminarId
    };
    materialsResult = await materialsProvider.get(filter: filter);
    setState(() {
      isLoadingMaterials = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildMaterialInfo(),
        isLoadingMaterials ? Center(child: CircularProgressIndicator(),):_buildSeminarMaterials()
      ],
    );
  }
  Widget _buildHeader(){
    return ClipPath(
      clipper: Tcustomcurvededges(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue
          ),
          child: isLoadingSeminars ? Center(child: CircularProgressIndicator(),) : _buildHorizontalView()
        ),
      ),
    );
  }
  Widget _buildHorizontalView(){
    return ListView.builder(
      itemCount: seminarsResult?.result.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.only(top: 50.0,left: 8.0,right: 8.0),
          child: GestureDetector(
            onTap: () async{
              setState(() {
                seminarName = seminarsResult?.result[index].naslov;
                seminarId = seminarsResult?.result[index].seminarId;
              });
              await _loadMaterials();
            },
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                  ),
                  child: Center(child: Text("${seminarsResult?.result[index].naslov!.substring(0,1)}",style: 
                  GoogleFonts.poppins(fontSize: 20),)),
                ),
                Text("${seminarsResult?.result[index].naslov!.substring(0,10 > seminarsResult!.result[index].naslov!.length ? seminarsResult!.result[index].naslov!.length : 10)}",style: 
                GoogleFonts.poppins(color: Colors.white),)
              ],
            ),
          ),
        );
    });
  }
  Widget _buildMaterialInfo(){
    return Row(children: [
      Expanded(flex: 6,child: Text(textAlign: TextAlign.center,"${seminarName}",style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w500),)),
      Expanded(flex: 1,child: IconButton(onPressed: () async{
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text("New material"),
            content: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFormDropDownMenu<Seminars>(
                  "Seminar", 
                  'seminarId', 
                  seminarsResult?.result,
                  (s) => s.naslov ?? '', 
                  (s) => s.seminarId,
                  icon: CupertinoIcons.book),
                  const SizedBox(height: 10,),
                  _buildFormControls('naziv', "Name", Icons.abc,extraValidators: [
                    FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
                    FormBuilderValidators.match(noNumber, errorText: "This field must contain only letters"),
                  ]),
                  const SizedBox(height: 10,),
                  _buildFormControls('putanja', "Link", Icons.link),
                  const SizedBox(height: 10,),
                  _buildFormButtons()
                ],
              )),
            ),
          );
        });
      }, icon: Icon(CupertinoIcons.add)))
    ],);
  }
  Widget _buildFormButtons(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel"),style: 
          ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[400],
            foregroundColor: Colors.black,
          ),),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: () async{
            if(_formKey.currentState?.saveAndValidate() == true){
              try {
                await materialsProvider.insert(_formKey.currentState?.value);
                Navigator.pop(context);
                 await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully added new material"),duration: Duration(seconds: 3),backgroundColor: Colors.green,));
                 await _loadMaterials();
              } catch (e) {
                Navigator.pop(context);
                await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst("Exception", '')),duration: Duration(seconds: 3),backgroundColor: Colors.red));
              }
            }
          }, child: Text("Add"))
        ],
      );
    }
    Widget _buildFormControls(String name, String label, IconData iconData,{List<FormFieldValidator<String>>? extraValidators}) {
    return CustomFormBuilderTextField(
    name: name,
    label: label,
    suffixIcon: Icon(iconData, color: Colors.grey[700]),
    filled: true,
    fillColor: Colors.grey[100],
    validators: [
      FormBuilderValidators.required(errorText: "This field is required"),
      ...?extraValidators
    ],
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
Widget _buildSeminarMaterials(){
  
    String infoOrgText = "There are currently no materials available for this seminar.";
    if (materialsResult!.result.isEmpty) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Text(
          infoOrgText,
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: materialsResult?.result.length,
              itemBuilder: (context,index){
                final material = materialsResult?.result[index];
                final rawPath = material?.putanja ?? "";
                final path = rawPath.startsWith('http') ? rawPath : 'https://$rawPath';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.abc),
                            Text(material?.naziv ?? "", style: 
                            GoogleFonts.poppins(fontSize: 16, 
                            fontWeight: FontWeight.w600),maxLines: 2,overflow: TextOverflow.ellipsis,softWrap: false),
                          ],
                        ),
                        IconButton(onPressed: () async{
                          try {
                              MyDialogs.showInformationDialog(context, "Are you sure you want to delete this material?", ()async{
                              try {
                              await materialsProvider.softDelete(material?.materijalId ?? 0);
                              await MyDialogs.showSuccessDialog(context, "Successfully removed material");
                              await _loadMaterials();
                              } catch (e) {
                                await MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
                              }
                            });
                          } catch (e) {
                            await MyDialogs.showErrorDialog(context, e.toString().replaceFirst("Exception:", ''));
                          }
                        }, icon: Icon(Icons.close),style: IconButton.styleFrom(
                          foregroundColor: Colors.red
                        ),)
                      ],
                    ),
                    const SizedBox(height: 4,),
                    InkWell(
                      onTap: () async {
                    final rawPath = material?.putanja ?? "";
                    final path = rawPath.startsWith('http') ? rawPath : 'https://$rawPath';
                  
                    if (await canLaunchUrlString(path)) {
                      await launchUrlString(path);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unable to open the : $path')),
                      );
                  }
                  },
                      child: Text(material?.putanja ?? "",style: GoogleFonts.poppins(
                      color: Colors.blue,
                      decoration: TextDecoration.underline),),
                    )
                    
                  ],
                );
            }),
          )
        ],
      ),
    );
  }
}