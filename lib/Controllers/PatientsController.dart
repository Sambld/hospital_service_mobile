import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/Patient.dart';

import '../Services/Api.dart';

class PatientsController extends GetxController {
  //patients controller
  var patients = <Patient>[].obs;
  var totalPages = 0.obs;
  var currentPage = 1.obs;
  var isLoading = false.obs;
  var totalPatients = 0.obs;
  var searchQuery = ''.obs;
  var inHospitalOnly = false.obs;

  @override
  void onInit() async {
    // print("getting patients");

    await getPatients();
    super.onInit();
  }

  Future<List<Patient>> getPatients() async {
    isLoading(true);
    try{
      final res = await Api.getPatients(page: currentPage.value , search: searchQuery.value , inHospitalOnly: inHospitalOnly.value);
      final data = res.data['data']['data'] as List<dynamic>;
      totalPages(res.data['data']['last_page']);
      totalPatients(res.data['count']);
      final patientsList = List.generate(data.length, (index) => Patient.fromJson(data[index])) ;
      patients(patientsList);
      // patients(data.map((item) => Patient.fromJson(item)).toList());
      isLoading(false);
      return patients;
    }catch(e){
     e.printError();
      totalPages(0);
      totalPatients(0);
      isLoading(false);
      return patients([]);
    }
  }
  void searchPatients(String query) {
    getPatients();
  }
}


