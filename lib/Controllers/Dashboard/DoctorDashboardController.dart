import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
  var search = ''.obs;
  var searchController = TextEditingController().obs;

  get activeMedicalRecords => medicalRecords
      .where((element) => element.patientLeavingDate == null)
      .toList();

  @override
  void onInit() {
    // TODO: implement onInit
    doctor(Get.find<AuthController>().user);
    // getDoctorMedicalRecords();
    getPatientsCount();
    getActiveMedicalRecords();
    getLatestUpdates();

    super.onInit();
  }

  Future<void> getLatestUpdates() async {
    updatesLoading(true);
    final res = await Api.dio.get('monitoring-sheets/latest-updates');
    latestMSUpdates(res.data
        .map<MonitoringSheet>((e) => MonitoringSheet.fromJson(e))
        .toList());

    updatesLoading(false);

  }

  // Future<void> getDoctorMedicalRecords() async {
  //   medicalRecordsLoading(true);
  //   try {
  //     var res = await Api.getDoctorMedicalRecords(doctorId: doctor['id']);
  //     if (res.statusCode == 200) {
  //       medicalRecords(res.data.map<MedicalRecord>((e) => MedicalRecord.fromJson(e)).toList());
  //
  //
  //     }
  //   } on DioError {
  //     throw 'Error';
  //   }
  //   medicalRecordsLoading(false);
  // }

  // getActiveMedicalRecords
  Future<void> getActiveMedicalRecords() async {
    medicalRecordsLoading(true);
    try {
      final res = await Api.getActiveMedicalRecords();
      medicalRecords(res.data
          .map<MedicalRecord>((e) => MedicalRecord.fromJson(e))
          .toList());
    } catch (e) {
      throw 'Error';
    }
    medicalRecordsLoading(false);
  }

  Future<void> getPatientsCount() async {
    try {
      final res = await Api.dio.get('patients?count');
      patientsCount(res.data['count']);
    } catch (e) {
      throw 'Error';
    }
  }

  List<MedicalRecord> get activeMedicalRecordsSearch {
    if (search.value.isEmpty) {
      return activeMedicalRecords;
    } else {
      return activeMedicalRecords.where((medicalRecord) {
        // print("${medicalRecord.bedNumber.toString()} ${medicalRecord.toString()}");
        return (medicalRecord.patient?.firstName
                    ?.toLowerCase()
                    .contains(search.value.toLowerCase()) ??
                false) ||
            (medicalRecord.patient?.lastName
                    ?.toLowerCase()
                    .contains(search.value.toLowerCase()) ??
                false) ||
            (medicalRecord.bedNumber.toString() == search.value);
      }).toList();
    }
  }
}
