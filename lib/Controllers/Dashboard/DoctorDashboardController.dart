

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/MedicalRecord.dart';

import '../../Services/Api.dart';
import '../AuthController.dart';

class DoctorDashboardController extends GetxController {

  var isLoading = false.obs;
  var medicalRecords = <MedicalRecord>[].obs;
  var doctor = {}.obs;
  var patientsCount = 0.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    doctor(Get.find<AuthController>().user);
    print(Get.find<AuthController>().user);
    getDoctorMedicalRecords();
    getMyPatientsCount();

    super.onInit();
  }


  Future<void> getDoctorMedicalRecords() async {
    isLoading(true);
    try {
      var res = await Api.getDoctorMedicalRecords(doctorId: doctor.value['id']);
      if (res.statusCode == 200) {
        medicalRecords(res.data.map<MedicalRecord>((e) => MedicalRecord.fromJson(e)).toList());
      }
      print(medicalRecords);
    } on DioError catch (e) {
      print(e);
    }
    isLoading(false);
  }

  Future<void> getMyPatientsCount() async{
    try{
      final res = await Api.dio.get('patients?onlyMyPatientsCount=true');
      patientsCount(res.data['count']);

    }catch(e){
      print(e);
    }
  }





}