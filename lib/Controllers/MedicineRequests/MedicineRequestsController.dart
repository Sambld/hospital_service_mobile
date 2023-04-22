import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/MedicineRequest.dart';
import 'package:infectious_diseases_service/Models/Patient.dart';
import 'package:infectious_diseases_service/Services/Api.dart';
import '../../Models/MedicalRecord.dart';
import '../../Models/Medicine.dart';

class MedicineRequestsController extends GetxController {
  var isLoading = true.obs;
  int patientId = 0;
  int medicalRecordId = 0;
  var patient = Patient().obs;
  var medicalRecord = MedicalRecord().obs;
  var allMedicineRequests = <MedicineRequest>[].obs;
  var selectedStatus = 'All'.obs;
  var medicines = <Medicine>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    patientId = Get.arguments['patientId'];
    medicalRecordId = Get.arguments['medicalRecordId'];
    fetchPatient();
    fetchMedicalRecord();
    fetchMedicineRequests();
    fetchMedicines();

    super.onInit();
  }

  void fetchPatient() async {
    try {
      final patientReq =
          await Api.getPatient(id: patientId, withMedicalRecords: false);
      patient(Patient.fromJson(patientReq.data['data']['patient']));
    } finally {
    }
  }

  // fetch medicines
  void fetchMedicines() async {
    try {
      final medicinesReq = await Api.getMedicines();
      medicines(medicinesReq.data['data']
          .map<Medicine>((e) => Medicine.fromJson(e))
          .toList());
    } finally {
    }
  }

  void fetchMedicalRecord() async {
    try {
      final medicalRecordReq = await Api.getMedicalRecord(
          patientId: patientId, medicalRecordId: medicalRecordId);
      medicalRecord(MedicalRecord.fromJson(medicalRecordReq.data['data']));
    } finally {
    }
  }

  void fetchMedicineRequests() async {
    isLoading(true);
    try {
      final medicineRequestsReq = await Api.getMedicineRequests(
          patientId: patientId, medicalRecordId: medicalRecordId);
      allMedicineRequests(medicineRequestsReq.data['data']
          .map<MedicineRequest>((e) => MedicineRequest.fromJson(e))
          .toList());

    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  List<MedicineRequest> get medicineRequests {
    if (selectedStatus.value == 'All') {
      return allMedicineRequests;
    } else {
      return allMedicineRequests
          .where((req) => req.status == selectedStatus.value)
          .toList();
    }
  }

  void setSelectedStatus(String status) {
    selectedStatus.value = status;
  }

  Future<void> addMedicineRequest(Map dataForm) async {
    isLoading(true);
    try {
      final medicineRequestReq = await Api.addMedicineRequest(
          patientId: patientId,
          medicalRecordId: medicalRecordId,
          dataForm: dataForm);
      if (medicineRequestReq.statusCode == 200) {
        fetchMedicineRequests();
      }
    } finally {
      Future.delayed(Duration(seconds: 1));
      isLoading(false);
    }
  }

  Future<void> editMedicineRequest(int id , Map dataForm) async {
    isLoading(true);
    try {
      final medicineRequestReq = await Api.editMedicineRequest(
          patientId: patientId,
          medicalRecordId: medicalRecordId,
          id: id,
          dataForm: dataForm);
      if (medicineRequestReq.statusCode == 200) {
        fetchMedicineRequests();
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteMedicineRequest(int id) async {
    isLoading(true);
    try {
      final medicineRequestReq = await Api.deleteMedicineRequest(
          patientId: patientId,
          medicalRecordId: medicalRecordId,
          id: id);
      if (medicineRequestReq.statusCode == 200) {
        fetchMedicineRequests();
      }
    } finally {
      isLoading(false);
    }
  }
}
