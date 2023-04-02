import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Screens/Patients/EditPatient.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/Patients/PatientController.dart';

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
              IconButton(
                onPressed: () {
                  Get.toNamed('/edit-patient',
                          arguments: _patientController.patient.value)
                      ?.then((value) => _patientController.getPatient());
                  print('edit button pressed');
                },
                icon: const Icon(Icons.edit),
              ),
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
                            const Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_patientController.patient.value.firstName} ${_patientController.patient.value.lastName}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Gender',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_patientController.patient.value.gender}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Birth Date',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _patientController.patient.value.birthDate
                                  .toString()
                                  .substring(0, 10),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Place of Birth',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_patientController.patient.value.placeOfBirth}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Address',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_patientController.patient.value.address}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Phone Number',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_patientController.patient.value.phoneNumber}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Nationality',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_patientController.patient.value.nationality}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Family Situation',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _patientController
                                      .patient.value.familySituation ??
                                  'No Family Situation',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Emergency Contact Name',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _patientController
                                      .patient.value.emergencyContactName ??
                                  'No Emergency Contact',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Emergency Contact Phone Number',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _patientController
                                      .patient.value.emergencyContactNumber ??
                                  'No Emergency Contact',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                    _patientController.medicalRecords.isEmpty
                        ? Center(
                            child:
                                //button to add new medical record
                                TextButton(
                              onPressed: () {
                                print("add new medical record");
                              },
                              child: const Text(
                                'Add Medical Record',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(12)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
                                                      " =>   " +
                                                          medicalRecord
                                                              .patientLeavingDate!
                                                              .toString()
                                                              .substring(0, 10),
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    ),
                                            ],
                                          ),
                                          subtitle: Row(children: [
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
                                          ]),
                                          children: <Widget>[
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
                                                print(
                                                    "going to medical record page");
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
                            floatingActionButton: FloatingActionButton(
                              onPressed: () {
                                print("add new medical record");
                              },
                              child: const Icon(Icons.add),
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
