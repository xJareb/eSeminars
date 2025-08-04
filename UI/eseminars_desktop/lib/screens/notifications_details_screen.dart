import 'package:eseminars_desktop/layouts/master_screen.dart';
import 'package:eseminars_desktop/models/notifications.dart';
import 'package:eseminars_desktop/providers/korisnici_provider.dart';
import 'package:eseminars_desktop/providers/notifications_provider.dart';
import 'package:eseminars_desktop/utils/custom_dialogs.dart';
import 'package:eseminars_desktop/utils/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class NotificationsDetailsScreen extends StatefulWidget {
  Notifications? notifications;
  NotificationsDetailsScreen({super.key,this.notifications});

  @override
  State<NotificationsDetailsScreen> createState() => _NotificationsDetailsScreenState();
}

class _NotificationsDetailsScreenState extends State<NotificationsDetailsScreen> {

  Map<String, dynamic> _initialValue = {};
  final _formKey = GlobalKey<FormBuilderState>();
  late NotificationsProvider provider;
  final RegExp capitalLetter = RegExp(r'^[A-Z].*');
  final RegExp noNumber = RegExp(r'^[^0-9]*$');

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    provider = context.read<NotificationsProvider>();
  }
  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naslov' : widget.notifications?.naslov,
      'sadrzaj' : widget.notifications?.sadrzaj,
    };
  }
  @override
  Widget build(BuildContext context) {
    return MasterScreen('Notification details', Column(
      children: [
        _buildForm(),
        const SizedBox(height: 20,),
        _buildControls()
      ],
    ));
  }
  Widget _buildForm(){
  return FormBuilder(
    key: _formKey,
    initialValue: _initialValue,
    child: Column(
      children: [
        CustomFormBuilderTextField(
          name: 'naslov',
          label: "Title",
          validators: [
            FormBuilderValidators.required(errorText: "This field is required."),
            FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
          ],
        ),
        const SizedBox(height: 20),
        CustomFormBuilderTextField(
          name: 'sadrzaj',
          label: "Content",
          maxLines: 5,
          validators: [
            FormBuilderValidators.required(errorText: "This field is required."),
            FormBuilderValidators.match(capitalLetter, errorText: "This field must start with a capital letter."),
          ],
        ),
      ],
    ),
  );
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
            foregroundColor: Colors.white
          ),),
          const SizedBox(width: 10,),
          ElevatedButton(onPressed: () async{
            if(_formKey.currentState?.saveAndValidate() == true){
              if(widget.notifications == null){
                try {
                  await provider.insert(_formKey.currentState?.value);
                  _formKey.currentState?.reset();
                  showSuccessMessage(context, "Notification successfully addded");
                  Navigator.pop(context,true);
                } catch (e) {
                  showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
                }
              }
              else{
                try {
                  await provider.update(widget.notifications!.obavijestId!,_formKey.currentState?.value);
                _formKey.currentState?.reset();
                showSuccessMessage(context, "Notification successfully edited");
                Navigator.pop(context,true);
                } catch (e) {
                  showErrorMessage(context, e.toString().replaceFirst("Exception: ", ''));
                }
                
              }
            }
          }, child: Text("Dodaj"), style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white
          ),
          )
        ],
      ),
    );
  }
}