import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Utils/ResponsiveFontSizes.dart';
import 'package:infectious_diseases_service/Widgets/PatientCard.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/Patient/PatientsController.dart';
import '../../Widgets/NavigationDrawerWidget.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final _authController = Get.find<AuthController>();
  final controller = Get.put(PatientsController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients '.tr),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '(${controller.totalPatients.value})',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(
              () => TextField(
                controller: controller.searchController.value,
                // controller: TextEditingController(text: _patientsController.searchQuery.value),
                onSubmitted: controller.searchPatients,
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
                            controller.getPatients();
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
      drawer: NavigationDrawerWidget(),
      body: Column(
        children: [
          Obx(
            () => SwitchListTile(
              title: Text('In Hospital Only'.tr , style: TextStyle(fontSize: ResponsiveFontSize.medium()),),
              value: controller.inHospitalOnly.value,
              onChanged: (value) {
                controller.inHospitalOnly(value);
                controller.currentPage(1);
                controller.getPatients();
              },
            ),
          ),
          // if loading show progress indicator
          Obx(
            () => controller.isLoading.value
                ? const Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Center(child: CircularProgressIndicator()),
                )
                : Expanded(
                    child: Obx(() {
                      final patients = controller.patients;

                      if (patients.isEmpty) {
                        return const Center(
                          child: Text('No patients found'),
                        );
                      }
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: patients.length,
                              itemBuilder: (context, index) {
                                final patient = patients[index];
                                return PatientCard(
                                  onTap: () {
                                    Get.toNamed('/patient-details',
                                            arguments: patient.id!)
                                        ?.then((value) =>
                                            controller.getPatients());
                                  },
                                  id: patient.id!,
                                  firstName: patient.firstName!,
                                  lastName: patient.lastName!,
                                  gender: patient.gender!,
                                  phoneNumber: patient.phoneNumber!,
                                  birthDate: patient.birthDate!,
                                );
                              },
                            ),
                          ),
                          NumberPaginator(
                            numberPages: controller.totalPages.value,
                            initialPage: controller.currentPage.value - 1,
                            // currentPage: int.parse(_patientsController.currentPage.value),
                            onPageChange: (int index) {
                              controller.currentPage(index + 1);
                              controller.getPatients();
                            },
                          ),
                        ],
                      );
                    }),
                  ),
          ),
        ],
      ),
      floatingActionButton: _authController.user['role'] == 'doctor'? Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: FloatingActionButton(
          clipBehavior: Clip.antiAlias,
          onPressed: () {
            Get.toNamed('/add-patient');
          },
          child: const Icon(Icons.add),
        ),
      ): null,
    );
  }
}
