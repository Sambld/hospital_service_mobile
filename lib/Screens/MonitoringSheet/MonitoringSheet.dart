import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Services/Api.dart';
import 'package:intl/intl.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/MonitoringSheet/MonitoringSheetController.dart';
import 'UpdateMonitoringSheetBottomSheet.dart';

class MonitoringSheetScreen extends StatelessWidget {
  final controller = Get.put(MonitoringSheetController());

  final authController = Get.find<AuthController>();

  MonitoringSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
            flexibleSpace: kAppBarColor,
            title: Text(
              '${"Monitoring Sheet".tr} ',
              style: const TextStyle(fontSize: 16),
            )),
        body: controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : controller.monitoringSheetList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Monitoring Sheet found".tr),
                        const SizedBox(
                          height: 10,
                        ),
                        controller.medicalRecord.value.userId ==
                                    authController.user['id'] &&
                                !controller.medicalRecord.value.isClosed()
                            ? ElevatedButton(
                                onPressed: () {
                                  Get.toNamed(
                                    '/add-monitoring-sheet',
                                    // pass the last monitoring sheet day of the list to the next screen
                                    arguments: DateTime.now()
                                        .subtract(const Duration(days: 1)),
                                  );
                                },
                                child: const Text("Create new"))
                            : Container(),
                      ],
                    ),
                  )
                : Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Obx(
                                  () => infoCard([
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${"Medical Record".tr} : ",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            "#${controller.medicalRecord.value.id}"),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${"Patient".tr} : ",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            "${controller.patient.value.firstName} ${controller.patient.value.lastName} #${controller.patient.value.id}"),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${"Doctor".tr} : ".tr,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            "${controller.currentMonitoringSheet.value.doctor?.fullName()} #${controller.currentMonitoringSheet.value.doctor?.id} ${authController.user['id'] == controller.currentMonitoringSheet.value.doctor?.id ? "( ${"You".tr} )" : ""}"),
                                      ],
                                    ),
                                  ], Colors.green),
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed:
                                        controller.isFirstMonitoringSheet()
                                            ? null
                                            : () {
                                                controller
                                                    .previousMonitoringSheet();
                                              },
                                    icon: const Icon(
                                      Icons.arrow_left,
                                      size: 25,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    children: [
                                      Text(
                                        "${controller.currentMonitoringSheet.value.fillingDate.toString().substring(0, 10)} ( ${DateFormat('yyyy-MM-dd').format(DateTime.now()) == controller.currentMonitoringSheet.value.fillingDate.toString().substring(0, 10) ? "Today".tr :
                                            // show only three character of the day name
                                            DateFormat('EEE').format(DateTime.parse(controller.currentMonitoringSheet.value.fillingDate.toString().substring(0, 10))).substring(0, 3).tr} )",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(width: 3),
                                      // time of the monitoring sheet
                                      Text(
                                        controller.currentMonitoringSheet.value.fillingDate.toString().substring(11, 16),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    onPressed: controller
                                            .isLastMonitoringSheet()
                                        ? null
                                        : () {
                                            controller.nextMonitoringSheet();
                                          },
                                    icon: const Icon(
                                      Icons.arrow_right,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                              controller.currentMonitoringSheet.value.filledBy?.isNotEmpty ??
                                      false
                                  ? (
                                                  authController.isDoctor() ||
                                  authController.user['id'] == controller.currentMonitoringSheet.value.filledById) &&
                                          !controller.medicalRecord.value
                                              .isClosed() &&
                                          controller.currentMonitoringSheet.value.isToday()
                                      ?
                                      // if the monitoring sheet is filled by the current user , a button to update it
                                      Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12.0),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return const UpdateMonitoringSheetBottomSheet();
                                                            },
                                                            isScrollControlled:
                                                                true);
                                                      },
                                                      child: Text("Update".tr),
                                                    ),
                                                  ),
                                                ),
                                                // a icon button to delete the monitoring sheet
                                                controller.medicalRecord.value
                                                                .userId ==
                                                            authController
                                                                .user['id'] &&
                                                        !controller
                                                            .medicalRecord.value
                                                            .isClosed()
                                                    ? IconButton(
                                                        onPressed: deleteDay,
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                            filledByCard()
                                          ],
                                        )
                                      :
                                      // if the monitoring sheet is filled by another user , text to show who filled it
                                      filledByCard()
                                  : controller.medicalRecord.value.userId == authController.user['id'] &&
                                          (controller.currentMonitoringSheet.value.filledBy?.isNotEmpty ??
                                              false)
                                      ? Row(
                                          children: [
                                            filledByCard(),
                                          ],
                                        )
                                      :
                                      // delete button
                                      controller.currentMonitoringSheet.value.doctor!.id ==
                                                  authController.user['id'] &&
                                              !controller.medicalRecord.value.isClosed()
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12.0),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                      onPressed: deleteDay,
                                                      child: Text("Delete".tr),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                              // if the monitoring sheet is not filled yet , a button to fill it
                              controller.currentMonitoringSheet.value.filledById ==
                                          null &&
                                      authController.isNurse() &&
                                      !controller.medicalRecord.value
                                          .isClosed() &&
                                      DateFormat('yyyy-MM-dd')
                                              .format(DateTime.now())
                                              .toString() ==
                                          controller.currentMonitoringSheet
                                              .value.fillingDate
                                              .toString()
                                              .substring(0, 10)
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: ElevatedButton(
                                              // blue thin border

                                              onPressed: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return const UpdateMonitoringSheetBottomSheet();
                                                    },
                                                    isScrollControlled: true);
                                              },
                                              child: Text("Fill".tr),
                                            ),
                                          ),
                                        ),
                                        controller.medicalRecord.value
                                                        .userId ==
                                                    authController.user['id'] &&
                                                !controller.medicalRecord.value
                                                    .isClosed()
                                            ? IconButton(
                                                onPressed: deleteDay,
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  : Container(),

                              GestureDetector(
                                onHorizontalDragEnd: (DragEndDetails details) {
                                  if (details.primaryVelocity! > 0) {
                                    // User swiped Left
                                    controller.previousMonitoringSheet();
                                  } else if (details.primaryVelocity! < 0) {
                                    // User swiped Right
                                    controller.nextMonitoringSheet();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DataTable(
                                    dataRowHeight: 50,
                                    columnSpacing: 50,
                                    columns: <DataColumn>[
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            '${"Checkup".tr} #${controller.currentMonitoringSheet.value.id}',
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Result'.tr,
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: <DataRow>[
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                            Text('${'Temperature'.tr} (°C)',
                                                style: Styles.type,
                                                textAlign: TextAlign.center),
                                          ),
                                          DataCell(controller
                                                      .currentMonitoringSheet
                                                      .value
                                                      .temperature !=
                                                  null
                                              ? Text(
                                                  "${controller.currentMonitoringSheet.value.temperature}",
                                                  style: Styles.result,
                                                )
                                              : Chip(
                                                  label: Text(
                                                    'Empty'.tr,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                  backgroundColor:
                                                      Colors.deepOrangeAccent,
                                                )),
                                        ],
                                      ),
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(
                                            '${'Blood Pressure'.tr} (mmHg)',
                                            style: Styles.type,
                                          )),
                                          DataCell(
                                            controller.currentMonitoringSheet
                                                        .value.bloodPressure !=
                                                    null
                                                ? Text(
                                                    "${controller.currentMonitoringSheet.value.bloodPressure}",
                                                    style: Styles.result,
                                                  )
                                                : Chip(
                                                    label: Text(
                                                      'Empty'.tr,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                    backgroundColor:
                                                        Colors.deepOrangeAccent,
                                                  ),
                                          ),
                                        ],
                                      ),
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(
                                            '${'Urine'.tr} (ml)',
                                            style: Styles.type,
                                          )),
                                          DataCell(
                                            controller.currentMonitoringSheet
                                                        .value.urine !=
                                                    null
                                                ? Text(
                                                    "${controller.currentMonitoringSheet.value.urine}",
                                                    style: Styles.result,
                                                  )
                                                : Chip(
                                                    label: Text(
                                                      'Empty'.tr,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                    backgroundColor:
                                                        Colors.deepOrangeAccent,
                                                  ),
                                          ),
                                        ],
                                      ),
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(
                                            '${'Weight'.tr} (Kg)',
                                            style: Styles.type,
                                          )),
                                          DataCell(
                                            controller.currentMonitoringSheet
                                                        .value.weight !=
                                                    null
                                                ? Text(
                                                    "${controller.currentMonitoringSheet.value.weight}",
                                                    style: Styles.result,
                                                  )
                                                : Chip(
                                                    label: Text(
                                                      'Empty'.tr,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                    backgroundColor:
                                                        Colors.deepOrangeAccent,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              controller.currentMonitoringSheet.value
                                          .progressReport?.isEmpty ??
                                      true
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: infoCard([
                                        Text(
                                          "Report".tr,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          // textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          controller.currentMonitoringSheet
                                                  .value.progressReport ??
                                              "-",
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                          // textAlign: TextAlign.center,
                                        ),
                                      ], Colors.blue, vMargin: 0.0),
                                    ),

                              const SizedBox(
                                height: 20,
                              ),

                              // update treatment button

                              // table of monitoring sheet treatments
                              controller.currentMonitoringSheet.value
                                          .treatments?.isEmpty ??
                                      true
                                  ? Container()
                                  : ExpansionTile(
                                      title: Center(
                                        child: Text(
                                          "Treatments".tr,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              DataTable(
                                                dataRowHeight: 50,
                                                columnSpacing: 50,
                                                columns: <DataColumn>[
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Treatment'.tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Dose'.tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Type'.tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                rows: controller
                                                    .currentMonitoringSheet
                                                    .value
                                                    .treatments!
                                                    .map(
                                                      (e) => DataRow(
                                                        cells: <DataCell>[
                                                          DataCell(Text(
                                                            e.name!,
                                                            style: Styles.type,
                                                          )),
                                                          DataCell(Text(
                                                            e.dose!,
                                                            style:
                                                                Styles.result,
                                                          )),
                                                          DataCell(Text(
                                                            e.type!,
                                                            style: Styles.type,
                                                          )),
                                                        ],
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),

                                          authController.isDoctor() &&
                                      !controller.medicalRecord.value
                                          .isClosed()&&
                                              controller.currentMonitoringSheet.value.isToday()



                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              onPressed: () {
                                                Get.toNamed(
                                                        '/update-monitoring-sheet-treatments')
                                                    ?.then((value) => controller
                                                        .getMonitoringSheets());
                                              },
                                              child: controller
                                                          .currentMonitoringSheet
                                                          .value
                                                          .treatments
                                                          ?.isNotEmpty ??
                                                      true
                                                  ? Text("Update Treatments".tr)
                                                  : Text("Add treatments".tr),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 60,
                              ),
                              Container()
                            ],
                          )
                        ],
                      ),
                      // monitoring sheet treatments list
                    ),
                    floatingActionButton:

                                    authController.isDoctor() &&
                                !controller.medicalRecord.value.isClosed()
                            ? FloatingActionButton(
                                onPressed: () {
                                  Get.toNamed(
                                    '/add-monitoring-sheet',
                                    // pass the last monitoring sheet day of the list to the next screen
                                    arguments: controller
                                        .monitoringSheetList.last.fillingDate,
                                  )?.then((value) {
                                    controller.currentMonitoringSheetIndex(
                                        controller.monitoringSheetList.length);
                                  });
                                },
                                child: const Icon(Icons.add),
                              )
                            : Container(),
                  ),
      ),
    );
  }

  void deleteDay() {
    Get.defaultDialog(
        title: "Delete".tr,
        middleText: "Are you sure you want to delete this day?".tr,
        textConfirm: "Yes".tr,
        textCancel: "No".tr,
        confirmTextColor: Colors.white,
        cancelTextColor: Colors.redAccent,
        buttonColor: Colors.red,
        backgroundColor: Colors.white,
        onConfirm: () async {
          await Api.deleteMonitoringSheetDay(
              controller.patientId.value,
              controller.medicalRecordId.value,
              controller.currentMonitoringSheet.value.id!);
          // controller.currentMonitoringSheetIndex.value--;
          controller.getMonitoringSheets();
          Get.back();
        });
  }

  Padding filledByCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: infoCard(
        [
          Row(
            children: [
              Text(
                "${"Filled by".tr} : ",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                  "${controller.currentMonitoringSheet.value.filledBy!['first_name']} ${controller.currentMonitoringSheet.value.filledBy!['last_name']}"),
            ],
          )
        ],
        Colors.redAccent,
        vMargin: 0.0,
      ),
    );
  }

  Card infoCard(children, color, {vMargin = 12.0}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: vMargin),
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
                color: color,
                width: 4.0,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children ?? [],
          ),
        ),
      ),
    );
  }
}

class Styles {
  static const TextStyle type = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle result = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}
