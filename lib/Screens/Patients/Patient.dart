import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Controllers/Patient/PatientsController.dart';
import 'package:infectious_diseases_service/Screens/Medical%20record/MedicalRecord.dart';
import 'package:infectious_diseases_service/Screens/Patients/EditPatient.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/Patient/PatientController.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({Key? key}) : super(key: key);

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final _patientController = Get.put(PatientController());
  final _authController = Get.find<AuthController>();

  @override
  void dispose() {
    // _patientsController.getPatients();
    _patientController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 3,
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text("informations"),
                ),
                Tab(icon: Text("Medical records")),
              ],
            ),
            actions: [
              //edit button
              _authController.isDoctor() ? IconButton(
                onPressed: () {
                  Get.toNamed('/edit-patient',
                          arguments: _patientController.patient.value)
                      ?.then((value) => _patientController.getPatient());
                  print('edit button pressed');
                },
                icon: const Icon(Icons.edit),
              ) : Container(),
            ],
            // backgroundColor: Colors.transparent,
            title: Text(
              'Patient Details  (#${_patientController.patient.value.id})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            flexibleSpace: kAppBarColor,
          ),
          body: _patientController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2.5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _patientInfoRow(
                                title: "Name",
                                value:
                                    '${_patientController.patient.value.firstName} ${_patientController.patient.value.lastName}'),
                            _patientInfoRow(
                              title: 'Gender',
                              value: _patientController.patient.value.gender!,
                            ),
                            _patientInfoRow(
                              title: 'Birth Date',
                              value: _patientController.patient.value.birthDate!
                                  .toString()
                                  .substring(0, 10),
                            ),
                            _patientInfoRow(
                                title: 'Place of Birth',
                                value: _patientController
                                    .patient.value.placeOfBirth!),
                            _patientInfoRow(
                                title: 'Address',
                                value:
                                    _patientController.patient.value.address!),
                            _patientInfoRow(
                                title: 'Phone Number',
                                value: _patientController
                                    .patient.value.phoneNumber!),
                            _patientInfoRow(
                                title: "Nationality",
                                value: _patientController
                                    .patient.value.nationality!),
                            _patientInfoRow(
                                title: 'Family Situation',
                                value: _patientController
                                        .patient.value.familySituation ??
                                    'No Family Situation'),
                            _patientInfoRow(
                                title: 'Emergency Contact Phone Number',
                                value: _patientController
                                        .patient.value.emergencyContactName ??
                                    'No Emergency Contact',
                                titleColor: Colors.redAccent),
                            _patientInfoRow(
                                title: 'Emergency Contact Phone Number',
                                value: _patientController
                                        .patient.value.emergencyContactNumber ??
                                    'No Emergency Contact',
                                titleColor: Colors.redAccent),
                          ],
                        ),
                      ),
                    ),
                    _patientController.medicalRecords.isEmpty
                        ? Center(
                            child:
                                //button to add new medical record
                                TextButton(
                              onPressed: addMedicalRecord,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(12),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Add Medical Record',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        : Scaffold(
                            body: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      final medicalRecord = _patientController
                                          .medicalRecords[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ExpansionTile(
                                          title: Row(
                                            children: [
                                              Text(
                                                medicalRecord.patientEntryDate
                                                    .toString()
                                                    .substring(0, 10),
                                              ),
                                              const SizedBox(width: 8),
                                              medicalRecord
                                                          .patientLeavingDate ==
                                                      null
                                                  ? const Text(
                                                      "Active",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  : Text(
                                                      " =>   ${medicalRecord.patientLeavingDate!.toString().substring(0, 10)}",
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            children: [
                                              const Text("Doctor: "),
                                              Text(
                                                medicalRecord.doctorName!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: medicalRecord.userId
                                                                .toString() ==
                                                            _authController
                                                                .user['id']
                                                                .toString()
                                                        ? Colors.green
                                                        : Colors.black),
                                              ),
                                            ],
                                          ),
                                          children: <Widget>[
                                            const Divider(
                                              height: 0.5,
                                              thickness: 0.2,
                                              color: Colors.grey,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "State upon enter: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      medicalRecord
                                                          .stateUponEnter!,
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            medicalRecord.stateUponExit != null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "State upon Exit: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            medicalRecord
                                                                .stateUponExit!,
                                                            softWrap: true,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),

                                            const SizedBox(
                                              height: 8,
                                            ),
                                            //
                                            // a blue button to open medical record in new page with all the details
                                            //

                                            ElevatedButton(
                                              onPressed: () {
                                                // print(
                                                //     "going to medical record page");
                                                Get.toNamed(
                                                    "/medical-record-details",
                                                    arguments: {
                                                      "patientId":
                                                          _patientController
                                                              .patient.value.id,
                                                      "medicalRecordId":
                                                          medicalRecord.id
                                                    });
                                              },
                                              child: const Text("View Details"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: _patientController
                                        .medicalRecords.length,
                                  ),
                                )
                              ],
                            ),
                            floatingActionButton: _authController.isDoctor() ? FloatingActionButton(
                              onPressed: addMedicalRecord,
                              child: const Icon(Icons.add),
                            ) : null,
                          ),
                  ],
                ),
        ),
      ),
    );
  }

  void addMedicalRecord() {
    Get.toNamed('/add-medical-record',
            arguments: _patientController.patient.value)
        ?.then((value) {
      print('returned from add medical record page');
      _patientController.refresh();
    });
  }

  Column _patientInfoRow(
      {required String title,
      required String value,
      Color? titleColor = Colors.grey}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
