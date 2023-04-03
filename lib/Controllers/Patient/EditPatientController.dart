
// add patient controller
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/Patient.dart';
import '../../Services/Api.dart';

class EditPatientController extends GetxController{

  var formKey = GlobalKey<FormBuilderState>().obs;
  var patient = Patient().obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    print('getting patient informations');
    patient(Get.arguments);

    super.onInit();

  }

  Future<void> submitForm() async {
    // isLoading(true);
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
      print(modifiableFormData);
      //
      try {
        await Api.editPatient(patient.value.id, modifiableFormData);
      } catch (e) {
        isLoading(false);

        print(e);
      }
      isLoading(false);

      // Get.delete<PatientController>();
      Get.back();

    }
    await Future.delayed(Duration(seconds: 2));
  }


}