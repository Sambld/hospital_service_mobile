import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final _patientsController = Get.put(PatientsController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print('dispose  called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients '),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '(${_patientsController.totalPatients.value})',
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
              ()=> TextField(
                controller: _patientsController.searchController.value,
                // controller: TextEditingController(text: _patientsController.searchQuery.value),
                onSubmitted: _patientsController.searchPatients,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: _patientsController.searchQuery.value.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      _patientsController.searchController.value.clear();
                      _patientsController.searchQuery('');
                      _patientsController.getPatients();
                    },
                    icon: const Icon(Icons.clear),
                  )
                      : null,
                ),
                onChanged: (value) {
                  _patientsController.searchQuery(value);
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
              title: const Text('In Hospital Only'),
              value: _patientsController.inHospitalOnly.value,
              onChanged: (value) {
                _patientsController.inHospitalOnly(value);
                _patientsController.currentPage(1);
                _patientsController.getPatients();
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              final patients = _patientsController.patients;

              if (patients.isEmpty) {
                return const Center(
                  child: Text('No patients found'),
                );
              }
              if (_patientsController.isLoading.value) {
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
                          onTap: (){
                            Get.toNamed('/patient-details', arguments: patient.id!)?.then((value) => _patientsController.getPatients());
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
                    numberPages: _patientsController.totalPages.value,
                    initialPage: _patientsController.currentPage.value - 1,
                    // currentPage: int.parse(_patientsController.currentPage.value),
                    onPageChange: (int index) {
                      _patientsController.currentPage(index + 1);
                      _patientsController.getPatients();
                    },
                  ),
                ],
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: FloatingActionButton(
          clipBehavior: Clip.antiAlias,
          onPressed: () {
            Get.toNamed('/add-patient');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
