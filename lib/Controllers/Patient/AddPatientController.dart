
// add patient controller
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Controllers/Patient/PatientsController.dart';
import 'package:intl/intl.dart';

import '../../Services/Api.dart';

class AddPatientController extends GetxController{

  var formKey = GlobalKey<FormBuilderState>().obs;
  var isLoading = false.obs;


  Future<void> submitForm() async {
    final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');

    if (formKey.value.currentState!.saveAndValidate()) {
      final formData = formKey.value.currentState!.value;
      final modifiableFormData = Map<String, dynamic>.from(formData);
      modifiableFormData.removeWhere((key, value) => value == null);

      if (modifiableFormData.containsKey('birth_date')) {
        final birthDate = modifiableFormData['birth_date'];
        final formattedBirthDate = _dateFormat.format(birthDate);
        modifiableFormData['birth_date'] = formattedBirthDate;
      }
      // final formattedFormData = modifiableFormData.map((key, value) => MapEntry(key.toString(), value.toString()));

      // print(formattedFormData);

      final res = await Api.addPatient(modifiableFormData);

      isLoading(false);

      final patientId = res.data['patient']['id'];
      Get.find<PatientsController>().getPatients();
      Get.offNamed('/patient-details', arguments: patientId);
    }
    isLoading(false);

  }


}