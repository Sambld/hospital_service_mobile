


import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/MedicalRecord.dart';
import '../../Models/Medicine.dart';
import '../../Models/MonitoringSheet.dart';
import '../../Models/Patient.dart';
import '../../Services/Api.dart';

class MonitoringSheetController extends GetxController {

  var patientId = 0.obs;
  var medicalRecordId = 0.obs;
  var patient = Patient().obs;
  var medicalRecord = MedicalRecord().obs;
  var isLoading = false.obs;
  var monitoringSheetList = <MonitoringSheet>[].obs;
  var currentMonitoringSheet = MonitoringSheet().obs;
  var currentMonitoringSheetIndex = 0.obs;
  var medicinesList = <Medicine>[].obs;




  @override
  void onInit() {
    // TODO: implement onInit

    patientId(Get.arguments['patientId']);
    medicalRecordId(Get.arguments['medicalRecordId']);
    getMonitoringSheets();
    // getMedicines();

    super.onInit();
  }




  Future<void> getMonitoringSheets() async {
    isLoading(true);

    final patientReq = await Api.getPatient(id: patientId.value , withMedicalRecords: false );
    patient(Patient.fromJson(patientReq.data['data']['patient']));

    final medicalRecordReq = await Api.getMedicalRecord(patientId: patientId.value, medicalRecordId: medicalRecordId.value);
    medicalRecord(MedicalRecord.fromJson(medicalRecordReq.data['data']));


    final res = await Api.getMonitoringSheets(
        patientId: patientId.value, medicalRecordId: medicalRecordId.value);
    if (res.statusCode == 200) {
      final data = res.data['data'] as List<dynamic>;
      final monitoringsheetslist = List.generate(data.length, (index) => MonitoringSheet.fromJson(data[index])) ;
      monitoringSheetList(monitoringsheetslist);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

// Find today's monitoring sheet from the list
      if (currentMonitoringSheetIndex.value != 0 && currentMonitoringSheetIndex.value < monitoringsheetslist.length){

        currentMonitoringSheet(monitoringsheetslist[currentMonitoringSheetIndex.value]);
      }else{
        if (monitoringSheetList.isNotEmpty){
          try {
            final todayMonitoringSheet = monitoringSheetList.firstWhere(
                    (sheet) => sheet.fillingDate == today
              // Return null if not found
            );
            currentMonitoringSheet(todayMonitoringSheet);
            currentMonitoringSheetIndex(monitoringSheetList.indexOf(todayMonitoringSheet));
          } catch (e) {
            currentMonitoringSheet(monitoringsheetslist[0]);
            currentMonitoringSheetIndex(0);
          }
        }else{
          print("Monitoring Sheet list is empty");
        }
      }

      isLoading(false);
    } else {
      isLoading(false);

      // handle error
    }
  }

  void changeMonitoringSheet(int index){
    currentMonitoringSheet(monitoringSheetList[index]);
    currentMonitoringSheetIndex(index);
  }

  void nextMonitoringSheet(){
    if (currentMonitoringSheetIndex.value < monitoringSheetList.length - 1){
      currentMonitoringSheetIndex(currentMonitoringSheetIndex.value + 1);
      currentMonitoringSheet(monitoringSheetList[currentMonitoringSheetIndex.value]);
    }
  }
  bool isLastMonitoringSheet(){
    return currentMonitoringSheetIndex.value == monitoringSheetList.length - 1;
  }
  bool isFirstMonitoringSheet(){
    return currentMonitoringSheetIndex.value == 0;
  }

  void previousMonitoringSheet(){
    if (currentMonitoringSheetIndex.value > 0){
      currentMonitoringSheetIndex(currentMonitoringSheetIndex.value - 1);
      currentMonitoringSheet(monitoringSheetList[currentMonitoringSheetIndex.value]);
    }
  }


  // Future<void> getMedicines() async {
  //   final res = await Api.getMedicines();
  //   if (res.statusCode == 200) {
  //     final data = res.data['data'] as List<dynamic>;
  //     final medicineslist = List.generate(data.length, (index) => Medicine.fromJson(data[index])) ;
  //     medicinesList(medicineslist);
  //     print(medicinesList);
  //
  //   }
  // }
}