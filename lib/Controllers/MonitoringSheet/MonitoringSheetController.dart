


import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/MedicalRecord.dart';
import '../../Models/MonitoringSheet.dart';
import '../../Models/Patient.dart';
import '../../Services/Api.dart';

class MonitoringSheetController extends GetxController {

  var patient = Patient().obs;
  var medicalRecord = MedicalRecord().obs;
  var isLoading = false.obs;
  var monitoringSheetList = <MonitoringSheet>[].obs;
  var currentMonitoringSheet = MonitoringSheet().obs;
  var currentMonitoringSheetIndex = 0.obs;




  @override
  void onInit() {
    // TODO: implement onInit

    patient(Get.arguments['patient']);
    medicalRecord(Get.arguments['medicalRecord']);
    getMonitoringSheets();
    print(patient);
    super.onInit();
  }

  // Future<void> updateMonitoringSheet() async {
  //   isLoading(true);
  //   final res = await Api.updateMonitoringSheet(
  //       patientId: patient.value.id!,
  //       medicalRecordId: medicalRecord.value.id!,
  //       monitoringSheetId: currentMonitoringSheet.value.id!,
  //       monitoringSheet: currentMonitoringSheet.value);
  //   if (res.statusCode == 200) {
  //     isLoading(false);
  //     // handle success
  //   } else {
  //     isLoading(false);
  //     // handle error
  //   }
  // }


  Future<void> getMonitoringSheets() async {
    isLoading(true);
    final res = await Api.getMonitoringSheets(
        patientId: patient.value.id!, medicalRecordId: medicalRecord.value.id!);
    if (res.statusCode == 200) {
      final data = res.data['data'] as List<dynamic>;
      final monitoringsheetslist = List.generate(data.length, (index) => MonitoringSheet.fromJson(data[index])) ;
      monitoringSheetList(monitoringsheetslist);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

// Find today's monitoring sheet from the list
      if (monitoringSheetList.isNotEmpty){
        try {
          final todayMonitoringSheet = monitoringSheetList.firstWhere(
                  (sheet) => sheet.fillingDate == today
            // Return null if not found
          );
          currentMonitoringSheet(todayMonitoringSheet);
          currentMonitoringSheetIndex(monitoringSheetList.indexOf(todayMonitoringSheet));
          print(currentMonitoringSheetIndex);
        } catch (e) {
          currentMonitoringSheet(monitoringsheetslist[0]);
          currentMonitoringSheetIndex(0);
        }
      }else{
        print("monitoring sheet list is empty ");
      }

      for (var sheet in monitoringSheetList) {
        print(sheet.fillingDate);
      }
      isLoading(false);

      // final data = res.data['data'] as List<dynamic>;
      // final monitoringSheetssList = data.map((e) => MonitoringSheet.fromJson(e))
      //     .toList();
      // monitoringSheets.assignAll(monitoringSheetssList);
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
}