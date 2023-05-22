import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Utils/ResponsiveFontSizes.dart';
import '../Controllers/AuthController.dart';
import '../Controllers/MedicalRecord/MedicalRecordController.dart';

class SecondTab extends StatelessWidget {
  final medicalRecordController = Get.find<MedicalRecordController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints boxConstraints) {
        //
        final axisCount = boxConstraints.maxWidth ~/ 170;
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axisCount,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      _buildButton('Monitoring Sheet'.tr, Icons.monitor,
                          Colors.blue.shade400, () {
                        Get.toNamed('/monitoring-sheet', arguments: {
                          "patientId": medicalRecordController.patient.value.id,
                          "medicalRecordId":
                              medicalRecordController.medicalRecord.value.id
                        });
                      }),
                      $(_buildButton('Observations'.tr, Icons.remove_red_eye,
                          Colors.purple.shade400, () {
                        Get.toNamed('/observations', arguments: {
                          "patientId": medicalRecordController.patient.value.id,
                          "medicalRecordId":
                              medicalRecordController.medicalRecord.value.id
                        });
                      })),
                      $(_buildButton('Complementary Examinations'.tr,
                          Icons.assignment, Colors.green.shade400, () {
                        Get.toNamed('/complementary-examinations', arguments: {
                          "patientId": medicalRecordController.patient.value.id,
                          "medicalRecordId":
                              medicalRecordController.medicalRecord.value.id
                        });
                      })),
                      $(_buildButton('Prescriptions'.tr, Icons.medical_services,
                          Colors.red.shade400, () {
                        Get.toNamed('/prescriptions', arguments: {
                          "patientId": medicalRecordController.patient.value.id,
                          "medicalRecordId":
                              medicalRecordController.medicalRecord.value.id
                        });
                      })),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(
      String title, IconData iconData, Color color, Function onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 64.0,
              color: Colors.white,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveFontSize.large(),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget $(child) {
    if (authController.isNurse()) {
      return Container();
    } else {
      return child;
    }
  }
}
