import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Controllers/MedicalRecord/MedicalRecordsController.dart';
import 'package:infectious_diseases_service/Utils/ResponsiveFontSizes.dart';

import '../Models/MedicalRecord.dart';

class MedicalRecordCard extends StatelessWidget {
  final MedicalRecord medicalRecord;

  const MedicalRecordCard({
    Key? key,
    required this.medicalRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveFontSize.initialize(context);
    Color borderColor = medicalRecord.isActive() ? Colors.green : Colors.redAccent;

    return GestureDetector(
      onTap: () {

        // Add logic to navigate to medical record details screen

        Get.toNamed('/medical-record-details', arguments: {"medicalRecordId": medicalRecord.id  , "patientId": medicalRecord.patient?.id})?.then((value) => Get.find<MedicalRecordsController>().getMedicalRecords()) ;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(color: borderColor, width: 8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${"Patient".tr}: ',
                  style:  TextStyle(
                    fontSize: ResponsiveFontSize.medium(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${medicalRecord.patient?.firstName ?? ''} ${medicalRecord.patient?.lastName ?? ''}',
                  style:  TextStyle(fontSize: ResponsiveFontSize.small(),),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${"Doctor".tr}: ',
                  style:  TextStyle(
                    fontSize: ResponsiveFontSize.medium(),
                    fontWeight: FontWeight.bold,
                  ),

                ),
                Text(
                  '${medicalRecord.doctorName}',
                  style:  TextStyle(fontSize: ResponsiveFontSize.small(),),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${"Condition".tr}: ',
                  style:  TextStyle(
                    fontSize: ResponsiveFontSize.medium(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${medicalRecord.conditionDescription}',
                    style:  TextStyle(fontSize: ResponsiveFontSize.small(),),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${"Status".tr}: ',
                  style:  TextStyle(
                    fontSize: ResponsiveFontSize.medium(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  medicalRecord.isActive() ? "Active".tr : "Closed".tr,
                  style: TextStyle(
                    fontSize: ResponsiveFontSize.small(),
                    color: medicalRecord.isActive() ? Colors.green : Colors.redAccent,
                  ),
                ),
                //id
                Text(
                  ' ( #${medicalRecord.id} )',
                  style: TextStyle(
                    fontSize: ResponsiveFontSize.small(),
                    color: medicalRecord.isActive() ? Colors.green : Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
