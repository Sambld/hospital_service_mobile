import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Utils/ResponsiveFontSizes.dart';
import '../../Constants/Constants.dart';
import '../../Controllers/Dashboard/DoctorDashboardController.dart';
import '../../Widgets/NavigationDrawerWidget.dart';

class DoctorDashboardScreen extends StatelessWidget {
  DoctorDashboardScreen({Key? key}) : super(key: key);
  final controller = Get.put(DoctorDashboardController());



  @override
  Widget build(BuildContext context) {
    ResponsiveFontSize.initialize(context);
    return Obx(
      () => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          flexibleSpace: kAppBarColor,
          title: Text('Dashboard'.tr),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${"Welcome".tr} ${controller.doctor['first_name']} ${controller.doctor['last_name']}',
                  style: const TextStyle(
                      fontFamily: 'Euclid',
                      fontSize: 18,
                      color: Color(0xff252631)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoCard(
                    title: 'Total Patients'.tr,
                    value: controller.patientsCount.toString(),
                    color: const Color(0xffF9F9F9),
                  ),
                  InfoCard(
                    title: 'Inpatients'.tr,
                    value: controller.medicalRecords.length.toString(),
                    color: const Color(0xffF9F9F9),
                    corner: 'effect2.svg',
                  ),
                ],
              ),
              // Add the TabBar to switch between tabs
              TabBar(
                tabs: [
                  // make the tabs text have 2 lines

                  Tab(
                    child: Text(
                      "${"Active Records".tr} (${controller.activeMedicalRecords.length})",
                      style: TextStyle(
                          fontSize: ResponsiveFontSize.medium(),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Latest Updates".tr,
                      style: TextStyle(
                          fontSize: ResponsiveFontSize.medium(),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
              ),
              // Add the TabBarView to display the content of each tab
              Obx(
                ()=> Expanded(
                  child: TabBarView(
                    children: [
                      if (controller.medicalRecordsLoading.value)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
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
                                () => TextFormField(
                                  controller: controller.searchController.value,
                                  onChanged: (value) {
                                    controller.search(value);
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        '${'Search'.tr} :  ${'Patient'.tr} , ${'Bed Number'.tr}',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: controller.search.isNotEmpty
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  '(${controller.activeMedicalRecordsSearch.length})'),
                                              IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: () {
                                                  controller.search('');
                                                  controller
                                                      .searchController.value
                                                      .clear();
                                                },
                                              ),
                                            ],
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: MyActiveMedicalRecords()),
                          ],
                        ),

                      // Content of the first tab

                      // Content of the second tab
                      LatestUpdates(),
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

class MyActiveMedicalRecords extends StatelessWidget {
  final controller = Get.find<DoctorDashboardController>();

  MyActiveMedicalRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
       return controller.getActiveMedicalRecords();
      },
      child: ListView(
        children: [
          Obx(() {
            if (controller.medicalRecordsLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (controller.medicalRecords.isEmpty) {
                return Center(
                  child: Text('No Active Medical Records'.tr),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.activeMedicalRecordsSearch.length,
                  itemBuilder: (context, index) {
                    final medicalRecord = controller.activeMedicalRecordsSearch[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {
                            Get.toNamed('/medical-record-details', arguments: {
                              'medicalRecordId': medicalRecord.id,
                              'patientId': medicalRecord.patient!.id,
                            });
                          },
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '${medicalRecord.patient!.firstName!}  ${medicalRecord.patient!.lastName!}',
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
                                // condition

                                Text(
                                  '${'Bed Number'.tr} : ${medicalRecord.bedNumber}',
                                  style: TextStyle(
                                    fontFamily: 'Euclid',
                                    fontSize: ResponsiveFontSize.small(),
                                    color: const Color(0xff252631),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${'Condition'.tr} : ${medicalRecord.conditionDescription}',
                                  style: TextStyle(
                                    fontFamily: 'Euclid',
                                    fontSize: ResponsiveFontSize.small(),
                                    color: const Color(0xff252631),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '#${medicalRecord.id}',
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
          }),
        ],
      ),
    );
  }
}

class LatestUpdates extends StatelessWidget {
  LatestUpdates({super.key});

  final controller = Get.find<DoctorDashboardController>();

  @override
  Widget build(BuildContext context) {
    if (controller.updatesLoading.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (controller.latestMSUpdates.isEmpty) {
        return Center(
          child: Text('No Updates In The Last 24h'.tr),
        );
      }
      return Obx(
        ()=> RefreshIndicator(
          onRefresh: () { return controller.getLatestUpdates(); },
          child: ListView(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.latestMSUpdates.length,
                  itemBuilder: (context, index) {
                    final ms = controller.latestMSUpdates[index];
                    // get patient name by looping through all medical records and check if the medical record id is equal to the ms record id then get the patient name
                    final patient = ms.medicalRecord?.patient;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 8.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {
                            Get.toNamed('/monitoring-sheet', arguments: {
                              'medicalRecordId': ms.recordId,
                              'patientId': patient?.id,
                              'id': controller.latestMSUpdates[index].id,
                            });
                          },
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Monitoring Sheet'.tr,
                              style: TextStyle(
                                fontFamily: 'Euclid',
                                fontSize: ResponsiveFontSize.medium(),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff252631),
                              ),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // condition
                                //patient name
                                Text(
                                  '${'Patient'.tr} : ${patient?.firstName!} ${patient?.lastName!}',
                                  style: TextStyle(
                                    fontFamily: 'Euclid',
                                    fontSize: ResponsiveFontSize.small(),
                                    color: const Color(0xff252631),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${'Filling Date'.tr} : ${ms.fillingDate!.day == DateTime.now().day ? 'Today'.tr : '${ms.fillingDate.toString().substring(0, 10)} '}  ${ms.createdAt!.toLocal().toString().substring(10, 16)}',
                                  style: TextStyle(
                                    fontFamily: 'Euclid',
                                    fontSize: ResponsiveFontSize.small(),
                                    color: const Color(0xff252631),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${'Filled by'.tr} : ${ms.filledBy!['first_name']} ${ms.filledBy!['last_name']}',
                                  style: TextStyle(
                                    fontFamily: 'Euclid',
                                    fontSize: ResponsiveFontSize.small(),
                                    color: const Color(0xff252631),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xff252631),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      );
    }
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
    // get card width based on screen size ( dont use Responsive )
    final cardWidth = MediaQuery.of(context).size.width / 2 - 20;


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
              width: cardWidth,
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
