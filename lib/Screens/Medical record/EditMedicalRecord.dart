import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/MedicalRecord/AddMedicalRecordController.dart';
import '../../Controllers/MedicalRecord/EditMedicalRecordController.dart';
import '../../Services/Api.dart';

class EditMedicalRecordScreen extends StatefulWidget {
  const EditMedicalRecordScreen({super.key});

  @override
  _EditMedicalRecordScreenState createState() => _EditMedicalRecordScreenState();
}

class _EditMedicalRecordScreenState extends State<EditMedicalRecordScreen> {
  final _editMedicalRecordController = Get.put(EditMedicalRecordController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        flexibleSpace: kAppBarColor,

        title:  Text('Edit Medical Record  (#${_editMedicalRecordController.medicalRecord.value.id})' ,style: TextStyle(fontSize: 18),),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _editMedicalRecordController.isLoading.value
                ? null
                : () async {
              _editMedicalRecordController.submitForm();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FormBuilder(
            key: _editMedicalRecordController.formKey.value,
            child: Column(
              children: [
                TextFormField(
                  enabled: false,
                  initialValue: "${_editMedicalRecordController.patient.value.firstName} ${_editMedicalRecordController.patient.value.lastName }",
                  decoration: inputDecoration('Patient', Icons.person),
                ),
                const SizedBox(height: 15),
                FormBuilderDateTimePicker(
                  name: 'patient_entry_date',
                  inputType: InputType.date,
                  initialValue: DateTime.now(),
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: inputDecoration(
                      'Date of Visit *', Icons.calendar_today),
                  validator: FormBuilderValidators.required(
                      errorText: 'date of visit is required'),
                ),
                const SizedBox(height: 15),

                FormBuilderTextField(
                  name: 'medical_specialty',
                  initialValue: "infectious diseases",
                  enabled: false,
                  decoration: inputDecoration(
                      'Medical Specialty *', Icons.local_hospital),
                ),
                const SizedBox(height: 15),
                FormBuilderTextField(
                  name: 'condition_description',
                  initialValue: _editMedicalRecordController.medicalRecord.value.conditionDescription ,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 6,
                  decoration: inputDecoration(
                      'Condition Description *', Icons.description),
                  validator: FormBuilderValidators.required(
                      errorText: 'condition description is required'),
                ),
                const SizedBox(height: 15),
                FormBuilderTextField(
                  name: 'standard_treatment',
                  initialValue: _editMedicalRecordController.medicalRecord.value.standardTreatment,

                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 6,
                  decoration: inputDecoration(
                      'Standard Treatment *', Icons.medical_services),
                  validator: FormBuilderValidators.required(
                      errorText: 'standard treatment is required'),
                ),
                const SizedBox(height: 15),
                FormBuilderTextField(
                  name: 'state_upon_enter',
                  initialValue: _editMedicalRecordController.medicalRecord.value.stateUponEnter,
                  decoration: inputDecoration('State upon Enter *',
                      Icons.airline_seat_individual_suite),
                  validator: FormBuilderValidators.required(
                      errorText: 'state upon enter is required'),
                ),
                const SizedBox(height: 15),
                FormBuilderTextField(
                  name: 'bed_number',
                  initialValue: _editMedicalRecordController.medicalRecord.value.bedNumber.toString(),
                  decoration: inputDecoration('Bed Number', Icons.king_bed),
                  validator: FormBuilderValidators.numeric(
                      errorText: 'bed number should contain numbers only'),
                ),
                const SizedBox(height: 5.0),


                const SizedBox(height: 10.0),
                const Center(child: Text("Leaving informations" ,style: TextStyle(fontSize: 16 , color: Colors.redAccent),),),
                const SizedBox(height: 15.0),

                FormBuilderTextField(
                  name: 'state_upon_exit',
                  initialValue: _editMedicalRecordController.medicalRecord.value.stateUponExit,
                  decoration: inputDecoration('State upon exit', Icons.exit_to_app_outlined),
                ),
                const SizedBox(height: 10.0),
                FormBuilderDateTimePicker(
                  name: 'patient_leaving_date',
                  inputType: InputType.date,
                  format: DateFormat('yyyy-MM-dd'),
                  initialValue: _editMedicalRecordController.medicalRecord.value.patientLeavingDate,
                  decoration: inputDecoration('Leaving date', Icons.calendar_month),

                ),

              ],
            ),
          ),
        ),
      ),
    ));
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon , color: Colors.grey[700],),
      labelText: label,
      labelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.grey[700],
      ),
      // filled: true,
      fillColor: Colors.grey[200],
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[400]!,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.blue,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
