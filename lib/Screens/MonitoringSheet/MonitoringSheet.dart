import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Services/Api.dart';
import 'package:intl/intl.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/MonitoringSheet/MonitoringSheetController.dart';
import 'UpdateMonitoringSheetBottomSheet.dart';

class MonitoringSheetScreen extends StatefulWidget {
  @override
  _MonitoringSheetScreenState createState() => _MonitoringSheetScreenState();
}

class _MonitoringSheetScreenState extends State<MonitoringSheetScreen> {
  final _controller = Get.put(MonitoringSheetController());
  final authController = Get.find<AuthController>();

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
            flexibleSpace: kAppBarColor,
            title: Text(
              '${"Monitoring Sheet".tr}   ${_controller.monitoringSheetList.value.isNotEmpty ? "( " + _controller.monitoringSheetList.length.toString() + " days )" : ""}',
              style: const TextStyle(fontSize: 16),
            )),
        body: _controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _controller.monitoringSheetList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text("No Monitoring Sheet found".tr),
                        const SizedBox(
                          height: 10,
                        ),
                        _controller.medicalRecord.value.userId ==
                                authController.user['id'] && !_controller.medicalRecord.value.isClosed()
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
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            "#${_controller.medicalRecord.value.id}"),
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
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            "${_controller.patient.value.firstName} ${_controller.patient.value.lastName} #${_controller.patient.value.id}"),
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
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            "${_controller.medicalRecord.value.doctorName}"),
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
                                    onPressed: _controller
                                            .isFirstMonitoringSheet()
                                        ? null
                                        : () {
                                            _controller
                                                .previousMonitoringSheet();
                                          },
                                    icon: const Icon(
                                      Icons.arrow_left,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    "${_controller.currentMonitoringSheet.value.fillingDate.toString().substring(0, 10)} (${DateFormat('yyyy-MM-dd').format(DateTime.now()) == _controller.currentMonitoringSheet.value.fillingDate.toString().substring(0, 10) ? "Today".tr :
                                        // show only three caracter of the day name
                                        DateFormat('EEE').format(DateTime.parse(_controller.currentMonitoringSheet.value.fillingDate.toString().substring(0, 10))).substring(0, 3)})",
                                    style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    onPressed: _controller
                                            .isLastMonitoringSheet()
                                        ? null
                                        : () {
                                            _controller
                                                .nextMonitoringSheet();
                                          },
                                    icon: const Icon(
                                      Icons.arrow_right,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                              _controller.currentMonitoringSheet
                                          .value.filledBy?.isNotEmpty ??
                                      false
                                  ? ( _controller
                                                  .currentMonitoringSheet
                                                  .value
                                                  .filledById ==
                                              authController.user.value['id'] ||
                                          _controller
                                                  .medicalRecord.value.userId ==
                                              authController.user.value['id']) &&  !_controller.medicalRecord.value.isClosed()
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
                                                      child:
                                                           Text("Update".tr),
                                                    ),
                                                  ),
                                                ),
                                                // a icon button to delete the monitoring sheet
                                                _controller
                                                            .medicalRecord
                                                            .value
                                                            .userId ==
                                                        authController
                                                            .user['id']  && !_controller.medicalRecord.value.isClosed()
                                                    ? IconButton(
                                                        onPressed: DeleteDay,
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
                                  : _controller
                                                  .medicalRecord.value.userId ==
                                              authController.user.value['id'] &&
                                          (_controller
                                                  .currentMonitoringSheet
                                                  .value
                                                  .filledBy
                                                  ?.isNotEmpty ??
                                              false)
                                      ? Row(
                                          children: [
                                            filledByCard(),
                                          ],
                                        )
                                      :
                                      // delete button
                                      _controller
                                                  .medicalRecord.value.userId ==
                                              authController.user.value['id']  && !_controller.medicalRecord.value.isClosed()
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
                                                      onPressed: DeleteDay,
                                                      child:
                                                           Text("Delete".tr),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                              // if the monitoring sheet is not filled yet , a button to fill it
                              _controller.currentMonitoringSheet
                                              .value.filledById ==
                                          null &&
                                      authController.isNurse()  && !_controller.medicalRecord.value.isClosed()
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
                                              child:  Text("Fill".tr),
                                            ),
                                          ),
                                        ),
                                        _controller.medicalRecord
                                                    .value.userId ==
                                                authController.user['id']  && !_controller.medicalRecord.value.isClosed()
                                            ? IconButton(
                                                onPressed: DeleteDay,
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  : Container(),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DataTable(
                                  dataRowHeight: 50,
                                  columnSpacing: 50,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          '${"Checkup".tr} #${_controller.currentMonitoringSheet.value.id}',
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Result'.tr,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: <DataRow>[
                                    DataRow(
                                      cells: <DataCell>[
                                         DataCell(
                                          Text('Temperature'.tr,
                                              style: Styles.type,
                                              textAlign: TextAlign.center),
                                        ),
                                        DataCell(_controller
                                                    .currentMonitoringSheet
                                                    .value
                                                    .temperature !=
                                                null
                                            ? Text(
                                                "${_controller.currentMonitoringSheet.value.temperature}°C",
                                                style: Styles.result,
                                              )
                                            :  Chip(
                                                label: Text(
                                                  'Empty'.tr,
                                                  style: TextStyle(
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
                                          'Blood Pressure'.tr,
                                          style: Styles.type,
                                        )),
                                        DataCell(
                                          _controller
                                                      .currentMonitoringSheet
                                                      .value
                                                      .bloodPressure !=
                                                  null
                                              ? Text(
                                                  "${_controller.currentMonitoringSheet.value.bloodPressure}",
                                                  style: Styles.result,
                                                )
                                              :  Chip(
                                                  label: Text(
                                                    'Empty'.tr,
                                                    style: TextStyle(
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
                                          'Urine'.tr,
                                          style: Styles.type,
                                        )),
                                        DataCell(
                                          _controller
                                                      .currentMonitoringSheet
                                                      .value
                                                      .urine !=
                                                  null
                                              ? Text(
                                                  "${_controller.currentMonitoringSheet.value.urine}",
                                                  style: Styles.result,
                                                )
                                              :  Chip(
                                                  label: Text(
                                                    'Empty'.tr,
                                                    style: TextStyle(
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
                                          'Weight'.tr,
                                          style: Styles.type,
                                        )),
                                        DataCell(
                                          _controller
                                                      .currentMonitoringSheet
                                                      .value
                                                      .weight !=
                                                  null
                                              ? Text(
                                                  "${_controller.currentMonitoringSheet.value.weight} Kg",
                                                  style: Styles.result,
                                                )
                                              :  Chip(
                                                  label: Text(
                                                    'Empty'.tr,
                                                    style: TextStyle(
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
                              _controller.currentMonitoringSheet
                                          .value.progressReport?.isEmpty ??
                                      true
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: infoCard([
                                         Text(
                                          "Report".tr,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          // textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          _controller
                                                  .currentMonitoringSheet
                                                  .value
                                                  .progressReport ??
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
                              _controller.currentMonitoringSheet
                                          .value.treatments?.isEmpty ??
                                      true
                                  ? Container()
                                  : ExpansionTile(
                                      title:  Center(
                                        child: Text(
                                          "Treatments".tr,
                                          style: TextStyle(fontSize: 20),
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
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Dose'.tr,
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Type'.tr,
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                rows: _controller
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
                              _controller
                                  .medicalRecord.value.userId ==
                                  authController.user.value['id']  && !_controller.medicalRecord.value.isClosed()
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
                                              ?.then((value) =>
                                              _controller
                                                  .getMonitoringSheets());
                                        },
                                        child: _controller
                                            .currentMonitoringSheet
                                            .value
                                            .treatments
                                            ?.isNotEmpty ??
                                            true
                                            ?  Text("Update Treatments".tr)
                                            :  Text("Add treatments".tr),
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
                        _controller.medicalRecord.value.userId ==
                                authController.user['id'] && !_controller.medicalRecord.value.isClosed()
                            ? FloatingActionButton(
                                onPressed: () {
                                  Get.toNamed(
                                    '/add-monitoring-sheet',
                                    // pass the last monitoring sheet day of the list to the next screen
                                    arguments: _controller
                                        .monitoringSheetList.last.fillingDate,
                                  )?.then((value) {
                                    _controller
                                        .currentMonitoringSheetIndex(
                                            _controller
                                                .monitoringSheetList.length);
                                  });
                                },
                                child: const Icon(Icons.add),
                              )
                            : Container(),
                  ),
      ),
    );
  }

  void DeleteDay() {
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
              _controller.patientId.value,
              _controller.medicalRecordId.value,
              _controller.currentMonitoringSheet.value.id!);
          // _controller.currentMonitoringSheetIndex.value--;
          _controller.getMonitoringSheets();
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                  "${_controller.currentMonitoringSheet.value.filledBy!['first_name']} ${_controller.currentMonitoringSheet.value.filledBy!['last_name']}"),
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
