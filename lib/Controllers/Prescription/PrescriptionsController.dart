
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/Prescription.dart';

import '../../Models/MedicalRecord.dart';
import '../../Services/Api.dart';


class PrescriptionsController extends GetxController{

  var isLoading = false.obs;
  var prescriptions = <Prescription>[].obs;
  var patientId = 0.obs;
  var medicalRecordId = 0.obs;
  var medicalRecord = MedicalRecord().obs;

  @override
  void onInit() {
    patientId(Get.arguments['patientId']);
    medicalRecordId(Get.arguments['medicalRecordId']);
    fetchMedicalRecord();
    fetchPrescriptions();
    super.onInit();
  }

  // fetch medical record
  Future<void> fetchMedicalRecord() async{
    try{
      final res = await Api.getMedicalRecord(patientId: patientId.value, medicalRecordId: medicalRecordId.value);
      final data = res.data['data'] as Map<String, dynamic>;
      medicalRecord(MedicalRecord.fromJson(data));
    }finally{

    }
  }


  Future<void> fetchPrescriptions() async{
    try{
      isLoading(true);
      final res = await Api.getPrescriptions(patientId: patientId.value, medicalRecordId: medicalRecordId.value);
      final data = res.data as List<dynamic>;
      prescriptions(data.map((item) => Prescription.fromJson(item)).toList());
      // print(prescriptions[0].medicineRequests![0].medicine!.name);
    }finally{
      isLoading(false);
    }

  }

  Future<void> addPrescription() async {
    try {
      isLoading(true);
      final res = await Api.addPrescription(patientId: patientId.value, medicalRecordId: medicalRecordId.value);
      await fetchPrescriptions();
      // new prescription id
      final prescriptionId = res.data['data']['id'] as int;
      Get.toNamed('/prescription',
          arguments: {'prescriptionId': prescriptionId})
          ?.then((value) => fetchPrescriptions());
    } finally {
      isLoading(false);
    }
  }


}