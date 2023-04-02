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
              .then((value) => exit(0));
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
      baseUrl: 'http://10.0.2.2:8000/api/',
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 5), // 5 seconds
      receiveTimeout: Duration(seconds: 5), // 5 seconds

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

// end of initializeInterceptor

// static Future<Response> getGenres() async {
//   return dio.get('/api/genres');
// } //end of getGenres
//
// static Future<Response> getMovies({
//   int page = 1,
//   String? type,
//   int? genreId,
//   int? actorId,
// }) async {
//   return dio.get('/api/movies', queryParameters: {
//     'page': page,
//     'type': type,
//     'genre_id': genreId,
//     'actor_id': actorId,
//   });
// } //end of getMovies
//
// static Future<Response> getActors({required int movieId}) async {
//   return dio.get('/api/movies/${movieId}/actors');
// } //end of actors
//
// static Future<Response> getRelatedMovies({required int movieId}) async {
//   return dio.get('/api/movies/${movieId}/related_movies');
// } //end of actors
//
// static Future<Response> login({required Map<String, dynamic> loginData}) async {
//   FormData formData = FormData.fromMap(loginData);
//   return dio.post('/api/login', data: loginData);
// } //end of login
//
// static Future<Response> register({required Map<String, dynamic> registerData}) async {
//   FormData formData = FormData.fromMap(registerData);
//   return dio.post('/api/register', data: formData);
// } //end of register
//
// static Future<Response> getUser() async {
//   return dio.get('/api/user');
// } //end of getUser
} //end of api
