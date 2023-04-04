import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/MedicalRecord/AddMedicalRecordController.dart';
import '../../Services/Api.dart';

class AddMedicalRecordScreen extends StatefulWidget {
  @override
  _AddMedicalRecordScreenState createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends State<AddMedicalRecordScreen> {
  final _addMedicalRecordController = Get.put(AddMedicalRecordController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text('Add new Medical Record'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _addMedicalRecordController.isLoading.value
                    ? null
                    : () async {
                        _addMedicalRecordController.submitForm();
                      },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FormBuilder(
                key: _addMedicalRecordController.formKey.value,
                child: Column(
                  children: [
                    TextFormField(
                      enabled: false,
                      initialValue: "${_addMedicalRecordController.patient.value.firstName} ${_addMedicalRecordController.patient.value.lastName }",
                      decoration: inputDecoration('Patient', Icons.person),
                    ),
                    SizedBox(height: 15),
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
                    SizedBox(height: 15),

                    FormBuilderTextField(
                      name: 'medical_specialty',
                      initialValue: "infectious diseases",
                      enabled: false,
                      decoration: inputDecoration(
                          'Medical Specialty *', Icons.local_hospital),
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      name: 'condition_description',
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 6,
                      decoration: inputDecoration(
                          'Condition Description *', Icons.description),
                      validator: FormBuilderValidators.required(
                          errorText: 'condition description is required'),
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      name: 'standard_treatment',
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 6,
                      decoration: inputDecoration(
                          'Standard Treatment *', Icons.medical_services),
                      validator: FormBuilderValidators.required(
                          errorText: 'standard treatment is required'),
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      name: 'state_upon_enter',
                      decoration: inputDecoration('State upon Enter *',
                          Icons.airline_seat_individual_suite),
                      validator: FormBuilderValidators.required(
                          errorText: 'state upon enter is required'),
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      name: 'bed_number',
                      decoration: inputDecoration('Bed Number', Icons.king_bed),
                      validator: FormBuilderValidators.numeric(
                          errorText: 'bed number should contain numbers only'),
                    ),
                    const SizedBox(height: 20.0),
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
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}