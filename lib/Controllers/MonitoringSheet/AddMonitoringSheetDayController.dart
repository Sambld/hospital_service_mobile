import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../Models/Medicine.dart';
import '../../Services/Api.dart';
import 'MonitoringSheetController.dart';
class AddMonitoringSheetDayController extends GetxController{


  var day = DateTime.now().obs;

  var latestDay = DateTime.now().obs;
  var treatmentList = <TreatmentData>[].obs;
  final loadingButtonController = RoundedLoadingButtonController().obs;




  @override
  void onInit() {
    latestDay(Get.arguments);
    day(latestDay.value.add(Duration(days: 1)));
    super.onInit();
  }

  void addTreatment(TreatmentData treatmentData) {
    treatmentList.add(treatmentData);
  }

  void removeTreatment(TreatmentData treatmentData) {
    treatmentList.remove(treatmentData);
  }


  Future<void> addMonitoringSheetDay() async {

    loadingButtonController.value.start();
    final _monitoringSheetController = Get.find<MonitoringSheetController>();
    final patientId = _monitoringSheetController.patientId.value;
    final medicalRecordId = _monitoringSheetController.medicalRecordId.value;
    final res = await Api.addMonitoringSheet(patientId,medicalRecordId , {'filling_date' : DateFormat('yyyy/MM/dd').format(day.value).toString()});
    if (res.statusCode == 200) {
      int newMonitoringSheetId = res.data['data']['id'];
      for (var treatment in treatmentList) {
        await Api.addMonitoringSheetTretment(patientId,medicalRecordId,newMonitoringSheetId ,
        {
          'name': treatment.name,
          'dose': treatment.dose,
          'type': treatment.type,
          'medicine_id': treatment.medicineId,
        });
      }
      loadingButtonController.value.success();
      _monitoringSheetController.getMonitoringSheets();
      Get.back();
    }
    else{
      loadingButtonController.value.error();
    }
  }



}




class TreatmentData {
  final String name;
  final String dose;
  final String type;
  final int medicineId;

  TreatmentData({
    required this.name,
    required this.dose,
    required this.type,
    required this.medicineId,
  });
  // to json method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dose': dose,
      'type': type,
      'medicine_id': medicineId,
    };
  }
}