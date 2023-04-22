import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/Dashboard/DoctorDashboardController.dart';
import '../../Widgets/NavigationDrawerWidget.dart';

class DoctorDashboardScreen extends StatelessWidget {
  DoctorDashboardScreen({Key? key}) : super(key: key);
  final controller = Get.put(DoctorDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        flexibleSpace: kAppBarColor,
        title: const Text('Dashboard'),
      ),
      body: Obx(
        ()=> SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${"Welcome".tr} Dr. ${controller.doctor['first_name']} ${controller.doctor['last_name']}',
                style: TextStyle(
                    fontFamily: 'Euclid', fontSize: 22, color: Color(0xff252631)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              infoCard(
                title: 'My Patients'.tr,
                value: controller.patientsCount.toString(),
                color: Color(0xffF9F9F9),

              ),
              infoCard(
                title: 'My Medical Records'.tr,
                value: controller.medicalRecords.value.length.toString(),
                color: Color(0xffF9F9F9),
                corner: 'effect2.svg',
              ),
            ],
            )
          ],
        )),
      ),
    );
  }
}

class infoCard extends StatelessWidget {
  const infoCard(
      {Key? key, required this.title, required this.value, required this.color , this.corner = 'effect.svg'})
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
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.blueAccent,
                    width: 6.0,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontFamily: 'Euclid',
                              fontSize: 13,
                              color: Color(0xcc252631)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                    child: Row(
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                              fontFamily: 'Euclid',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xcc25265e)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: SvgPicture.asset('assets/images/${corner}'),
            bottom: 0,
            right: 0,
            width: 40,
            height: 40,
          ),
        ],
      ),
    );
  }
}
