import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GET;
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infectious_diseases_service/Constants/Constants.dart';
import 'package:infectious_diseases_service/Controllers/AuthController.dart';
import 'package:infectious_diseases_service/Screens/SplashScreen.dart';

import '../Screens/LoginPage.dart';

class Api {
  static void initializeInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) async {
        var token = await GetStorage().read('token');

        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        };

        request.headers.addAll(headers);
        print('${request.method} ${request.path}');
        print('${request.headers}');
        return handler.next(request); //continue
      },
      onResponse: (response, handler) {
        if (response.statusCode == 404) {
          throw response.data['message'];
        }
        ;

        return handler.next(response); // continue
      },
      onError: (error, handler) {
        print('${error.response?.data['message']}');
        if (error.type == DioErrorType.connectionTimeout ||
            error.type == DioErrorType.receiveTimeout) {
          GET.Get.snackbar(
            'error'.tr,
            'Request timeout Please try again later',
            snackPosition: GET.SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          Future.delayed(Duration(seconds: 2))
              .then((value) => Get.find<AuthController>().redirect());
          return handler.next(error);
          // continue
        }
        if (error.response?.requestOptions.path == 'user') {
          Get.offNamed('/login');
          return handler.next(error); // continue without showing snack bar
        }
        if (error.response?.statusCode == 404) {
          return handler.next(error); // continue without showing snack bar
        }

        // if (error.response?.requestOptions.path == 'patients') {
        //   return handler.next(error); // continue without showing snack bar
        // }
        if (GET.Get.isDialogOpen == true) {
          GET.Get.back();
        }

        GET.Get.snackbar(
          'error'.tr,
          '${error.response?.data['message']}',
          snackPosition: GET.SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return handler.next(error); //continue
      },
    ));
  }

  static final dio = Dio(
    BaseOptions(
      // baseUrl: 'http://134.122.75.238:8000/api/',
      // baseUrl: 'http://10.0.2.2:8000/api/',
      baseUrl: '${apiUrl}/api/',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  static Future<Response> login(username, password) async {
    return dio.post('login', data: {
      'username': username,
      'password': password,
    });
  }

  static Future<void> logout() async {
    await dio.post('logout');
    await GetStorage().remove('token');
    Get.offNamed('/login');
  }

  static Future<Response> getUser() async {
    return dio.get('user');
  }

  static Future<Response> getPatients(
      {int? page = 1,
      String? search = '',
      bool? inHospitalOnly = false}) async {
    final inHospital = inHospitalOnly == true ? 'inHospitalOnly' : '';
    return dio.get('patients?page=$page&q=$search&$inHospital');
  }

  static Future<Response> getPatient(
      {required int id, bool? withMedicalRecords = true}) async {
    return dio.get(
        'patients/$id${withMedicalRecords == true ? '?withMedicalRecords' : ''}');
  }

  static Future<Response> addPatient(Map<String, dynamic> formData) async {
    return dio.post('patients', data: formData);
  }

  static Future<Response> editPatient(
      int? id, Map<String, dynamic> formData) async {
    return dio.put('patients/$id', data: formData);
  }

  static Future<Response> getMedicalRecord(
      {required int patientId, required int medicalRecordId}) async {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId?withDoctor=true');
  }

  static Future<Response> addMedicalRecord(
      int patientId, Map<String, dynamic> formData) async {
    return dio.post('patients/$patientId/medical-records', data: formData);
  }

  static Future<Response> editMedicalRecord(
      int patientId, int medicalRecordId, Map<String, dynamic> formData) async {
    return dio.put('patients/$patientId/medical-records/$medicalRecordId',
        data: formData);
  }

  static Future<Response> getMonitoringSheets(
      {required int patientId, required int medicalRecordId}) async {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets');
  }

  static Future<Response> addMonitoringSheet(
      int patientId, int medicalRecordId, Map<String, dynamic> formData) async {
    return dio.post(
        'patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets',
        data: formData);
  }

  static Future<Response> editMonitoringSheet(
      int patientId,
      int medicalRecordId,
      int monitoringSheetId,
      Map<String, dynamic> formData) async {
    return dio.put(
        'patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets/$monitoringSheetId',
        data: formData);
  }

  static Future<Response> editMonitoringSheetDay(
      int patientId,
      int medicalRecordId,
      int monitoringSheetId,
      Map<String, dynamic> formData) async {
    return dio.put(
        'patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets/$monitoringSheetId',
        data: formData);
  }

  static Future<Response> deleteMonitoringSheetDay(
      int patientId, int medicalRecordId, int monitoringSheetId) async {
    return dio.delete(
        'patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets/$monitoringSheetId');
  }

  static Future<Response> getMonitoringSheetTreatments(
      {required int patientId,
      required int medicalRecordId,
      required int monitoringSheetId}) async {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets/$monitoringSheetId/treatments');
  }

  static Future<Response> addMonitoringSheetTretment(
      int patientId,
      int medicalRecordId,
      int monitoringSheetId,
      Map<String, dynamic> formData) async {
    return dio.post(
        'patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets/$monitoringSheetId/treatments',
        data: formData);
  }

  static Future<Response> editMonitoringSheetTretment(
      int patientId,
      int medicalRecordId,
      int monitoringSheetId,
      int treatmentId,
      Map<String, dynamic> formData) async {
    return dio.put(
        'patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets/$monitoringSheetId/treatments/$treatmentId',
        data: formData);
  }

  static Future<Response> deleteMonitoringSheetTreatment(int patientId,
      int medicalRecordId, int monitoringSheetId, int treatmentId) async {
    return dio.delete(
        'patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets/$monitoringSheetId/treatments/$treatmentId');
  }

  static Future<Response> getMedicineById({required int id}) async {
    return dio.get('medicines/$id');
  }

  // get medical record observations
  static Future<Response> getObservations(
      {required int patientId, required int medicalRecordId}) async {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/observations');
  }

  // get ovseravtion by id
  static Future<Response> getObservationById(
      {required int patientId,
      required int medicalRecordId,
      required int observationId}) async {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/observations/$observationId');
  }

  // getObservationImages
  static Future<Response> getObservationImages(
      {required int patientId,
      required int medicalRecordId,
      required int observationId}) async {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/observations/$observationId/images');
  }

  // add image to observation
  static Future<Response> addObservationImage(
      {required int patientId,
      required int medicalRecordId,
      required int observationId,
      required FormData formData}) async {
    return dio.post(
        'patients/$patientId/medical-records/$medicalRecordId/observations/$observationId/images',
        data: formData);
  }

  static Future<Response> addObservation(
      {required int patientId,
      required int medicalRecordId,
      required Map<String, dynamic> formData}) async {
    return dio.post(
        'patients/$patientId/medical-records/$medicalRecordId/observations',
        data: formData);
  }

  static Future<Response> getMedicines() async {
    return dio.get('medicines?all');
  }

  static Future<Response> deleteObservationImage(
      {required int patientId,
      required int medicalRecordId,
      required int observationId,
      int? imageId}) {
    return dio.delete(
        'patients/$patientId/medical-records/$medicalRecordId/observations/$observationId/images/$imageId');
  }

  static Future<Response> updateObservationName(
      {required int patientId,
      required int medicalRecordId,
      required int observationId,
      required Map formData}) {
    return dio.put(
        'patients/$patientId/medical-records/$medicalRecordId/observations/$observationId',
        data: formData);
  }

  static Future<Response> deleteObservation(
      {required int patientId,
      required int medicalRecordId,
      required int observationId}) {
    return dio.delete(
        'patients/$patientId/medical-records/$medicalRecordId/observations/$observationId');
  }

  static Future<Response> getComplementaryExaminations(
      {required int patientId, required int medicalRecordId}) {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/examinations');
  }

  static Future<Response> addComplementaryExamination(
      {required patientId, required medicalRecordId, required Map formData}) {
    return dio.post(
        'patients/$patientId/medical-records/$medicalRecordId/examinations',
        data: formData);
  }

  static Future<Response> editComplementaryExamination(
      {required int patientId,
      required int medicalRecordId,
      required int examinationId,
      required Map<String, dynamic> formData}) {
    return dio.put(
        'patients/$patientId/medical-records/$medicalRecordId/examinations/$examinationId',
        data: formData);
  }

  static Future<Response> deleteComplementaryExamination(
      {required int patientId,
      required int medicalRecordId,
      required int examinationId}) {
    return dio.delete(
        'patients/$patientId/medical-records/$medicalRecordId/examinations/$examinationId');
  }

  static Future<Response> getMedicineRequests(
      {required int patientId, required int medicalRecordId}) {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/medicine-requests');
  }

  static Future<Response> addMedicineRequest(
      {required int patientId,
      required int medicalRecordId,
      required int prescriptionId,
      required Map dataForm}) {
    return dio.post(
        'patients/$patientId/medical-records/$medicalRecordId/prescriptions/$prescriptionId/medicine-requests',
        data: dataForm);
  }

  static Future<Response> editMedicineRequest(
      {required int patientId,
      required int medicalRecordId,
      required int prescriptionId,
      required int medicineRequestId,
      required Map dataForm}) {
    return dio.put(
        'patients/$patientId/medical-records/$medicalRecordId/prescriptions/$prescriptionId/medicine-requests/$medicineRequestId',
        data: dataForm);
  }

  static Future<Response> deleteMedicineRequest(
      {required int patientId,
      required int medicalRecordId,
      required int prescriptionId,
      required int medicineRequestId}) {

    return dio.delete(
        'patients/$patientId/medical-records/$medicalRecordId/prescriptions/$prescriptionId/medicine-requests/$medicineRequestId');
  }

  static Future<Response> getMedicalRecords(
      {required int page,
      required String search,
      required bool isActive,
      required bool isMine}) async {
    return dio.get(
        'medical-records?page=$page${isActive ? '&isActive' : ''}${isMine ? '&mineOnly' : ''}&withPagination=true&q=$search');
  }

  static Future<Response> getDoctorMedicalRecords({required int doctorId}) {
    return dio.get('medical-records?doctorId=$doctorId');
  }

  // getActiveMedicalRecords
  static Future<Response> getActiveMedicalRecords() {
    return dio.get('medical-records?isActive=true');
  }

  static Future<Response> getPrescriptions(
      {required int patientId, required int medicalRecordId}) {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/prescriptions');
  }

  static Future<Response> getPrescription(
      {required int patientId,
      required int medicalRecordId,
      required int prescriptionId}) {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/prescriptions/$prescriptionId');
  }

  static Future<Response> addPrescription(
      {required int patientId,
      required int medicalRecordId,
      }) {
    return dio.post(
        'patients/$patientId/medical-records/$medicalRecordId/prescriptions');
  }

  static Future<Response> updatePrescriptionName(
      {required int patientId,
      required int medicalRecordId,
      required int prescriptionId,
      required Map<String, String> formData}) {
    return dio.put(
        'patients/$patientId/medical-records/$medicalRecordId/prescriptions/$prescriptionId',
        data: formData);
  }

  static Future<Response> deletePrescription(
      {required int patientId,
      required int medicalRecordId,
      required int prescriptionId}) {
    return dio.delete(
        'patients/$patientId/medical-records/$medicalRecordId/prescriptions/$prescriptionId');
  }

  static Future<Response> getPrescriptionPdf(
      {required int patientId,
      required int medicalRecordId,
      required int prescriptionId}) {
    return dio.get(
        'patients/$patientId/medical-records/$medicalRecordId/prescriptions/$prescriptionId/pdf',
        options: Options(responseType: ResponseType.bytes));
  }
} //end of api
