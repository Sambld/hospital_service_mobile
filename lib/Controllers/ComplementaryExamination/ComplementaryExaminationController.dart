import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/Patient.dart';
import 'package:infectious_diseases_service/Services/Api.dart';

import '../../Models/ComplementaryExamination.dart';
import '../../Models/MedicalRecord.dart';

class ComplementaryExaminationController extends GetxController{

  late int patientId = 0;
  late int medicalRecordId = 0;
 var patient = Patient().obs;
 var medicalRecord = MedicalRecord().obs;
 var complementaryExaminations = <ComplementaryExamination>[].obs;
 var isLoading = false.obs;

 // flutter_form_builder form controller
  var formKey = GlobalKey<FormBuilderState>().obs;
  var editFormKey = GlobalKey<FormBuilderState>().obs;

 @override
  void onInit() {

   patientId = Get.arguments['patientId'];
    medicalRecordId = Get.arguments['medicalRecordId'];

   fetchPatient();
   fetchMedicalRecord();
   fetchComplementaryExaminations();

    super.onInit();
  }

  Future<void> fetchPatient() async {
    final patientReq = await Api.getPatient(id: patientId , withMedicalRecords: false );
    patient(Patient.fromJson(patientReq.data['data']['patient']));
  }

  Future<void> fetchMedicalRecord() async {
    final medicalRecordReq = await Api.getMedicalRecord(patientId: patientId, medicalRecordId: medicalRecordId);
    medicalRecord(MedicalRecord.fromJson(medicalRecordReq.data['data']));
  }

  Future<void> fetchComplementaryExaminations() async {
    isLoading(true);
    final res = await Api.getComplementaryExaminations(patientId: patientId, medicalRecordId: medicalRecordId);
    if (res.statusCode == 200) {
      final data = res.data['data'] as List<dynamic>;
      final complementaryExaminationsList = List.generate(data.length, (index) => ComplementaryExamination.fromJson(data[index])) ;
      // sort by createdAt descending
      complementaryExaminationsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      complementaryExaminations(complementaryExaminationsList);
      // isLoading(false);
    }
    isLoading(false);
  }


}