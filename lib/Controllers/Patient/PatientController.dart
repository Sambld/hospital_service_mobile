
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/MedicalRecord.dart';
import '../../Models/Patient.dart';
import '../../Services/Api.dart';

class PatientController extends GetxController {
  var id = 0.obs;
  var patient = Patient().obs;
  var medicalRecords = <MedicalRecord>[].obs;
  var filteredMedicalRecords = <MedicalRecord>[].obs;
  var isLoading = false.obs;
  var recordsFilter = true.obs;

  @override
  void onInit()  {
    id(Get.arguments);
    getPatient();
    super.onInit();

  }



  Future<void> getPatient() async {
    isLoading(true);
      final res = await Api.getPatient(id: id.value);
      patient(Patient.fromJson(res.data['data']['patient']));
      medicalRecords(res.data['data']['patient']['medical_records'].map<MedicalRecord>((item) => MedicalRecord.fromJson(item)).toList());
      medicalRecords.sort((a, b) => b.patientEntryDate!.compareTo(a.patientEntryDate!));
      filterRecords();

    isLoading(false);

  }

  Future<void> _makePhoneCall(String url) async {
    await launchUrl(Uri.parse(url));

  }

  void filterRecords() {
    if(medicalRecords.isNotEmpty){
      filteredMedicalRecords.value =
      // filter medicalRecords by patientleavingdate is null
      medicalRecords.value.where((record) => (record.patientLeavingDate == null) == recordsFilter.value ).toList();

    }

    ;
  }



}
