import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:infectious_diseases_service/Utils/Functions.dart';
import '../../Controllers/MedicalRecord/MedicalRecordController.dart';

class MedicalRecordScreen extends StatefulWidget {
  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  final _medicalRecordController = Get.put(MedicalRecordController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Medical Record'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _medicalRecordController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Patient : ",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  // "a sdfas df ",
                                  "${_medicalRecordController.patient.value.firstName!} ${_medicalRecordController.patient.value.lastName!}",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  // "Age",
                                  "( Age ${Functions.calculateAge(_medicalRecordController.patient.value.birthDate!)})",
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Doctor: ",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  // "doctor name",
                                  _medicalRecordController
                                      .medicalRecord.value.doctorName!,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "status: ",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                _medicalRecordController.medicalRecord.value
                                            .patientLeavingDate ==
                                        null
                                    ? const Text(
                                        // "doctor name",
                                        "Active",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                      )
                                    : const Text(
                                        // "doctor name",
                                        "Closed",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    const Divider(),
                    _medicalRecordInfoRow(context,
                        title: 'Patient Entering Date',
                        value: _medicalRecordController
                            .medicalRecord.value.patientEntryDate!
                            .toString()
                            .substring(0, 10)),
                    // value: '2021-01-01',

                    _medicalRecordInfoRow(
                      context,
                      title: 'Medical Specialty',
                      value: _medicalRecordController
                          .medicalRecord.value.medicalSpecialty!,
                      // value: "Cardiology"
                    ),
                    _medicalRecordInfoRow(
                      context,
                      title: 'Condition Description',
                      value: _medicalRecordController
                          .medicalRecord.value.conditionDescription!,
                      // value:"Cardiac Arrest",
                    ),
                    _medicalRecordInfoRow(
                      context,
                      title: 'Standard Treatment',
                      value: _medicalRecordController
                          .medicalRecord.value.standardTreatment!,
                      // value: "Cardiac Arrest",
                    ),
                    _medicalRecordInfoRow(
                      context,
                      title: 'State Upon Enter',
                      value: _medicalRecordController
                          .medicalRecord.value.stateUponEnter!,
                      // value: "kljsdf",
                    ),

                    _medicalRecordInfoRow(
                      context,
                      title: 'Bed Number',
                      value: _medicalRecordController
                          .medicalRecord.value.bedNumber!
                          .toString(),
                    ),
                    _medicalRecordController
                                .medicalRecord.value.stateUponExit !=
                            null
                        ? _medicalRecordInfoRow(context,
                            title: 'State Upon Exit',
                            value: 'Recovered',
                            borderColor: Colors.redAccent)
                        : Container(),
                    _medicalRecordController
                                .medicalRecord.value.patientLeavingDate !=
                            null
                        ? _medicalRecordInfoRow(context,
                            title: 'Patient Leaving Date',
                            value: '2022-01-01',
                            borderColor: Colors.redAccent)
                        : Container(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _medicalRecordInfoRow(BuildContext context,
      {String? title, String? value, Color? borderColor = Colors.blue}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: borderColor!,
                width: 4.0,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
                // textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                value!,
                style: const TextStyle(
                  fontSize: 13.0,
                ),
                // textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
