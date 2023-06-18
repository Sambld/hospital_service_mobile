import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/Prescription/PrescriptionsController.dart';
import '../../Utils/ResponsiveFontSizes.dart';

class PrescriptionsScreen extends StatelessWidget {
  PrescriptionsScreen({Key? key}) : super(key: key);

  final controller = Get.put(PrescriptionsController());
  final authController = Get.find<AuthController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        if (controller.isLoading.value ||
            controller.medicalRecord.value.isClosed() ||
            !authController.isDoctor()) {
          return const SizedBox();
        } else {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              // confirmation dialog
              Get.defaultDialog(
                contentPadding: const EdgeInsets.all(18),

                content: Text("${"Create New Prescription".tr}?"),
                titleStyle: const TextStyle(fontSize: 16),
                textConfirm: "Yes".tr,
                textCancel: "No".tr,
                cancelTextColor: Colors.green,
                buttonColor: Colors.green,
                confirmTextColor: Colors.white,
                onConfirm: () {

                  Get.back();
                  controller.addPrescription();
                  // Get.back();
                },
              );



            },
          );
        }
      }),
      appBar: AppBar(
        flexibleSpace: kAppBarColor,
        title: Text('Prescriptions'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (controller.prescriptions.isEmpty) {
            return const Center(child: Text('No Prescriptions Found'));
          } else {
            return ListView.builder(
              itemCount: controller.prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = controller.prescriptions[index];
                return Card(
                  elevation: 1,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Text(
                            // doctor
                            '${"Doctor".tr} :',
                            style: TextStyle(fontSize: ResponsiveFontSize.medium() , fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            // doctor name
                            prescription.doctor!.fullName(),
                            style: TextStyle(fontSize: ResponsiveFontSize.medium() , fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${"Date".tr} : ${DateFormat('dd/MM/yyyy HH:mm').format(prescription.createdAt!)}'),
                          // images count

                            Text(
                                '${"Medicine Requests".tr} : ${prescription.medicineRequests!.length}'),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {
                      // TODO: Navigate to observation details screen
                      Get.toNamed('/prescription',
                              arguments: {'prescriptionId': prescription.id})
                          ?.then((value) => controller.fetchPrescriptions());
                    },
                  ),
                );
              },
            );
          }
        }
      }),
    );
  }
}
