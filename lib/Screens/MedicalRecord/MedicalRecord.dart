import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Constants/Constants.dart';
import 'package:infectious_diseases_service/Utils/Functions.dart';
import 'package:infectious_diseases_service/Utils/ResponsiveFontSizes.dart';
import '../../Controllers/MedicalRecord/MedicalRecordController.dart';
import '../../Widgets/MedicalRecordSecondTab.dart';

class MedicalRecordScreen extends StatefulWidget {
  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  final _controller = Get.put(MedicalRecordController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: kAppBarColor,
            title: Text(
                '${"Medical Record".tr} (#${_controller.medicalRecord.value.id ?? "0"})'),
            bottom:  TabBar(
              tabs: [
                Tab(child: Text("Informations")),
                Tab(icon: Text("Other".tr)),
              ],
            ),
            actions: [
              !_controller.isLoading.value &&
                      (_controller.medicalRecord.value.canEdit ??
                          false) && !_controller.medicalRecord.value.isClosed()
                  ? IconButton(
                      onPressed: () {
                        Get.toNamed('/edit-medical-record', arguments: {
                          "patient": _controller.patient.value,
                          "medicalRecord":
                              _controller.medicalRecord.value
                        })?.then((value) => _controller.getMedicalRecord());
                      },
                      icon: const Icon(Icons.edit),
                    )
                  : Container(),
            ],
          ),
          body: _controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                         Text(
                                          "${"Patient".tr} : ",
                                          style:  TextStyle(
                                            fontSize: ResponsiveFontSize.medium(),
                                          ),
                                        ),
                                        Text(
                                          // "a sdfas df ",
                                          "${_controller.patient.value.firstName!} ${_controller.patient.value.lastName!}",
                                          style:  TextStyle(
                                            fontSize:  ResponsiveFontSize.medium(),
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          // "Age",
                                          "( ${"Age".tr} ${Functions.calculateAge(_controller.patient.value.birthDate!)})",
                                          style:  TextStyle(
                                            fontSize:  ResponsiveFontSize.small(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                          "${"Doctor".tr}: ",
                                          style:  TextStyle(
                                            fontSize:  ResponsiveFontSize.medium(),
                                          ),
                                        ),
                                        Text(
                                          // "doctor name",
                                          _controller
                                              .medicalRecord.value.doctorName!,
                                          style:  TextStyle(
                                            fontSize:  ResponsiveFontSize.medium(),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                          "${"Status".tr}: ",
                                          style:  TextStyle(
                                            fontSize: ResponsiveFontSize.medium(),
                                          ),
                                        ),
                                        _controller.medicalRecord
                                                    .value.patientLeavingDate ==
                                                null
                                            ?  Text(
                                                // "doctor name",
                                                "Active".tr,
                                                style:  TextStyle(
                                                  fontSize: ResponsiveFontSize.medium(),
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green,
                                                ),
                                              )
                                            :  Text(
                                                // "doctor name",
                                                "Closed".tr,
                                                style: TextStyle(
                                                    fontSize: ResponsiveFontSize.medium(),
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
                                title: 'Patient Entering Date'.tr,
                                value: _controller
                                    .medicalRecord.value.patientEntryDate!
                                    .toString()
                                    .substring(0, 10)),
                            // value: '2021-01-01',

                            _medicalRecordInfoRow(
                              context,
                              title: 'Medical Specialty'.tr,
                              value: _controller
                                  .medicalRecord.value.medicalSpecialty!,
                              // value: "Cardiology"
                            ),
                            _medicalRecordInfoRow(
                              context,
                              title: 'Condition Description'.tr,
                              value: _controller
                                  .medicalRecord.value.conditionDescription!,
                              // value:"Cardiac Arrest",
                            ),
                            _medicalRecordInfoRow(
                              context,
                              title: 'Standard Treatment'.tr,
                              value: _controller
                                  .medicalRecord.value.standardTreatment!,
                              // value: "Cardiac Arrest",
                            ),
                            _medicalRecordInfoRow(
                              context,
                              title: 'State Upon Enter'.tr,
                              value: _controller
                                  .medicalRecord.value.stateUponEnter!,
                              // value: "kljsdf",
                            ),

                            _medicalRecordInfoRow(
                              context,
                              title: 'Bed Number'.tr,
                              value: _controller
                                  .medicalRecord.value.bedNumber!
                                  .toString(),
                            ),
                            _controller
                                        .medicalRecord.value.stateUponExit !=
                                    null
                                ? _medicalRecordInfoRow(context,
                                    title: 'State Upon Exit'.tr,
                                    value: 'Recovered',
                                    borderColor: Colors.redAccent)
                                : Container(),
                            _controller.medicalRecord.value
                                        .patientLeavingDate !=
                                    null
                                ? _medicalRecordInfoRow(context,
                                    title: 'Patient Leaving Date'.tr,
                                    value: '2022-01-01',
                                    borderColor: Colors.redAccent)
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    SecondTab(),
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
                style:  TextStyle(
                  fontSize: ResponsiveFontSize.medium(),
                  fontWeight: FontWeight.w600,
                ),
                // textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                value!,
                style:  TextStyle(
                  fontSize: ResponsiveFontSize.small(),
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
