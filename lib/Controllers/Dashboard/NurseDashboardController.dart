import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/MonitoringSheet.dart';

import '../../Services/Api.dart';

class NurseDashboardController extends GetxController {
  var isLoading = false.obs;
  var todayAvailableMonitoringSheets = <MonitoringSheet>[].obs;
  var latestFilledMonitoringSheets = <MonitoringSheet>[].obs;
  var nurseTotalFilledMonitoringSheets = 0.obs;

  @override
  Future<void> onInit() async {
    await getTodayAvailableMonitoringSheets();
    await getNurseLatestFilledMonitoringSheets();
    await getNurseTotalFilledMonitoringSheets();
    super.onInit();
  }

  Future<void> getTodayAvailableMonitoringSheets() async {
    isLoading(true);

    try {
      final res = await Api.dio.get('monitoring-sheets/today-available');
      todayAvailableMonitoringSheets(res.data
          .map<MonitoringSheet>((e) => MonitoringSheet.fromJson(e))
          .toList());
    } catch (e) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> getNurseLatestFilledMonitoringSheets() async {

    try {
      final res = await Api.dio.get('monitoring-sheets/my-latest-filled');
      latestFilledMonitoringSheets(res.data
          .map<MonitoringSheet>((e) => MonitoringSheet.fromJson(e))
          .toList());


    } catch (e) {
      rethrow;
    }
  }

  Future<void> getNurseTotalFilledMonitoringSheets() async {

    try {
      final res = await Api.dio.get('monitoring-sheets/total-filled');
      print(res);
      nurseTotalFilledMonitoringSheets(res.data['count']);
    } catch (e) {
      rethrow;
    }
  }
}
