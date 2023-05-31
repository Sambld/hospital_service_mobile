import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:infectious_diseases_service/Constants/Constants.dart';
import 'package:infectious_diseases_service/Utils/ResponsiveFontSizes.dart';
import 'package:infectious_diseases_service/Widgets/NavigationDrawerWidget.dart';

import '../../Controllers/AuthController.dart';
import '../../Controllers/Dashboard/NurseDashboardController.dart';

class NurseDashboardScreen extends StatelessWidget {
  NurseDashboardScreen({Key? key}) : super(key: key);
  final controller = Get.put(NurseDashboardController());
  final authController = Get.find<AuthController>();

  final List<Tab> tabs = <Tab>[
    // make the tabs text have 2 lines

    Tab(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Available Monitoring Sheet".tr,
          style: TextStyle(
              fontSize: ResponsiveFontSize.small(),
              fontWeight: FontWeight.normal),
        ),
      ),
    ),
    Tab(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Previously Filled".tr,
          style: TextStyle(
              fontSize: ResponsiveFontSize.small(),
              fontWeight: FontWeight.normal),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        flexibleSpace: kAppBarColor,
        title: Text(
          'Dashboard'.tr,
          style: TextStyle(fontSize: ResponsiveFontSize.medium()),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: tabs.length,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${'Welcome'.tr} ${authController.user['first_name'] ?? ''} ${authController.user['last_name'] ?? ''}',
                  style: const TextStyle(
                      fontFamily: 'Euclid',
                      fontSize: 18,
                      color: Color(0xff252631)),
                  // textAlign: TextAlign.left,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => InfoCard(
                      title: 'Today Available Monitoring Sheets'.tr,
                      value: controller.todayAvailableMonitoringSheets.length
                          .toString(),
                      color: Colors.blueAccent,
                    ),
                  ),
                  Obx(
                    () => InfoCard(
                      title: 'My Total Filled Monitoring Sheets'.tr,
                      value: controller.nurseTotalFilledMonitoringSheets.value
                          .toString(),
                      color: Colors.greenAccent,
                      corner: 'effect2.svg',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              TabBar(
                tabs: tabs,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
              ),
              Obx(
                () => Expanded(
                  child: TabBarView(
                    children: [
                      // Content of the first tab
                      if (controller.isLoading.value)
                        const Center(child: CircularProgressIndicator())
                      else
                        Column(
                          children: [
                            Container(
                              height: 40,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                              ),
                              child: Obx(
                                ()=> TextFormField(
                                  controller: controller.searchController.value,


                                  onChanged: (value) {
                                    controller.search(value);
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '${'Search'.tr} ${'patient'.tr} , ${'Bed Number'.tr}',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: controller.search.isNotEmpty? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('(${controller.todayAvailableMonitoringSheetsSearch.length})'),
                                        IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {

                                            controller.search('');
                                            controller.searchController.value.clear();
                                          } ,
                                        ),
                                      ],
                                    ):null,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: AvailableMonitoringSheets()),
                          ],
                        ),
                      // Content of the second tab
                      LatestFilledMonitoringSheets(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvailableMonitoringSheets extends StatelessWidget {
  AvailableMonitoringSheets({Key? key}) : super(key: key);
  final controller = Get.find<NurseDashboardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        if (controller.todayAvailableMonitoringSheets.isEmpty) {
          return const Center(child: Text('No Available Monitoring Sheets'));
        } else {
          return SingleChildScrollView(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.todayAvailableMonitoringSheetsSearch.length,
              itemBuilder: (context, index) {
                final monitoringSheet =
                    controller.todayAvailableMonitoringSheetsSearch[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () {
                        // navigate to the monitoring sheet
                        Get.toNamed('/monitoring-sheet', arguments: {
                          'medicalRecordId': monitoringSheet.recordId,
                          'patientId': monitoringSheet.medicalRecord?.patient?.id,
                          'id': monitoringSheet.id
                        });
                      },
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '${monitoringSheet.medicalRecord?.patient?.firstName} ${monitoringSheet.medicalRecord?.patient?.lastName}',
                          style: TextStyle(
                            fontFamily: 'Euclid',
                            fontSize: ResponsiveFontSize.large(),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff252631),
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Filling date
                            Text(
                              '${'Doctor'.tr}: ${monitoringSheet.medicalRecord?.doctorName}',
                              style: TextStyle(
                                fontFamily: 'Euclid',
                                fontSize: ResponsiveFontSize.small(),
                                color: const Color(0xff252631),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // Bed number
                            Text(
                              '${'Bed Number'.tr}: ${monitoringSheet.medicalRecord?.bedNumber}',
                              style: TextStyle(
                                fontFamily: 'Euclid',
                                fontSize: ResponsiveFontSize.small(),
                                color: const Color(0xff252631),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // Condition
                            Text(
                              '${'Condition'.tr}: ${monitoringSheet.medicalRecord?.conditionDescription}',
                              style: TextStyle(
                                fontFamily: 'Euclid',
                                fontSize: ResponsiveFontSize.small(),
                                color: const Color(0xff252631),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(
                              height: 5,
                            ),
                            // Filled by nurse name
                          ],
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Monitoring sheet ID
                          Text(
                            '#${monitoringSheet.id}',
                            style: const TextStyle(
                              fontFamily: 'Euclid',
                              fontSize: 14,
                              color: Color(0xff252631),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff252631),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }
    });
  }
}

class LatestFilledMonitoringSheets extends StatelessWidget {
  final controller = Get.find<NurseDashboardController>();

  LatestFilledMonitoringSheets({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        if (controller.latestFilledMonitoringSheets.isEmpty) {
          return const Center(child: Text('No Available Monitoring Sheets'));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.latestFilledMonitoringSheets.length,
            itemBuilder: (context, index) {
              final monitoringSheet =
                  controller.latestFilledMonitoringSheets[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      // navigate to the monitoring sheet
                      Get.toNamed('/monitoring-sheet', arguments: {
                        'medicalRecordId': monitoringSheet.recordId,
                        'patientId': monitoringSheet.medicalRecord?.patient?.id,
                        'id': monitoringSheet.id
                      });
                    },
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '${monitoringSheet.medicalRecord?.patient?.firstName} ${monitoringSheet.medicalRecord?.patient?.lastName}',
                        style: TextStyle(
                          fontFamily: 'Euclid',
                          fontSize: ResponsiveFontSize.large(),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff252631),
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Filling date
                          Text(
                            '${'Doctor'.tr}: ${monitoringSheet.medicalRecord?.doctorName}',
                            style: TextStyle(
                              fontFamily: 'Euclid',
                              fontSize: ResponsiveFontSize.small(),
                              color: const Color(0xff252631),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // Bed number
                          Text(
                            '${'Bed Number'.tr}: ${monitoringSheet.medicalRecord?.bedNumber}',
                            style: TextStyle(
                              fontFamily: 'Euclid',
                              fontSize: ResponsiveFontSize.small(),
                              color: const Color(0xff252631),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // Condition
                          Text(
                            '${'Filling Date'.tr}: ${monitoringSheet.updatedAt.toString().substring(0, 16)}',
                            style: TextStyle(
                              fontFamily: 'Euclid',
                              fontSize: ResponsiveFontSize.small(),
                              color: const Color(0xff252631),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(
                            height: 5,
                          ),
                          // Filled by nurse name
                        ],
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Monitoring sheet ID
                        Text(
                          '#${monitoringSheet.id}',
                          style: const TextStyle(
                            fontFamily: 'Euclid',
                            fontSize: 14,
                            color: Color(0xff252631),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff252631),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }
    });
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard(
      {Key? key,
      required this.title,
      required this.value,
      required this.color,
      this.corner = 'effect.svg'})
      : super(key: key);
  final String title;
  final String value;
  final Color color;
  final String corner;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          ClipPath(
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: Container(
              width: 180,
              height: 100,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.blueAccent,
                    width: 6.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 4.0, left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                                fontFamily: 'Euclid',
                                fontSize: ResponsiveFontSize.xSmall(),
                                color: const Color(0xcc252631)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 32),
                    child: Row(
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                              fontFamily: 'Euclid',
                              fontSize: ResponsiveFontSize.xLarge(),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xcc25265e)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            width: 40,
            height: 40,
            child: SvgPicture.asset('assets/images/$corner'),
          ),
        ],
      ),
    );
  }
}
