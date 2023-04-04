

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/MedicalRecord.dart';
import '../../Models/Patient.dart';
import '../../Services/Api.dart';
import '../Patient/PatientController.dart';

class AddMedicalRecordController extends GetxController{
  var isLoading = false.obs;
  var patient = Patient().obs;
  var formKey = GlobalKey<FormBuilderState>().obs;

  @override
  void onInit(){
    
    patient(Get.arguments);

    super.onInit();
  }

  Future<void> submitForm() async {
    final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');

    if (formKey.value.currentState!.saveAndValidate()) {

      print (formKey.value.currentState!.value['patient_entry_date'])  ;
      final formData = formKey.value.currentState!.value;
      final modifiableFormData = Map<String, dynamic>.from(formData);
      modifiableFormData.removeWhere((key, value) => value == null);

      if (modifiableFormData.containsKey('patient_entry_date')) {
        final patientEntryDate = modifiableFormData['patient_entry_date'];
        final formattedpatientEntryDate = _dateFormat.format(patientEntryDate);
        modifiableFormData['patient_entry_date'] = formattedpatientEntryDate;
      }

      print(modifiableFormData);
      // final formattedFormData = modifiableFormData.map((key, value) => MapEntry(key.toString(), value.toString()));

      // print(formattedFormData);

      final res = await Api.addMedicalRecord( patient.value.id! , modifiableFormData);
      isLoading(false);

      Get.find<PatientController>().getPatient();
      Get.offNamed(
          "/medical-record-details",
          arguments: {
            'patient':
            patient.value,
            'medicalRecordId':
           res.data['data']['id']
          });

    }
    isLoading(false);

  }

}