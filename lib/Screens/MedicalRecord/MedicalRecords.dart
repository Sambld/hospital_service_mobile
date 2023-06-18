import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Widgets/MedicalRecordCard.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/MedicalRecord/MedicalRecordsController.dart';
import '../../Utils/ResponsiveFontSizes.dart';
import '../../Widgets/NavigationDrawerWidget.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({Key? key}) : super(key: key);

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final _authController = Get.find<AuthController>();
  final controller = Get.put(MedicalRecordsController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text(
          'Medical Records'.tr,
          style: TextStyle(
            fontSize: ResponsiveFontSize.large(),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(
              () => TextField(
                controller: controller.searchController.value,
                onSubmitted: controller.searchMedicalRecords,
                decoration: InputDecoration(
                  hintText: 'Search'.tr,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            controller.searchController.value.clear();
                            controller.searchQuery('');
                            controller.getMedicalRecords();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
                onChanged: (value) {
                  controller.searchQuery(value);
                },
              ),
            ),
          ),
        ),
        flexibleSpace: kAppBarColor,
      ),
      body: Column(
        children: [
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: Text(
                      'Active only'.tr,
                      style: TextStyle(
                        fontSize: ResponsiveFontSize.small(),
                      ),
                    ),
                    value: controller.onlyActive.value,
                    onChanged: (value) async {
                      controller.onlyActive(value);
                      controller.currentPage(1);
                      await controller.getMedicalRecords();
                    },
                  ),
                ),
                 _authController.isNurse() ? const SizedBox() : Expanded(
                  child: SwitchListTile(
                    title: Text(
                      'Mine only'.tr,
                      style: TextStyle(
                        fontSize: ResponsiveFontSize.small(),
                      ),
                    ),
                    value: controller.onlyMine.value,
                    onChanged: (value) async {
                      controller.onlyMine(value);
                      controller.currentPage(1);
                      await controller.getMedicalRecords();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final medicalRecords = controller.medicalRecords;

              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (medicalRecords.isEmpty) {
                  return Center(
                    child: Text('No medical records found'.tr),
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: medicalRecords.length,
                          itemBuilder: (context, index) {
                            final medicalRecord = medicalRecords[index];
                            return MedicalRecordCard(
                                medicalRecord: medicalRecord);
                          },
                        ),
                      ),
                      NumberPaginator(
                        numberPages: controller.totalPages.value,
                        initialPage: controller.currentPage.value - 1,
                        onPageChange: (int index) {
                          controller.currentPage(index + 1);
                          controller.getMedicalRecords();
                        },
                      ),
                    ],
                  );
                }
              }
            }),
          ),
        ],
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 35.0),
      //   child: FloatingActionButton(
      //     clipBehavior: Clip.antiAlias,
      //     onPressed: () {
      //       Get.toNamed('/add-medical-record');
      //     },
      //     child: const Icon(Icons.add),
      //   ),
      // ),
    );
  }
}
