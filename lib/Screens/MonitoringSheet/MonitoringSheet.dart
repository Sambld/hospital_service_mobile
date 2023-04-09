import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Screens/MonitoringSheet/AddMonitoringSheetDay.dart';
import 'package:infectious_diseases_service/Services/Api.dart';
import 'package:infectious_diseases_service/Widgets/GlobalWidgets.dart';
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
  final _monitoringSheetController = Get.put(MonitoringSheetController());
  final authController = Get.find<AuthController>();

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
            flexibleSpace: kAppBarColor,
            title: Text(
              'Monitoring Sheet   ${_monitoringSheetController.monitoringSheetList.value.isNotEmpty ? "( " + _monitoringSheetController.monitoringSheetList.length.toString() + " days )" : ""}',
              style: const TextStyle(fontSize: 16),
            )),
        body: _monitoringSheetController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _monitoringSheetController.monitoringSheetList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("No monitoring sheet found "),
                        const SizedBox(
                          height: 10,
                        ),
                        _monitoringSheetController.medicalRecord.value.userId == authController.user['id'] ? ElevatedButton(
                            onPressed: () {
                              Get.toNamed(
                                '/add-monitoring_sheet',
                                // pass the last monitoring sheet day of the list to the next screen
                                arguments: DateTime.now().subtract(Duration(days: 1)),
                              );
                            },
                            child: const Text("Create new")):Container(),
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
                                        const Text(
                                          "medical record : ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            "#${_monitoringSheetController.medicalRecord.value.id}"),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Patient : ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            "${_monitoringSheetController.patient.value.firstName} ${_monitoringSheetController.patient.value.lastName} #${_monitoringSheetController.patient.value.id}"),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Doctor : ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            "${_monitoringSheetController.medicalRecord.value.doctorName}"),
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
                                    onPressed: _monitoringSheetController
                                            .isFirstMonitoringSheet()
                                        ? null
                                        : () {
                                            _monitoringSheetController
                                                .previousMonitoringSheet();
                                          },
                                    icon: const Icon(
                                      Icons.arrow_left,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    "${_monitoringSheetController.currentMonitoringSheet.value.fillingDate.toString().substring(0, 10)} (${DateFormat('EEEE').format(_monitoringSheetController.currentMonitoringSheet.value.fillingDate!).substring(0, 3)})",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    onPressed: _monitoringSheetController
                                            .isLastMonitoringSheet()
                                        ? null
                                        : () {
                                            _monitoringSheetController
                                                .nextMonitoringSheet();
                                          },
                                    icon: const Icon(
                                      Icons.arrow_right,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                              _monitoringSheetController.currentMonitoringSheet
                                          .value.filledBy?.isNotEmpty ??
                                      false
                                  ? _monitoringSheetController
                                                  .currentMonitoringSheet
                                                  .value
                                                  .filledById ==
                                              authController.user.value['id'] ||
                                          _monitoringSheetController
                                                  .medicalRecord.value.userId ==
                                              authController.user.value['id']
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
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 12.0),
                                                    child: ElevatedButton(
                                                      style:
                                                          ElevatedButton.styleFrom(
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
                                                      child: const Text("Update"),
                                                    ),
                                                  ),
                                                ),
                                                // a icon button to delete the monitoring sheet
                                                _monitoringSheetController
                                                            .medicalRecord
                                                            .value
                                                            .userId ==
                                                        authController.user['id']
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
                                  : _monitoringSheetController
                                                  .medicalRecord.value.userId ==
                                              authController.user.value['id'] &&
                                          (_monitoringSheetController
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
                              _monitoringSheetController
                                          .medicalRecord.value.userId ==
                                      authController.user.value['id']
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed: DeleteDay,
                                              child: const Text("Delete"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                              ,
                              // if the monitoring sheet is not filled yet , a button to fill it
                              _monitoringSheetController.currentMonitoringSheet
                                          .value.filledById ==
                                      null && authController.isNurse()
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
                                                print(_monitoringSheetController
                                                    .currentMonitoringSheet
                                                    .value
                                                    .filledById);
                                                // Get.toNamed(
                                                //     '/fillMonitoringSheet/${_monitoringSheetController.currentMonitoringSheet.value.id}');
                                              },
                                              child: const Text("Fill"),
                                            ),
                                          ),
                                        ),
                                        _monitoringSheetController.medicalRecord
                                                    .value.userId ==
                                                authController.user['id']
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
                                          'checkup #${_monitoringSheetController.currentMonitoringSheet.value.id}',
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    const DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'result',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: <DataRow>[
                                    DataRow(
                                      cells: <DataCell>[
                                        const DataCell(
                                          Text('temperature',
                                              style: Styles.type,
                                              textAlign: TextAlign.center),
                                        ),
                                        DataCell(Text(
                                          '${_monitoringSheetController.currentMonitoringSheet.value.temperature ?? "-"}',
                                          style: Styles.result,
                                        )),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        const DataCell(Text(
                                          'blood_pressure',
                                          style: Styles.type,
                                        )),
                                        DataCell(Text(
                                          _monitoringSheetController
                                                  .currentMonitoringSheet
                                                  .value
                                                  .bloodPressure ??
                                              '-',
                                          style: Styles.result,
                                        )),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        const DataCell(Text(
                                          'urine',
                                          style: Styles.type,
                                        )),
                                        DataCell(Text(
                                          "${_monitoringSheetController.currentMonitoringSheet.value.urine ?? "-"}",
                                          style: Styles.result,
                                        )),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        const DataCell(Text(
                                          'weight',
                                          style: Styles.type,
                                        )),
                                        DataCell(Text(
                                          "${_monitoringSheetController.currentMonitoringSheet.value.weight ?? "-"}",
                                          style: Styles.result,
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              _monitoringSheetController.currentMonitoringSheet
                                          .value.progressReport?.isEmpty ??
                                      true
                                  ? Container()
                                  : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: infoCard([
                                        const Text(
                                          "report",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          // textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          _monitoringSheetController
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
                              _monitoringSheetController
                                          .medicalRecord.value.userId ==
                                      authController.user.value['id']
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
                                                Get.toNamed('/update-monitoring_sheet-treatments' )?.then((value) => _monitoringSheetController.getMonitoringSheets());
                                              },
                                              child: _monitoringSheetController.currentMonitoringSheet.value.treatments?.isNotEmpty ?? true ?  Text("Update treatments") : Text("Add treatments"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),

                              // table of monitoring sheet treatments
                              _monitoringSheetController.currentMonitoringSheet
                                          .value.treatments?.isEmpty ??
                                      true
                                  ? Container()
                                  : ExpansionTile(
                                      title: const Center(
                                        child: Text(
                                          "Treatments",
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
                                                columns: const <DataColumn>[
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'treatment',
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'dose',
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'type',
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                rows: _monitoringSheetController
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
                        _monitoringSheetController.medicalRecord.value.userId ==
                                authController.user['id']
                            ? FloatingActionButton(
                                onPressed: () {
                                  Get.toNamed(
                                    '/add-monitoring_sheet',
                                    // pass the last monitoring sheet day of the list to the next screen
                                    arguments: _monitoringSheetController
                                        .monitoringSheetList.last.fillingDate,
                                  )?.then((value) {
                                    print('back from add new day ');
                                    _monitoringSheetController
                                        .currentMonitoringSheetIndex(
                                            _monitoringSheetController
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
        title: "Delete",
        middleText: "Are you sure you want to delete this day?",
        textConfirm: "Yes",
        textCancel: "No",
        confirmTextColor: Colors.white,
        cancelTextColor: Colors.redAccent,
        buttonColor: Colors.red,
        backgroundColor: Colors.white,
        onConfirm: () async {
          print("deleting monitoring sheet");
          await Api.deleteMonitoringSheetDay(
              _monitoringSheetController.patientId.value,
              _monitoringSheetController.medicalRecordId.value,
              _monitoringSheetController.currentMonitoringSheet.value.id!);
          // _monitoringSheetController.currentMonitoringSheetIndex.value--;
          _monitoringSheetController.getMonitoringSheets();
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
              const Text(
                "Filled by : ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                  "${_monitoringSheetController.currentMonitoringSheet.value.filledBy!['first_name']} ${_monitoringSheetController.currentMonitoringSheet.value.filledBy!['last_name']}"),
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
