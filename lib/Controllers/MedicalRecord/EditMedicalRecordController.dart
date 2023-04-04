import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Controllers/MedicalRecord/MedicalRecordController.dart';
import 'package:infectious_diseases_service/Models/MedicalRecord.dart';
import 'package:intl/intl.dart';
import '../../Models/Patient.dart';
import '../../Services/Api.dart';

class EditMedicalRecordController extends GetxController {
  var medicalRecord = MedicalRecord().obs;
  var patient = Patient().obs;
  var isLoading = false.obs;
  var formKey = GlobalKey<FormBuilderState>().obs;



  @override
  void onInit() {
    medicalRecord(Get.arguments['medicalRecord']);
    patient(Get.arguments['patient']);
    super.onInit();
  }

  Future<void> submitForm() async {
    final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');

    if (formKey.value.currentState!.saveAndValidate()) {

      final formData = formKey.value.currentState!.value;
      final modifiableFormData = Map<String, dynamic>.from(formData);
      modifiableFormData.removeWhere((key, value) => value == null);

      if (modifiableFormData.containsKey('patient_entry_date')) {
        final patientEntryDate = modifiableFormData['patient_entry_date'];
        final formattedpatientEntryDate = _dateFormat.format(patientEntryDate);
        modifiableFormData['patient_entry_date'] = formattedpatientEntryDate;
      }
      if (modifiableFormData.containsKey('patient_leaving_date')) {
        final patientLeavingDate = modifiableFormData['patient_leaving_date'];
        final formattedpatientLeavingDate = _dateFormat.format(patientLeavingDate);
        modifiableFormData['patient_leaving_date'] = formattedpatientLeavingDate;
      }

      final formattedFormData = modifiableFormData.map((key, value) => MapEntry(key.toString(), value.toString()));

      print(formattedFormData);

      final res = await Api.editMedicalRecord( medicalRecord.value.patientId! , medicalRecord.value.id! , modifiableFormData);
      isLoading(false);


      Get.find<MedicalRecordController>().getMedicalRecord();
      Get.back();

    }
    isLoading(false);

  }

}