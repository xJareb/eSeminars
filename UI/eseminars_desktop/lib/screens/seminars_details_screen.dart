import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/utils/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SeminarsDetailsScreen extends StatefulWidget {
  const SeminarsDetailsScreen({super.key});

  @override
  State<SeminarsDetailsScreen> createState() => _SeminarsDetailsScreenState();
}

class _SeminarsDetailsScreenState extends State<SeminarsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreen('Seminar details', Column(
      children: [
        _buildForm(),
        const SizedBox(height: 20,),
        _buildControls()
      ],
    ));
  }

  Widget _buildForm(){
    return FormBuilder(child: 
    Column(
      children: [
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: 'naslov', label: "Seminar")),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'opis', label: "Description")),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: FormBuilderDateTimePicker(name: 'datumVrijeme',decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Date & time",suffix: Icon(Icons.date_range)),)),
            const SizedBox(width: 40,),
            Expanded(child: CustomFormBuilderTextField(name: 'lokacija', label: "Location")),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: CustomFormBuilderTextField(name: 'kapacitet', label: "Capacity")),
            const SizedBox(width: 40,),
            Expanded(child: FormBuilderDropdown(decoration: InputDecoration(labelText: "Lecturer",border: OutlineInputBorder()),name: 'predavacId', items: [])),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: FormBuilderDropdown(decoration: InputDecoration(labelText: "Category",border: OutlineInputBorder()),name: 'kategorijaId',items: [],)),
            const SizedBox(width: 40,),
            Expanded(child: Container())
          ],
        )
      ],
    ));
  }
  Widget _buildControls(){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel"),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: (){}, child: Text("Confirm"),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white
          ),)
        ],
      ),
    );
  }
}