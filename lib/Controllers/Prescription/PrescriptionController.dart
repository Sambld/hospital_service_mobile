import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Models/Medicine.dart';
import '../../Models/MedicineRequest.dart';
import '../../Models/Patient.dart';
import '../../Models/Prescription.dart';
import '../../Services/Api.dart';
import 'PrescriptionsController.dart';



class PrescriptionController extends GetxController{
  var PC = Get.find<PrescriptionsController>();
  var isLoading = false.obs;
  var medicineRequestsLoading = false.obs;
  var prescription = Prescription().obs;
  var medicines = <Medicine>[].obs;
  var editNameController = TextEditingController();


  @override
  void onInit() {
    fetchPrescription(Get.arguments['prescriptionId']);
    fetchMedicines();

    super.onInit();

  }


  // prescription medicine requests getter (sort by medicine request status (Pending , Approved , Rejected))
  List<MedicineRequest> get prescriptionMedicineRequests {
    return prescription.value.medicineRequests!.toList()..sort((a, b) => a.status!.compareTo(b.status!));
  }



  Future<void> fetchPrescription(int prescriptionId) async{
    try{
      isLoading(true);
      final res = await Api.getPrescription(patientId: PC.patientId.value, medicalRecordId: PC.medicalRecordId.value, prescriptionId: prescriptionId);
      final data = res.data as Map<String, dynamic>;
      prescription(Prescription.fromJson(data));
      // print(prescription.value.medicineRequests![0].medicine!.name);
    }finally{
      isLoading(false);
    }
  }

  Future<void> fetchMedicines() async{
    try{
      final res = await Api.getMedicines();
      final data = res.data['data'] as List<dynamic>;
      medicines(data.map((item) => Medicine.fromJson(item)).toList());
    }finally{

    }
  }

  void updatePrescriptionName() {
    try {
      isLoading(true);
      Api.updatePrescriptionName(patientId: PC.patientId.value, medicalRecordId: PC.medicalRecordId.value, prescriptionId: prescription.value.id!, formData: {'name': editNameController.text});
      fetchPrescription(prescription.value.id!);
    } finally {
      isLoading(false);
    }
  }

  void deletePrescription() {
    try {
      isLoading(true);
      Api.deletePrescription(patientId: PC.patientId.value, medicalRecordId: PC.medicalRecordId.value, prescriptionId: prescription.value.id!);
      Get.back();
    } finally {
      isLoading(false);
    }
  }

  Future<void> getPrescriptionPdf() async {
    try {
      final pdf = await Api.getPrescriptionPdf(patientId: PC.patientId.value, medicalRecordId: PC.medicalRecordId.value, prescriptionId: prescription.value.id!);
      // Get the directory for storing files

      await requestPermission();
      final status = await Permission.storage.request();
      if (status.isDenied) {
        return print('Permission denied');
      }


      // // Get the directory for storing files
      // final dir = await getApplicationDocumentsDirectory();
      // print(dir.path);
      Patient patient = await Api.getPatient(id: PC.patientId.value , withMedicalRecords: false).then((value) => Patient.fromJson(value.data['data']['patient']));
      // Create a new file with the desired name
      print(patient.firstName);
      final file = File('/storage/emulated/0/Download/prescription_${patient.firstName}_${patient.lastName}_${prescription.value.createdAt.toString().substring(0,10)}.pdf');

      // Write the PDF data to the file
      await file.writeAsBytes(pdf.data, flush: true);

      // Show a snackbar to indicate the file is being downloaded
      Get.snackbar(
        'Downloaded',
        'The file is being saved to Downloads folder ',
        titleText:  const Text('Downloaded' , style: TextStyle(fontSize: 16 , color: Colors.white),),
        messageText:  const Text('The file is being saved to Downloads folder ', style: TextStyle(fontSize: 16 , color: Colors.white)),
        colorText: CupertinoColors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        // green color to indicate success
        backgroundColor: CupertinoColors.systemGreen,


      );    } catch (e) {
      print(e);
    }
  }

  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      status = await Permission.storage.request();
    }
    if (status.isDenied) {
      throw Exception('Permission denied');
    }
  }

   addMedicineRequest(Map<String, dynamic> map) async {
    try {
      // medicineRequestsLoading(true);
      Api.addMedicineRequest(patientId: PC.patientId.value, medicalRecordId: PC.medicalRecordId.value, dataForm: map, prescriptionId: prescription.value.id!);
      await fetchPrescription(prescription.value.id!);
    } finally {
      // medicineRequestsLoading(false);
    }
  }

  Future<void> deleteMedicineRequest(int id) async {
    try {
      await Api.deleteMedicineRequest(patientId: PC.patientId.value, medicalRecordId: PC.medicalRecordId.value, prescriptionId: prescription.value.id!, medicineRequestId: id);
      await fetchPrescription(prescription.value.id!);
    } finally {
    }
  }

  editMedicineRequest(int id, Map<String, dynamic> map) async {
    try {
      await Api.editMedicineRequest(patientId: PC.patientId.value, medicalRecordId: PC.medicalRecordId.value, prescriptionId: prescription.value.id!, medicineRequestId: id, dataForm: map);
       await fetchPrescription(prescription.value.id!);
    } finally {
    }

  }




}