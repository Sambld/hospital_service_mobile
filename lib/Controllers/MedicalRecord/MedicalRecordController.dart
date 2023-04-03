

import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/MedicalRecord.dart';

import '../../Models/Patient.dart';
import '../../Services/Api.dart';

class MedicalRecordController extends GetxController{
  var isLoading = false.obs;
  var patient = Patient().obs;
  var medicalRecord = MedicalRecord().obs;
  var patientId = 0.obs;
  var medicalRecordId = 0.obs;

  @override
  void onInit() {


    patientId(Get.arguments['patient'].id);
    patient(Get.arguments['patient']);
    medicalRecordId(Get.arguments['medicalRecordId']);
    // print(patientId);
    // print(medicalRecordId);
    getMedicalRecord();
    super.onInit();
  }

  Future<void> getMedicalRecord() async {
    isLoading(true);


    try{
      final res = await Api.getMedicalRecord(patientId: patientId.value, medicalRecordId: medicalRecordId.value);
      final data = res.data['data'];
      print(data);
      medicalRecord(MedicalRecord.fromJson(data));
      print(medicalRecord.value.id);
      isLoading(false);
    }catch(e){
      e.printError();
      isLoading(false);
    }
  }
}