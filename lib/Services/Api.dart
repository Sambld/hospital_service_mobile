import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GET;
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

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
        // print('${response.data}');
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
              .then((value) => Get.offNamed('dashboard'));
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
      baseUrl: 'http://10.0.2.2:8000/api/',
      // baseUrl: 'http://192.168.1.8:8001/api/',
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 15), 

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

  static Future<Response> getPatient({required int id}) async {
    return dio.get('patients/$id?withMedicalRecords');
  }

  static Future<Response> addPatient(Map<String, dynamic> formData) async {
    return dio.post('patients', data: formData);
  }
  static Future<Response> editPatient(int? id , Map<String, dynamic> formData) async {
    return dio.put('patients/$id', data: formData);
  }


  static Future<Response> getMedicalRecord({required int patientId , required int medicalRecordId}) async {
    return dio.get('patients/$patientId/medical-records/$medicalRecordId?withDoctor=true');
  }

  static Future<Response> addMedicalRecord(int patientId , Map<String, dynamic> formData) async {
    return dio.post('patients/$patientId/medical-records', data: formData);
  }
  static Future<Response> editMedicalRecord(int patientId, int medicalRecordId , Map<String, dynamic> formData) async {
    return dio.put('patients/$patientId/medical-records/$medicalRecordId', data: formData);
  }

  static Future<Response> getMonitoringSheets({required int patientId , required int medicalRecordId}) async {
    return dio.get('patients/$patientId/medical-records/$medicalRecordId/monitoring-sheets');
  }





} //end of api
