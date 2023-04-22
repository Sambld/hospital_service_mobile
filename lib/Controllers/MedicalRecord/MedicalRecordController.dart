

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



    medicalRecordId(Get.arguments['medicalRecordId']);
    patientId(Get.arguments['patientId']);
    getMedicalRecord();
    super.onInit();
  }

  Future<void> getMedicalRecord() async {
    isLoading(true);


    try{

      final patientReq = await Api.getPatient(id: patientId.value , withMedicalRecords: false );
      patient(Patient.fromJson(patientReq.data['data']['patient']));
      final medicalRecordReq = await Api.getMedicalRecord(patientId: patientId.value, medicalRecordId: medicalRecordId.value);
      medicalRecord(MedicalRecord.fromJson(medicalRecordReq.data['data']));
      isLoading(false);
    }catch(e){
      e.printError();
      isLoading(false);
    }
  }
}