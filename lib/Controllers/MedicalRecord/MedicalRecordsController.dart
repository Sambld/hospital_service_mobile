import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/MedicalRecord.dart';

import '../../Services/Api.dart';

class MedicalRecordsController extends GetxController {
  // medical records controller
  var medicalRecords = <MedicalRecord>[].obs;
  var totalPages = 0.obs;
  var currentPage = 1.obs;
  var isLoading = false.obs;
  var totalMedicalRecords = 0.obs;
  var searchQuery = ''.obs;
  var searchController = TextEditingController().obs;
  var onlyActive = false.obs;
  var onlyMine = false.obs;

  @override
  void onInit() async {
    await getMedicalRecords();
    super.onInit();
  }

  Future<void> getMedicalRecords() async {
    isLoading(true);

      final res = await Api.getMedicalRecords(
          page: currentPage.value, search: searchQuery.value, isActive: onlyActive.value , isMine: onlyMine.value);

      final data = res.data['data'] as List<dynamic>;
      totalPages(res.data['last_page']);
      totalMedicalRecords(res.data['total']);
      final medicalRecordsList =
      List.generate(data.length, (index) => MedicalRecord.fromJson(data[index]));
      medicalRecords(medicalRecordsList);
      isLoading(false);


  }

  void searchMedicalRecords(String query) {
    searchQuery(query);
    getMedicalRecords();
  }
}
