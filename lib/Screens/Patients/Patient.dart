import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/Patient/PatientController.dart';

class PatientScreen extends StatelessWidget {
  PatientScreen({Key? key}) : super(key: key);

  final _patientController = Get.put(PatientController());

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 3,
            bottom: TabBar(
              tabs: [
                 Tab(
                  child: Text('Information'.tr),
                ),
                Tab(child: Text('Medical Records'.tr)),
              ],
            ),
            actions: [
              //edit button
              _authController.isDoctor()
                  ? IconButton(
                      onPressed: () {
                        Get.toNamed('/edit-patient',
                                arguments: _patientController.patient.value)
                            ?.then((value) => _patientController.getPatient());
                      },
                      icon: const Icon(Icons.edit),
                    )
                  : Container(),
            ],
            // backgroundColor: Colors.transparent,
            title: Text(
              '${'Patient Details'.tr}(#${_patientController.patient.value.id})',
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
                                title: "Name".tr,
                                value:
                                    '${_patientController.patient.value.firstName} ${_patientController.patient.value.lastName}'),
                            _patientInfoRow(
                              title: 'Gender'.tr,
                              value: _patientController.patient.value.gender!,
                            ),
                            $(_patientInfoRow(
                              title: 'Birth Date'.tr,
                              value: _patientController.patient.value.birthDate!
                                  .toString()
                                  .substring(0, 10),
                            )),
                            $(_patientInfoRow(
                                title: 'Place of Birth'.tr,
                                value: _patientController
                                    .patient.value.placeOfBirth!)),
                            $(_patientInfoRow(
                                title: 'Address'.tr,
                                value:
                                    _patientController.patient.value.address!)),
                            $(_patientInfoRow(
                                title: 'Phone Number'.tr,
                                value: _patientController
                                    .patient.value.phoneNumber!,
                                isPhoneNumber: true)),
                            $(_patientInfoRow(
                                title: "Nationality".tr,
                                value: _patientController
                                    .patient.value.nationality!)),
                            $(_patientInfoRow(
                                title: 'Family Situation'.tr,
                                value: _patientController
                                        .patient.value.familySituation ??
                                    'No Family Situation'.tr)),
                            _patientInfoRow(
                                title: 'Emergency Contact Phone Number'.tr,
                                value: _patientController
                                        .patient.value.emergencyContactName ??
                                    'No Emergency Contact'.tr,
                                titleColor: Colors.redAccent),
                            _patientInfoRow(
                                title: 'Emergency Contact Name'.tr,
                                value: _patientController
                                        .patient.value.emergencyContactNumber ??
                                    'No Emergency Contact'.tr,
                                titleColor: Colors.redAccent,
                                isPhoneNumber: _patientController.patient.value
                                        .emergencyContactNumber?.isNotEmpty ??
                                    false),
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
                              child: Text(
                                'Add Medical Record'.tr,
                                style: const TextStyle(
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
                                // a switch toggle for active medical records and closed ones
                                SwitchListTile(
                                  title: Text("Show only active records".tr),
                                  value: _patientController.recordsFilter.value,
                                  onChanged: (value) {
                                    _patientController.recordsFilter.value =
                                        value;
                                    _patientController.filterRecords();
                                  },
                                ),

                                Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      final medicalRecord = _patientController
                                          .filteredMedicalRecords[index];
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
                                                  ? Text(
                                                      "Active".tr,
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  : Text(
                                                      " =>   ${medicalRecord.patientLeavingDate!.toString().substring(0, 10)} ( ${"Closed".tr} )",
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text("${"Doctor".tr}: ".tr),
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
                                                  Text(
                                                    "${"State Upon Enter".tr}: ",
                                                    style: const TextStyle(
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
                                                        Text(
                                                          "${"State Upon Exit".tr}: ",
                                                          style: const TextStyle(
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
                                              child: Text("View Details".tr),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: _patientController
                                        .filteredMedicalRecords.length,
                                  ),
                                )
                              ],
                            ),
                            floatingActionButton: _authController.isDoctor()
                                ? FloatingActionButton(
                                    onPressed: addMedicalRecord,
                                    child: const Icon(Icons.add),
                                  )
                                : null,
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
        ;
  }

  Widget $(child) {
    return Obx(() {
      if (_authController.isNurse()) {
        return Container();
      } else {
        return child;
      }
    });
  }

  Column _patientInfoRow({
    required String title,
    required String value,
    Color? titleColor = Colors.grey,
    bool isPhoneNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (isPhoneNumber)
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          // handle call action here
                          launchUrlString("tel:$value");
                        },
                      ),
                    ),
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
