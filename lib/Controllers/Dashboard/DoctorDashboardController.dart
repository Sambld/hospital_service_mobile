

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/MedicalRecord.dart';
import 'package:infectious_diseases_service/Models/MonitoringSheet.dart';

import '../../Services/Api.dart';
import '../AuthController.dart';

class DoctorDashboardController extends GetxController {

  var medicalRecordsLoading = false.obs;
  var updatesLoading = false.obs;
  var medicalRecords = <MedicalRecord>[].obs;
  var doctor = {}.obs;
  var patientsCount = 0.obs;
  var latestMSUpdates = <MonitoringSheet>[].obs;

  get activeMedicalRecords => medicalRecords.where((element) => element.patientLeavingDate == null).toList();


  @override
  void onInit() {
    // TODO: implement onInit
    doctor(Get.find<AuthController>().user);
    getDoctorMedicalRecords();
    getMyPatientsCount();
    getLatestUpdates();

    super.onInit();
  }

  Future<void> getLatestUpdates() async{
    updatesLoading(true);
      final res = await Api.dio.get('monitoring-sheets/latest-updates');
      latestMSUpdates(res.data.map<MonitoringSheet>((e) => MonitoringSheet.fromJson(e)).toList());

      updatesLoading(false);
  }


  Future<void> getDoctorMedicalRecords() async {
    medicalRecordsLoading(true);
    try {
      var res = await Api.getDoctorMedicalRecords(doctorId: doctor['id']);
      if (res.statusCode == 200) {
        medicalRecords(res.data.map<MedicalRecord>((e) => MedicalRecord.fromJson(e)).toList());


      }
    } on DioError {
      throw 'Error';
    }
    medicalRecordsLoading(false);
  }

  Future<void> getMyPatientsCount() async{
    try{
      final res = await Api.dio.get('patients?onlyMyPatientsCount=true');
      patientsCount(res.data['count']);

    }catch(e){
throw 'Error';
    }
  }





}