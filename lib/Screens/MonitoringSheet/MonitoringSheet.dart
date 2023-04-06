import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/MonitoringSheet/MonitoringSheetController.dart';

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
                        ElevatedButton(
                            onPressed: () {}, child: const Text("Create new"))
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Obx(
                                () => infoCard([
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                       Text(
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        authController.user.value['id'] || _monitoringSheetController.medicalRecord.value.userId == authController.user.value['id']
                                    ?
                                    // if the monitoring sheet is filled by the current user , a button to update it
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          onPressed: () {
                                            Get.toNamed(
                                                '/updateMonitoringSheet/${_monitoringSheetController.currentMonitoringSheet.value.id}');
                                          },
                                          child: const Text("Update"),
                                        ),
                                      )
                                    :
                                    // if the monitoring sheet is filled by another user , text to show who filled it
                                    filledByCard()
                                :
                            _monitoringSheetController.medicalRecord.value.userId == authController.user.value['id'] && (_monitoringSheetController.currentMonitoringSheet
                                .value.filledBy?.isNotEmpty ?? false) ?  filledByCard() : Container() ,
                                // if the monitoring sheet is not filled yet , a button to fill it
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Get.toNamed(
                                        //     '/fillMonitoringSheet/${_monitoringSheetController.currentMonitoringSheet.value.id}');
                                      },
                                      child: const Text("Fill"),
                                    ),
                                  ),

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
                                : infoCard([
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

                            const SizedBox(
                              height: 20,
                            ),

                            // table of monitoring sheet treatments
                            _monitoringSheetController.currentMonitoringSheet
                                        .value.treatments?.isEmpty ??
                                    true
                                ? Container()
                                : ExpansionTile(
                                    title: const Center(
                                      child: Text("Treatments"),
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
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                    child: Text(
                                                      'dose',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                    child: Text(
                                                      'type',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic),
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
                                                          style: Styles.result,
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
      ),
    );
  }

  Padding filledByCard() {
    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: infoCard(
                                        [
                                          Row(
                                            children: [
                                              const Text(
                                                "Filled by : ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
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
