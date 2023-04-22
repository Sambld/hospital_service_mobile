

import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/Treatment.dart';

import '../../Services/Api.dart';
import 'MonitoringSheetController.dart';

class UpdateMonitoringSheetTreatmentsController extends GetxController{


  var day = DateTime.now().obs;
  final MC = Get.find<MonitoringSheetController>();
  var treatmentList = <Treatment>[].obs;


  @override
  void onInit() {

    // TODO: implement onInit
    day(MC.currentMonitoringSheet.value.fillingDate);
    getTreatments();
    super.onInit();
  }

  Future<void> getTreatments() async {

    final res = await Api.getMonitoringSheetTreatments(patientId: MC.patientId.value, medicalRecordId: MC.medicalRecordId.value , monitoringSheetId: MC.currentMonitoringSheet.value.id!);
    if (res.statusCode == 200) {
      // convert json to list of treatments
      final List<dynamic> jsonList = res.data['data'];
      final List<Treatment> treatments = jsonList.map((e) => Treatment.fromJson(e)).toList();
      treatmentList(treatments);
    }
  }



}